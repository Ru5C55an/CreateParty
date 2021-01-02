//
//  SecondCreatePartyViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 29.12.2020.
//

import UIKit

class SecondCreatePartyViewController: UIViewController {
    
    let aboutParty = AboutMeInputText(placeholder: "Напишите о своей вечеринке...", isEditable: true)
    let typeLabel = UILabel(text: "Тип")
    
    var pickedType = ""
    var pickerData: [String] = [String]()
    let typePicker = UIPickerView()
    
    let countPeopleLabel = UILabel(text: "Кол-во гостей")
    let countPeople = UILabel(text: "1")
    let countStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 1000
        return stepper
    }()
    
    let nextButton = UIButton(title: "Далее")
    let alcoLabel = UILabel(text: "Присутсвие алкоголя")
    let alcoSwitcher = UISwitch()
    
    private let currentUser: PUser
    internal var party: Party
    
    init(party: Party?, currentUser: PUser?) {
        self.party = party!
        self.currentUser = currentUser!
       
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        nextButton.applyGradients(cornerRadius: nextButton.layer.cornerRadius, from: .bottomLeading, to: .topTrailing, startColor: #colorLiteral(red: 0.7098039216, green: 0.7843137255, blue: 0.1921568627, alpha: 1), endColor: #colorLiteral(red: 0.2784313725, green: 0.6078431373, blue: 0.3529411765, alpha: 1))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        pickerData = ["Музыкальная", "Танцевальная", "Вписка", "Поэтическая", "Творческая", "Праздничная", "Игровая", "Научная", "Домашний хакатон", "Особая тематика"]
        
        pickedType = pickerData.first!
        
        typePicker.delegate = self
        typePicker.dataSource = self
        
        countStepper.addTarget(self, action: #selector(countStepperTapped), for: .valueChanged)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        setupConstraints()
    }
    
    @objc private func countStepperTapped() {
        countPeople.text = String(Int(countStepper.value))
    }
    
    @objc private func nextButtonTapped() {
        
        party.alco = String(alcoSwitcher.state.rawValue)
        party.maximumPeople = countPeople.text!
        
        let description = aboutParty.text!
        if description != aboutParty.savedPlaceholder {
            party.description = description
        }
        
        party.type = pickedType
        
        
        
        let thirdCreatePartyViewController = ThirdCreatePartyViewController(party: party, currentUser: currentUser)
        
        navigationController?.pushViewController(thirdCreatePartyViewController, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Setup constraints
extension SecondCreatePartyViewController {
    
    private func setupConstraints() {
        
        let typeStackView = UIStackView(arrangedSubviews: [typeLabel, typePicker], axis: .vertical, spacing: 0)
        let countPeopleStackView = UIStackView(arrangedSubviews: [countPeopleLabel, countPeople, countStepper], axis: .vertical, spacing: 8)
        countPeopleStackView.alignment = .center
        
        let alcoStackView = UIStackView(arrangedSubviews: [alcoLabel, alcoSwitcher], axis: .horizontal, spacing: 8)
        alcoStackView.alignment = .firstBaseline
        
        let stackView = UIStackView(arrangedSubviews: [typeStackView, countPeopleStackView], axis: .vertical, spacing: 32)
        
        view.addSubview(aboutParty)
        view.addSubview(stackView)
        view.addSubview(alcoStackView)
        view.addSubview(nextButton)
        
        aboutParty.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        countPeopleStackView.translatesAutoresizingMaskIntoConstraints = false
        alcoStackView.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            aboutParty.heightAnchor.constraint(equalToConstant: 128),
            aboutParty.topAnchor.constraint(equalTo: view.topAnchor, constant: 128),
            aboutParty.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            aboutParty.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: aboutParty.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44)
        ])
        
        NSLayoutConstraint.activate([
            alcoStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32),
            alcoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44)
        ])
        
        NSLayoutConstraint.activate([
            alcoSwitcher.centerYAnchor.constraint(equalTo: alcoLabel.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: alcoStackView.bottomAnchor, constant: 32),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44),
            nextButton.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
}

extension SecondCreatePartyViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        pickedType = String(pickerData[row])
    }
}

// MARK: - SwiftUI
import SwiftUI

struct SecondCreatePartyViewControllerProvider: PreviewProvider {
    
    static var previews: some View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let secondCreatePartyViewController = SecondCreatePartyViewController(party: nil, currentUser: nil)
        
        func makeUIViewController(context: Context) -> SecondCreatePartyViewController {
            return secondCreatePartyViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
