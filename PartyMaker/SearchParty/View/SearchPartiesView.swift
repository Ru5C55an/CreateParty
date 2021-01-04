//
//  searchPartiesView.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 03.01.2021.
//

import UIKit

class SearchPartiesView: UIView {
    
    let cityButton = UIButton(title: "Город", titleColor: #colorLiteral(red: 0.1921568627, green: 0.568627451, blue: 0.9882352941, alpha: 1), backgroundColor: #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9411764706, alpha: 1), isShadow: false, cornerRadius: 10)
    let dateAndTimePicker = UIDatePicker()
    
    var pickedType = ""
    var pickerData: [String] = [String]()
    let typePicker = UIPickerView()
    let typeTextField = UITextField()
    let typeButton = UIButton(title: "Тип", titleColor: #colorLiteral(red: 0.1921568627, green: 0.568627451, blue: 0.9882352941, alpha: 1), backgroundColor: #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9411764706, alpha: 1), isShadow: false, cornerRadius: 10)
    
    let countLabel = UILabel(text: "Кол-во человек")
    let countText = UILabel(text: "1")
    
    let countStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 1000
        return stepper
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pickerData = ["Музыкальная", "Танцевальная", "Вписка", "Поэтическая", "Творческая", "Праздничная", "Игровая", "Научная", "Домашний хакатон", "Особая тематика"]
        
        pickedType = pickerData.first!
        typePicker.delegate = self
        typePicker.dataSource = self
        typeTextField.inputView = typePicker
        
        typeTextField.text = "Тип вечеринки"
        
        dateAndTimePicker.datePickerMode = .dateAndTime
        
        let dateAndTypeStackView = UIStackView(arrangedSubviews: [dateAndTimePicker, typeTextField], axis: .horizontal, spacing: 8)
        let countStackView = UIStackView(arrangedSubviews: [countLabel, countText, countStepper], axis: .horizontal, spacing: 8)
        countStackView.distribution = .equalSpacing
        let stackView = UIStackView(arrangedSubviews: [cityButton, dateAndTypeStackView, countStackView], axis: .vertical, spacing: 8)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        countStepper.addTarget(self, action: #selector(countStepperTapped), for: .valueChanged)
        
        dismissPickerView()
    }
    
    @objc private func countStepperTapped() {
        countText.text = String(Int(countStepper.value))
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(doneTapped))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        typeTextField.inputAccessoryView = toolBar
    }
    
    @objc func doneTapped() {
        self.endEditing(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchPartiesView: UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
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
        
        pickedType = pickerData[row]
        typeTextField.text = pickedType
    }
}
