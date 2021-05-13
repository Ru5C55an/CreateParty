//
//  GamesViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 03.05.2021.
//

import UIKit
import Cards
import Foundation

class GamesViewController: UIViewController {

    let bottleGame = CardHighlight()
    let moreGamesLater = CardHighlight()
    
    let colors = [
    
        UIColor.red,
        UIColor.yellow,
        UIColor.blue,
        UIColor.green,
        UIColor.gray,
        UIColor.brown,
        UIColor.purple,
        UIColor.orange
    ]
    
    let bottleGameAbout = BottleGameAbout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCards()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
    }
    
    private func setupCards() {
        moreGamesLater.title = "Скоро\nбольше\nигр..."
        moreGamesLater.buttonText = "Открыть"
        moreGamesLater.itemTitle = "Отправь свою идею"
        moreGamesLater.itemSubtitle = "Открой карточку и заполни форму"
        moreGamesLater.delegate = self
        moreGamesLater.hasParallax = true
        
        var heads = [UIImage]()
        for i in 1...20 {
            heads.append(UIImage(named: "head\(i)")!)
        }
        
        bottleGame.delegate = self
        bottleGameAbout.modalPresentationStyle = .fullScreen
        bottleGame.shouldPresent(bottleGameAbout, from: self, fullscreen: true)
        
    
        bottleGame.buttonText = "ИГРАТЬ!"
        bottleGame.title = "Бутылочка"
        bottleGame.textColor = .white
        bottleGame.itemTitle = "Крутим, Мутим, Тусим"
        bottleGame.itemSubtitle = "Ееееееее 🤘"
        bottleGame.icon = "🍾".textToImage()
        
        bottleGame.backgroundImage = UIImage(named: "bottleGameCardBackground")?.sd_blurredImage(withRadius: 10)?.sd_tintedImage(with: UIColor(red: 0, green: 0, blue: 0, alpha: 0.4))
        bottleGame.contentMode = .scaleToFill
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupViews() {
        
        view.backgroundColor = .mainWhite()
        
        view.addSubview(moreGamesLater)
        view.addSubview(bottleGame)
        
        moreGamesLater.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(44)
            make.height.equalTo(200)
        }
        
        bottleGame.snp.makeConstraints { (make) in
            make.top.equalTo(moreGamesLater.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(44)
            make.height.equalTo(200)
        }
    }

    func random(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
}

extension GamesViewController: CardDelegate {
    
    func cardDidTapInside(card: Card) {
        
        if card == moreGamesLater {
            card.shadowColor = colors[random(min: 0, max: colors.count-1)]
            (card as! CardHighlight).title = "ТУЦ\n ТУЦ\n ТУЦ ТУЦ 😎"
        }
    }
    
    func cardHighlightDidTapButton(card: CardHighlight, button: UIButton) {
        
//        card.buttonText = "ОТКРЫТЬ!"
        
        if card == self.bottleGame {
          
            bottleGame.touchesCancelled(.init(), with: .none)
            let bottleGameVC = BottleGameVC()
            bottleGameAbout.dismiss(animated: true) { [unowned self] in
                self.navigationController?.pushViewController(bottleGameVC, animated: true)
            }
        }
    }
}
