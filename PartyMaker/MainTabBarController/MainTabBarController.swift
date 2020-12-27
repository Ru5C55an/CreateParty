//
//  MainTabBarController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 03.12.2020.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = .mainWhite()
        
        let partiesViewController = PartiesViewController()
        let searchPartyViewController = SearchPartyViewController()
        let createPartyViewController = CreatePartyTableViewController()
        let messaggesViewController = MessagesViewController()
        let profileViewController = ProfileViewController()
        
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        
        let partiesImage = UIImage(systemName: "sparkles.rectangle.stack", withConfiguration: boldConfig)!
        let searchImage = UIImage(systemName: "magnifyingglass", withConfiguration: boldConfig)!
        let createImage = UIImage(systemName: "plus", withConfiguration: boldConfig)!
        let messaggesImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfig)!
        let profileImage = UIImage(systemName: "person", withConfiguration: boldConfig)!
        
        viewControllers = [
            generateNavigationController(rootViewController: partiesViewController, title: "Вечеринки", image: partiesImage),
            generateNavigationController(rootViewController: messaggesViewController, title: "Сообщения", image: messaggesImage),
            generateNavigationController(rootViewController: searchPartyViewController, title: "Поиск", image: searchImage),
            generateNavigationController(rootViewController: createPartyViewController, title: "Создать", image: createImage),
            generateNavigationController(rootViewController: profileViewController, title: "Профиль", image: profileImage)
        ]
        
//        checkLoggedIn()
    }
    
//    private func checkLoggedIn() {
//
//        if Auth.auth().currentUser == nil {
//            DispatchQueue.main.async {
//                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                let welcomeViewController = storyBoard.instantiateViewController(withIdentifier: "WelcomeViewController")
//                self.present(welcomeViewController, animated: true)
//            }
//        }
//    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        
        return navigationVC
    }
}

// MARK: - SwiftUI
import SwiftUI

struct MainTabBarControllerProvider: PreviewProvider {
    
    static var previews: some View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let mainTabBarController = MainTabBarController()
        
        func makeUIViewController(context: Context) -> MainTabBarController {
            return mainTabBarController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
