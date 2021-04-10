//
//  SecondCreatePartyViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 29.12.2020.
//

import UIKit

class SecondCreatePartyViewController: UIViewController {
    
    // MARK: - UI Elements
    private let partyNameLabel = UILabel(text: "Название вечеринки")
    private let partyNameTextField = BubbleTextField(placeholder: "Например, Вечеринка у Децла дома")
    
    private let aboutPartyLabel = UILabel(text: "О вечеринке")
    private let aboutPartyTextView = AboutInputText(placeholder: "Напишите о своей вечеринке...", isEditable: true)
    private let typeLabel = UILabel(text: "Тип")
    
    private let typePicker = UIPickerView()
    
    private let countPeopleLabel = UILabel(text: "Кол-во гостей")
    private let countPeople = UILabel(text: "1", font: .sfProDisplay(ofSize: 22, weight: .medium))
    private lazy var countStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 1000
        return stepper
    }()
    
    private let nextButton = UIButton(title: "Далее")
    private let alcoLabel = UILabel(text: "Присутсвие алкоголя")
    private let alcoSwitcher = UISwitch()
    
    // MARK: - Properties
    private var pickedType = ""
    private var pickerData: [String] = [String]()
    
    private let currentUser: PUser
    internal var party: Party
    
    // MARK: - Lifecycle
    init(party: Party, currentUser: PUser) {
        self.party = party
        self.currentUser = currentUser
        
        super.init(nibName: nil, bundle: nil)
        
        title = "Расскажите о своей вечеринке"
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
    
    // MARK: - Handlers
    @objc private func countStepperTapped() {
        countPeople.text = String(Int(countStepper.value))
    }
    
    @objc private func nextButtonTapped() {
        
        // Тут проблема с тем, что в aboutParty.text есть placeholder, который всегда заполнен и поэтому проверка на заполненность aboutParty не работает
        guard Validators.isFilled(partyName: partyNameTextField.text, aboutParty: aboutPartyTextView.textView.text)
        else {
            self.showAlert(title: "Ошибка", message: "Не все поля заполнены")
            return
        }
        
        // Но с помощью этого это фиксится
        if let description = aboutPartyTextView.textView.text, description != aboutPartyTextView.savedPlaceholder {
            party.description = description
        } else {
            self.showAlert(title: "Ошибка", message: "Не все поля заполнены")
        }
        
        party.name = partyNameTextField.text!
        party.alco = String(alcoSwitcher.state.rawValue)
        party.currentPeople = "0"
        party.maximumPeople = countPeople.text!
        party.type = pickedType
        
        let thirdCreatePartyViewController = ThirdCreatePartyViewController(party: party, currentUser: currentUser)
        navigationController?.pushViewController(thirdCreatePartyViewController, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    deinit {
        print("deinit", SecondCreatePartyViewController.self)
    }
}

// MARK: - Setup constraints
extension SecondCreatePartyViewController {
    
    private func setupConstraints() {
        
        let partynameStackView = UIStackView(arrangedSubviews: [partyNameLabel, partyNameTextField], axis: .vertical, spacing: 8)
        
        let aboutPartyStackView = UIStackView(arrangedSubviews: [aboutPartyLabel, aboutPartyTextView], axis: .vertical, spacing: 8)
        
        let typeStackView = UIStackView(arrangedSubviews: [typeLabel, typePicker], axis: .vertical, spacing: 0)
        
        let countPeopleStackView = UIStackView(arrangedSubviews: [countPeopleLabel, countPeople, countStepper], axis: .horizontal, spacing: 8)
        countPeopleStackView.distribution = .equalSpacing
        
        let alcoStackView = UIStackView(arrangedSubviews: [alcoLabel, alcoSwitcher], axis: .horizontal, spacing: 8)
        alcoStackView.alignment = .firstBaseline
        
        let stackView = UIStackView(arrangedSubviews: [partynameStackView, aboutPartyStackView, typeStackView, countPeopleStackView], axis: .vertical, spacing: 16)
        
        view.addSubview(stackView)
        view.addSubview(alcoStackView)
        view.addSubview(nextButton)
        
        
        stackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(112)
            make.leading.trailing.equalToSuperview().inset(44)
        }
        
        partyNameTextField.snp.makeConstraints { (make) in
            make.height.equalTo(48)
        }
        
        aboutPartyTextView.snp.makeConstraints { (make) in
            make.height.equalTo(92)
        }
        
        alcoStackView.snp.makeConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(44)
        }
        
        alcoSwitcher.snp.makeConstraints { (make) in
            make.centerY.equalTo(alcoLabel.snp.centerY)
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.top.equalTo(alcoStackView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(44)
            make.height.equalTo(64)
        }
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
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
        
        let secondCreatePartyViewController = SecondCreatePartyViewController(party: Party(city: "", location: "", userId: "", imageUrlString: "", type: "", maximumPeople: "", currentPeople: "", id: "", date: "", startTime: "", endTime: "", name: "", price: "", description: "", alco: ""), currentUser: PUser(username: "", email: "", avatarStringURL: "", description: "", sex: "", birthday: "", interestsList: "", smoke: "", alco: "", personalColor: "", id: ""))
        
        func makeUIViewController(context: Context) -> SecondCreatePartyViewController {
            return secondCreatePartyViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
