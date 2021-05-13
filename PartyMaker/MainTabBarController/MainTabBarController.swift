//
//  MainTabBarController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 03.12.2020.
//

import UIKit
import RAMAnimatedTabBarController

class MainTabBarController: RAMAnimatedTabBarController {
    
    private let currentUser: PUser
    
    init(currentUser: PUser) {
        
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = .mainWhite()
        
        let partiesViewController = PartiesViewController(currentUser: currentUser)
        let searchPartyViewController = SearchPartyViewController()
        let createPartyViewController = CreatePartyViewController(currentUser: currentUser)
        let chatlistViewController = ChatlistViewController(currentUser: currentUser)
        let profileViewController = ProfileViewController(currentUser: currentUser)
        let gamesViewController = GamesViewController()
        
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        
        let partiesImage = UIImage(systemName: "sparkles.rectangle.stack", withConfiguration: boldConfig)!
        let searchImage = UIImage(systemName: "magnifyingglass", withConfiguration: boldConfig)!
        let createImage = UIImage(systemName: "plus", withConfiguration: boldConfig)!
        let messaggesImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfig)!
        let profileImage = UIImage(systemName: "person", withConfiguration: boldConfig)!
        let gamesImage = UIImage(systemName: "gamecontroller", withConfiguration: boldConfig)!

        viewControllers = [
//            generateNavigationController(rootViewController: searchPartyViewController, title: "Поиск", image: searchImage, animation: RAMBounceAnimation(), tag: 0),
            generateNavigationController(rootViewController: profileViewController, title: "Профиль", image: profileImage, animation: RAMBounceAnimation(), tag: 0),
            generateNavigationController(rootViewController: createPartyViewController, title: "Создать", image: createImage, animation: RAMBounceAnimation(), tag: 1),
            generateNavigationController(rootViewController: partiesViewController, title: "Вечеринки", image: partiesImage, animation: RAMBounceAnimation(), tag: 2),
            generateNavigationController(rootViewController: chatlistViewController, title: "Сообщения", image: messaggesImage, animation: RAMBounceAnimation(), tag: 3),
            generateNavigationController(rootViewController: gamesViewController, title: "Игры", image: gamesImage, animation: RAMBounceAnimation(), tag: 4),
        ]
    }

    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage, animation: RAMBounceAnimation, tag: Int) -> UIViewController {

        let navigationVC = UINavigationController(rootViewController: rootViewController)
        let tabBarItem = RAMAnimatedTabBarItem(title: title, image: image, tag: tag)
        tabBarItem.animation = animation
        navigationVC.tabBarItem = tabBarItem

        return navigationVC
    }
    
    deinit {
        print("deinit", MainTabBarController.self)
    }
}

// MARK: - SwiftUI
import SwiftUI

struct MainTabBarControllerProvider: PreviewProvider {
    
    static var previews: some View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let mainTabBarController = MainTabBarController(currentUser: PUser(username: "", email: "", avatarStringURL: "", description: "", sex: "", birthday: "", interestsList: "", smoke: "", alco: "", personalColor: "", id: ""))
        
        func makeUIViewController(context: Context) -> MainTabBarController {
            return mainTabBarController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
