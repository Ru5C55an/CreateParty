//
//  BottleGameAbout.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 03.05.2021.
//

import UIKit

class BottleGameAbout: UIViewController {
        
    private let aboutGameLabel = UILabel(text: "Об игре", font: UIFont.sfProDisplay(ofSize: 16, weight: .medium), textColor: .systemRed)
    private let aboutGameText = UITextView()
    
    private let aboutSettingsLabel = UILabel(text: "Режимы", font: UIFont.sfProDisplay(ofSize: 16, weight: .medium), textColor: .systemYellow)
    private let aboutSettingsText = UITextView()
    
    private let aboutPlayersLabel = UILabel(text: "Выбор игроков", font: UIFont.sfProDisplay(ofSize: 16, weight: .medium), textColor: .systemPink)
    private let aboutPlayersText = UITextView()
    
    private let aboutHistoryLabel = UILabel(text: "Сохранение истории", font: UIFont.sfProDisplay(ofSize: 16, weight: .medium), textColor: .systemPink)
    private let aboutHistoryText = UITextView()
    
    private let aboutGameSceneIV = UIImageView(image: UIImage(named: "aboutGameScene"))
    private let aboutGameScene2IV = UIImageView(image: UIImage(named: "aboutGameScene2"))
    private let aboutCountPlayersIV = UIImageView(image: UIImage(named: "aboutCountPlayers"))
    private let aboutHistoryIV = UIImageView(image: UIImage(named: "aboutHistory"))
    private let aboutModesIV = UIImageView(image: UIImage(named: "aboutModes"))
    private let aboutSelectPlayersIV = UIImageView(image: UIImage(named: "aboutSelectPlayers"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aboutGameText.isScrollEnabled = false
        
        aboutGameText.text = "Правила игры просты: Крутим бутылочку, и ждем, пока она остановится на игроке, после чего он выполняет действия, в зависимости от выбранного режима игры"
        
        aboutSettingsText.isScrollEnabled = false
        
        aboutSettingsText.text = "Четыре режима игры:"
        
        
        aboutPlayersText.isScrollEnabled = false
        aboutPlayersText.text = "Максимальное кол-во игроков - 20. Необходимо выбрать изображение и имя игрока."
        
        aboutHistoryText.isScrollEnabled = false
        aboutHistoryText.text = "События игры будут сохраняться в историю"
        
        setupView()
        setupConstraints()
    }
    
    let scrollView = UIScrollView()
    
    private func setupView() {

        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(aboutGameLabel)
        scrollView.addSubview(aboutGameText)
        scrollView.addSubview(aboutSettingsLabel)
        scrollView.addSubview(aboutSettingsText)
        scrollView.addSubview(aboutPlayersLabel)
        scrollView.addSubview(aboutPlayersText)
        scrollView.addSubview(aboutHistoryLabel)
        scrollView.addSubview(aboutHistoryText)
    
        scrollView.addSubview(aboutGameSceneIV)
        scrollView.addSubview(aboutGameScene2IV)
        scrollView.addSubview(aboutCountPlayersIV)
        scrollView.addSubview(aboutHistoryIV)
        scrollView.addSubview(aboutModesIV)
        scrollView.addSubview(aboutSelectPlayersIV)
    }
    
    private func setupConstraints() {
        
        aboutGameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }
        
        aboutGameText.snp.makeConstraints { make in
            make.top.equalTo(aboutGameLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(20)
            make.width.equalTo(UIScreen.main.bounds.width - 40)
        }
        
        aboutGameSceneIV.layer.cornerRadius = 15
        aboutGameSceneIV.clipsToBounds = true
     
        aboutGameSceneIV.snp.makeConstraints { make in
            make.top.equalTo(aboutGameText.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(UIScreen.main.bounds.width / 2.3)
            make.height.equalTo((UIScreen.main.bounds.width - 40))
        }
        
        aboutGameScene2IV.layer.cornerRadius = 15
        aboutGameScene2IV.clipsToBounds = true
        aboutGameScene2IV.snp.makeConstraints { make in
            make.top.equalTo(aboutGameText.snp.bottom).offset(5)
            make.width.equalTo(UIScreen.main.bounds.width / 2.3)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo((UIScreen.main.bounds.width - 40))
        }
        
        aboutSettingsLabel.snp.makeConstraints { make in
            make.top.equalTo(aboutGameScene2IV.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        aboutSettingsText.snp.makeConstraints { make in
            make.top.equalTo(aboutSettingsLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(20)
            make.width.equalTo(UIScreen.main.bounds.width - 40)
        }
        
        aboutModesIV.layer.cornerRadius = 15
        aboutModesIV.clipsToBounds = true
        aboutModesIV.snp.makeConstraints { make in
            make.top.equalTo(aboutSettingsText.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(20)
            make.width.equalTo(UIScreen.main.bounds.width - 40)
            make.height.equalTo((UIScreen.main.bounds.width - 40) / 2)
        }
        
        aboutPlayersLabel.snp.makeConstraints { make in
            make.top.equalTo(aboutModesIV.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        aboutPlayersText.snp.makeConstraints { make in
            make.top.equalTo(aboutPlayersLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(20)
            make.width.equalTo(UIScreen.main.bounds.width - 40)
        }
        
        aboutCountPlayersIV.layer.cornerRadius = 15
        aboutCountPlayersIV.clipsToBounds = true
        aboutCountPlayersIV.snp.makeConstraints { make in
            make.top.equalTo(aboutPlayersText.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(UIScreen.main.bounds.width / 2.3)
            make.height.equalTo((UIScreen.main.bounds.width - 40))
            
        }
        
        aboutSelectPlayersIV.layer.cornerRadius = 15
        aboutSelectPlayersIV.clipsToBounds = true
        aboutSelectPlayersIV.snp.makeConstraints { make in
            make.top.equalTo(aboutPlayersText.snp.bottom).offset(5)
            make.right.equalToSuperview().inset(20)
            make.width.equalTo(UIScreen.main.bounds.width / 2.3)
            make.height.equalTo((UIScreen.main.bounds.width - 40))
        }
        
        aboutHistoryLabel.snp.makeConstraints { make in
            make.top.equalTo(aboutSelectPlayersIV.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        aboutHistoryText.snp.makeConstraints { make in
            make.top.equalTo(aboutHistoryLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(20)
            make.width.equalTo(UIScreen.main.bounds.width - 40)
        }
        
        aboutHistoryIV.layer.cornerRadius = 15
        aboutHistoryIV.clipsToBounds = true
        aboutHistoryIV.snp.makeConstraints { make in
            make.top.equalTo(aboutHistoryText.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width / 2)
            make.height.equalTo((UIScreen.main.bounds.width - 40))
            make.bottom.equalToSuperview().offset(-100)
        }
    }
}
