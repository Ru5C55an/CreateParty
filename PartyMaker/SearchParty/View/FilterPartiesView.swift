//
//  FilterPartiesView.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 03.01.2021.
//

import UIKit

class FilterPartiesView: UIView {
    
    let cityLabel = UILabel(text: "Город")
    let cityButton = UIButton(title: "Любой", titleColor: #colorLiteral(red: 0.1921568627, green: 0.568627451, blue: 0.9882352941, alpha: 1), backgroundColor: #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9411764706, alpha: 1), isShadow: false, cornerRadius: 4)
    let datePicker = UIDatePicker()
    
    let dateLabel = UILabel(text: "Дата")
    var pickedType = ""
    var pickerData: [String] = [String]()
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }()
    
    let typePicker = UIPickerView()
    let typeLabel = UILabel(text: "Тип")
    let typeTextField = TextFieldWithoutInteract()
    let typeBackgroundView = UIView()
    
    let countLabel = UILabel(text: "Кол-во человек")
    let segmentedCharCount = UISegmentedControl(items: [">", "<", "="])
    let countText = UILabel(text: "1")
    
    let priceLabel = UILabel(text: "Цена")
    let segmentedCharPrice = UISegmentedControl(items: [">", "<", "="])
    let priceTextField = BubbleTextField(placeholder: "99999", insets: 8, clearButtonMode: .never, keyboardType: .numberPad)
    
    let countStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 1000
        return stepper
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        segmentedCharCount.selectedSegmentIndex = 1
        
        pickerData = ["Музыкальная", "Танцевальная", "Вписка", "Поэтическая", "Творческая", "Праздничная", "Игровая", "Научная", "Домашний хакатон", "Особая тематика"]
        
        pickedType = pickerData.first!
        typePicker.delegate = self
        typePicker.dataSource = self
        
        typeTextField.font = UIFont.boldSystemFont(ofSize: 16)
        typeTextField.inputView = typePicker
        typeTextField.delegate = self
        typeTextField.text = "Любой"
        typeTextField.textColor = #colorLiteral(red: 0.1921568627, green: 0.568627451, blue: 0.9882352941, alpha: 1)
        
        typeBackgroundView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9411764706, alpha: 1)
        typeBackgroundView.layer.cornerRadius = 5
        
        datePicker.datePickerMode = .date
    
        setupToolbar()
        setupConstraints()
        addTargets()
    }
    
    private func addTargets() {
        countStepper.addTarget(self, action: #selector(countStepperTapped), for: .valueChanged)
    }
    
    @objc private func countStepperTapped() {
        countText.text = String(Int(countStepper.value))
    }
    
    private func setupToolbar() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(doneTapped))
        let anyButton = UIBarButtonItem(title: "Любой", style: .plain, target: self, action: #selector(anyTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([doneButton, flexibleSpace, anyButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        typeTextField.inputAccessoryView = toolBar
    }
    
    @objc private func doneTapped() {
        self.endEditing(true)
    }
    
    @objc private func anyTapped() {
        pickedType = "Любой"
        typeTextField.text = "Любой"
        self.endEditing(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FilterPartiesView {
    
    private func setupConstraints() {
                
        let priceStackView = UIStackView(arrangedSubviews: [priceLabel, segmentedCharPrice, priceTextField ], axis: .horizontal, spacing: 8)
        let countStackView = UIStackView(arrangedSubviews: [countLabel, segmentedCharCount, countText, countStepper], axis: .horizontal, spacing: 8)
        countStackView.distribution = .equalSpacing
        
        self.addSubview(countStackView)
        self.addSubview(typeBackgroundView)
        self.addSubview(cityLabel)
        self.addSubview(cityButton)
        self.addSubview(typeLabel)
        self.addSubview(typeTextField)
        
        self.addSubview(dateLabel)
        self.addSubview(datePicker)
        
        self.addSubview(priceStackView)
//        self.addSubview(priceLabel)
//        self.addSubview(segmentedCharPrice)
        
        cityLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview()
        }
        cityButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(-5)
            make.leading.equalTo(cityLabel.snp.trailing).offset(5)
        }
        
        typeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cityLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview()
        }
        typeTextField.snp.makeConstraints { (make) in
            make.centerY.equalTo(typeLabel.snp.centerY)
            make.leading.equalTo(typeLabel.snp.trailing).offset(10)
        }
        typeBackgroundView.snp.makeConstraints { (make) in
            make.edges.equalTo(typeTextField).inset(-5)
        }
        
        priceStackView.snp.makeConstraints { (make) in
            make.top.equalTo(typeLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview()
        }
        
        priceTextField.snp.makeConstraints { (make) in
            make.width.equalTo(60)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(priceStackView.snp.centerY)
            make.leading.equalTo(priceStackView.snp.trailing).offset(15)
        }
        
        datePicker.snp.makeConstraints { (make) in
            make.centerY.equalTo(priceStackView.snp.centerY)
            make.leading.equalTo(dateLabel.snp.trailing).offset(5)
            make.trailing.equalToSuperview()
        }
        
        countStackView.snp.makeConstraints { (make) in
            make.top.equalTo(priceStackView.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension FilterPartiesView: UIPickerViewDataSource, UIPickerViewDelegate {
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

extension FilterPartiesView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
