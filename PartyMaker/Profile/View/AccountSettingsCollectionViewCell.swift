//
//  AccountSettingsCollectionViewCell.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 10.04.2021.
//

import UIKit

enum AccountSettingsItem: Int, CaseIterable {
    case donut, approveEmail, changePassword, deleteAccount, changeEmail, logOut
    
    var title: String {
        switch self {
        case .donut:            return "Пожертвовать"
        case .approveEmail:     return "Подтвердить эл. почту"
        case .changePassword:   return "Сменть пароль"
        case .deleteAccount:    return "Удалить аккаунт"
        case .changeEmail:      return "Сменить почту"
        case .logOut:           return "Выход"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .donut:            return "🍩".textToImage()
        case .approveEmail:     return "📪".textToImage()
        case .changePassword:   return "🔏".textToImage()
        case .deleteAccount:    return "💔".textToImage()
        case .changeEmail:      return "📨".textToImage()
        case .logOut:           return "♻️".textToImage()
        }
    }
}

enum AccountSettingsItemWithoutApproveEmail: Int, CaseIterable {
    case donut, changePassword, deleteAccount, changeEmail, logOut
    
    var title: String {
        switch self {
        case .donut:            return "Пожертвовать"
        case .changePassword:   return "Сменть пароль"
        case .deleteAccount:    return "Удалить аккаунт"
        case .changeEmail:      return "Сменить почту"
        case .logOut:           return "Выход"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .donut:            return "🍩".textToImage()
        case .changePassword:   return "🔏".textToImage()
        case .deleteAccount:    return "💔".textToImage()
        case .changeEmail:      return "📨".textToImage()
        case .logOut:           return "♻️".textToImage()
        }
    }
}

class AccountSettingsCollectionViewCell: InCollectionViewCell {
    
    // MARK: - UI Elements
    private var imageView = UIImageView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.sfProRounded(ofSize: 18, weight: .medium)
        label.text = "label"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let backView = UIView()
    
    // MARK: - Properties
    private var cellType: AccountSettingsItem = .approveEmail
    private var cellTypeWithout: AccountSettingsItemWithoutApproveEmail = .changeEmail
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup views
    private func setupViews() {
        self.layer.addShadow(backgroundColor: .white, shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.15), cornerRadius: 35/2, shadowRadius: 3)
        
        addSubview(imageView)
        addSubview(backView)
        backView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        backView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.left.equalTo(imageView.snp.right).offset(10)
            make.top.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderWidth = 2
                layer.borderColor = UIColor.red.cgColor
                titleLabel.textColor = UIColor.red
            } else {
                layer.borderColor = UIColor.white.cgColor
                titleLabel.textColor = .black
            }
        }
    }
    
    override var isExclusiveTouch: Bool {
        didSet {
            if isExclusiveTouch {
                layer.borderWidth = 2
                layer.borderColor = UIColor.red.cgColor
                titleLabel.textColor = UIColor.red
            } else {
                layer.borderColor = UIColor.white.cgColor
                titleLabel.textColor = .black
            }
        }
    }
    
    func setCell(cellType: AccountSettingsItem) {
        self.cellType = cellType
        imageView.image = cellType.image
        titleLabel.text = cellType.title
        
        if cellType == .logOut {
            self.applyGradients(cornerRadius: self.layer.cornerRadius, from: .bottomLeading, to: .topTrailing, startColor: #colorLiteral(red: 0.6, green: 0.5098039216, blue: 0.1960784314, alpha: 1), endColor: #colorLiteral(red: 0.8196078431, green: 0.2980392157, blue: 0.1725490196, alpha: 1))
            titleLabel.textColor = .white
        }
    }
    
    func setCellWithout(cellTypeWithout: AccountSettingsItemWithoutApproveEmail) {
        self.cellTypeWithout = cellTypeWithout
        imageView.image = cellTypeWithout.image
        titleLabel.text = cellTypeWithout.title
        
        if cellTypeWithout == .logOut {
            self.applyGradients(cornerRadius: self.layer.cornerRadius, from: .bottomLeading, to: .topTrailing, startColor: #colorLiteral(red: 0.6, green: 0.5098039216, blue: 0.1960784314, alpha: 1), endColor: #colorLiteral(red: 0.8196078431, green: 0.2980392157, blue: 0.1725490196, alpha: 1))
            titleLabel.textColor = .white
        }
    }
}
