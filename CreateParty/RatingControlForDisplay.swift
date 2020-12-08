//
//  RatingControlForDisplay.swift
//  CreateParty
//
//  Created by Руслан Садыков on 08.12.2020.
//

import UIKit

//@IBDesignable дает возможность видеть изменения в коде в Interface Builder
@IBDesignable class RatingControlForDisplay: UIStackView {
    
    // MARK: - Properties
    var rating = 0
    
    private var ratingButtons = [UIButton]()
    
    // @IBInspectable добавляет данные свойства в Interface Builder. didSet нужен для запуска метода установки кнопок в момент изменения данных свойств в Interface Builder
    @IBInspectable var starSize: CGSize = CGSize(width: 22.0, height: 22.0) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    // MARK: - Initianization
    
    // Если мы не реализуем инициализатор в данном подклассе, то наследование инициализаторов не нужнл. В нашем же случае они нужны
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    // MARK: - Private mothods
    
    private func setupButtons() {
        // Необходимо для очищения, чтобы когда мы что-то меняем в Interface Builder оно начинало "сначала"
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
        // Присваивание изображений звезд
        let filledStar = UIImage(systemName: "star.fill")
        let emptyStar = UIImage(systemName: "star")
        
        for _ in 0..<starCount {
            
            // Создание кнопки
            let button = UIButton()
            
            // Установка изображения звезды для кнопки
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            
            // Добавление констреинтов
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Добавление кнопки в Stack View
            addArrangedSubview(button)
            
            //Добавление новой кнопки в массив ratingButtons
            ratingButtons.append(button)
        }
        
        updateButtonSelectionState()
        
    }
    
    private func updateButtonSelectionState() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
    
}
