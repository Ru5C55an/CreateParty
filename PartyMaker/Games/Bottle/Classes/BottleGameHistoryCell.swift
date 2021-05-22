//
//  BottleGameHistoryCell.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 19.05.2021.
//

import UIKit

class BottleGameHistoryCell: UITableViewCell, SelfConfiguringCell {
    
    static var reuseId: String = "BottleGameHistoryCell"
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    let dateLabel = UILabel(text: "", font: .sfProDisplay(ofSize: 14, weight: .regular))
    
    let firstPlayer = UILabel(text: "", font: .sfProDisplay(ofSize: 16, weight: .regular))
    let secondPlayer = UILabel(text: "", font: .sfProDisplay(ofSize: 16, weight: .regular))
    let actionText = UILabel(text: "", font: .sfProDisplay(ofSize: 18, weight: .regular))
    
    let iconView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        dateLabel.textColor = .systemGray
        
        firstPlayer.numberOfLines = 0
        firstPlayer.textAlignment = .center
        
        secondPlayer.numberOfLines = 0
        secondPlayer.textAlignment = .center
        
        actionText.textAlignment = .center
        
        backgroundColor = .clear
            
        setupConstraints()
    }
    
    func configure<U>(with value: U) where U : Hashable {
        guard let historyData: HistoryData = value as? HistoryData else { return }
        
        firstPlayer.text = historyData.firstPlayer
        secondPlayer.text = historyData.secondPlayer
        
        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.dateFormat = "HH:mm:ss"
            return dateFormatter
        }()
        
        dateLabel.text = dateFormatter.string(from: historyData.date) 
        
        switch historyData.mode {
    
        case .kiss:
            iconView.image = UIImage(named: HandButtons.love)
            actionText.text = "поцеловал(а)"
        case .drink:
            iconView.image = UIImage(named: HandButtons.drink)
            actionText.text = "выпил(а) алкоголь"
        case .desire:
            iconView.image = UIImage(named: HandButtons.idea)
            actionText.text = "выполнил(а) желание"
        case .secret:
            iconView.image = UIImage(named: HandButtons.secret)
            actionText.text = "рассказал(а) секрет"
        }

    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup constraints
extension BottleGameHistoryCell {
    
    private func setupConstraints() {
        contentView.addSubview(backView)
        backView.addSubview(firstPlayer)
        backView.addSubview(secondPlayer)
        backView.addSubview(actionText)
        backView.addSubview(dateLabel)
        backView.addSubview(iconView)

        backView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        firstPlayer.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
        }
        
        actionText.snp.makeConstraints { make in
            make.top.equalTo(firstPlayer.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
        }
        
        secondPlayer.snp.makeConstraints { make in
            make.top.equalTo(actionText.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
        
        iconView.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(30)
            make.right.top.equalToSuperview().inset(10)
        }
    }
}
