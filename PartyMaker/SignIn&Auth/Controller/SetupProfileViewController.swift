//
//  SetupProfileViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 25.12.2020.
//

import UIKit
import FirebaseAuth

class SetupProfileViewController: UIViewController {
    
    let welcomeLabel = UILabel(text: "Расскажите о себе!", font: .sfProRounded(ofSize: 26, weight: .regular))

    let fullNameLabel = UILabel(text: "Имя")
    let aboutMeLabel = UILabel(text: "Обо мне")
    let birtdayLabel = UILabel(text: "День рождения")
    let sexLabel = UILabel(text: "Пол")
    
    let fullNameTextField = BubbleTextField()
    let aboutMeTextField = AboutMeInputText(isEditable: true)
    
    let sexSegmentedControl = UISegmentedControl(first: "Мужской", second: "Женский")
    let birthdayDatepicker = UIDatePicker(datePickerMode: .date, preferredDatePickerStyle: .wheels)
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }()
    
    let nextButton = UIButton(title: "Далее", titleColor: .black, backgroundColor: .white)
    
    private let currentUser: User
    
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        
        if let username = currentUser.displayName {
            fullNameTextField.text = username
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupConstraints()
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc private func nextButtonTapped() {
        guard Validators.isFilled(username: fullNameTextField.text, description: aboutMeTextField.text, sex: sexSegmentedControl.titleForSegment(at: sexSegmentedControl.selectedSegmentIndex), birthday: dateFormatter.string(from: (birthdayDatepicker.date)))
        else {
            self.showAlert(title: "Ошибка", message: "Не все поля заполнены")
            return
        }
        
        let secondSetupProfileVC = SecondSetupProfileViewController(currentUser: currentUser,
                                                                    username: fullNameTextField.text!,
                                                                    description: aboutMeTextField.text!,
                                                                    birthday: dateFormatter.string(from: (birthdayDatepicker.date)),
                                                                    sex: sexSegmentedControl.titleForSegment(at: sexSegmentedControl.selectedSegmentIndex)!)
        secondSetupProfileVC.modalPresentationStyle = .fullScreen
        
        present(secondSetupProfileVC, animated: true, completion: nil)
    } 
}

// MARK: - Setup constraints
extension SetupProfileViewController {
    
    private func setupConstraints() {
    
        nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        aboutMeTextField.heightAnchor.constraint(equalToConstant: 128).isActive = true
        fullNameTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        let fullNameStackView = UIStackView(arrangedSubviews: [fullNameLabel, fullNameTextField],
                                            axis: .vertical,
                                            spacing: 8)
        let aboutMeStackView = UIStackView(arrangedSubviews: [aboutMeLabel, aboutMeTextField],
                                           axis: .vertical,
                                           spacing: 8)
        let sexStackView = UIStackView(arrangedSubviews: [sexLabel, sexSegmentedControl],
                                           axis: .vertical,
                                           spacing: 12)
        let birthdayStackView = UIStackView(arrangedSubviews: [birtdayLabel, birthdayDatepicker],
                                            axis: .vertical,
                                            spacing: 0)
        
        let stackView = UIStackView(arrangedSubviews: [fullNameStackView, aboutMeStackView, sexStackView, birthdayStackView, nextButton], axis: .vertical, spacing: 16)
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 44),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44)
        ])
    }
}

// MARK: - SwiftUI
import SwiftUI

struct SetupProfileViewControllerProvider: PreviewProvider {
    
    static var previews: some View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let setupProfileViewController = SetupProfileViewController(currentUser: Auth.auth().currentUser!)
        
        func makeUIViewController(context: Context) -> SetupProfileViewController {
            return setupProfileViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
