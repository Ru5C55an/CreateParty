//
//  SetupProfileViewController.swift
//  CreateParty
//
//  Created by Руслан Садыков on 25.12.2020.
//

import UIKit

class SetupProfileViewController: UIViewController {
    
    let welcomeLabel = UILabel(text: "Расскажите о себе!", font: .sfProRounded(ofSize: 26, weight: .regular))

    let fullNameLabel = UILabel(text: "Имя")
    let aboutMeLabel = UILabel(text: "Обо мне")
    let birtdayLabel = UILabel(text: "День рождения")
    let sexLabel = UILabel(text: "Пол")
    
    let fullNameTextField = BubbleTextField()
    let aboutMeTextField = AboutMeInputText()
    
    let sexSegmentedControl = UISegmentedControl(first: "Мужской", second: "Женский")
    let birthdayDatepicker = UIDatePicker(datePickerMode: .date, preferredDatePickerStyle: .wheels)
    
    let nextButton = UIButton(title: "Далее", titleColor: .black, backgroundColor: .white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupConstraints()
    }
}

// MARK: - Setup constraints
extension SetupProfileViewController {
    
    private func setupConstraints() {
        
        nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
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
        
        let stackView = UIStackView(arrangedSubviews: [fullNameStackView, aboutMeStackView, sexStackView, birthdayStackView, nextButton], axis: .vertical, spacing: 32)
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 64),
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
        
        let setupProfileViewController = SetupProfileViewController()
        
        func makeUIViewController(context: Context) -> SetupProfileViewController {
            return setupProfileViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
