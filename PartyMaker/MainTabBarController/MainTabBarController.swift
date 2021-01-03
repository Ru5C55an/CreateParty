//
//  MainTabBarController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 03.12.2020.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let currentUser: PUser
    
    init(currentUser: PUser = PUser(username: "asf",
                                    email: "asf",
                                    avatarStringURL: "asf",
                                    description: "asf",
                                    sex: "asf",
                                    birthday: "asf",
                                    id: "asf")) {
        
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
        
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        
        let partiesImage = UIImage(systemName: "sparkles.rectangle.stack", withConfiguration: boldConfig)!
        let searchImage = UIImage(systemName: "magnifyingglass", withConfiguration: boldConfig)!
        let createImage = UIImage(systemName: "plus", withConfiguration: boldConfig)!
        let messaggesImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfig)!
        let profileImage = UIImage(systemName: "person", withConfiguration: boldConfig)!
        
        viewControllers = [
            generateNavigationController(rootViewController: profileViewController, title: "Профиль", image: profileImage),
            generateNavigationController(rootViewController: createPartyViewController, title: "Создать", image: createImage),
            generateNavigationController(rootViewController: partiesViewController, title: "Вечеринки", image: partiesImage),
            generateNavigationController(rootViewController: chatlistViewController, title: "Сообщения", image: messaggesImage),
            generateNavigationController(rootViewController: searchPartyViewController, title: "Поиск", image: searchImage),

        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        
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
        
        let mainTabBarController = MainTabBarController()
        
        func makeUIViewController(context: Context) -> MainTabBarController {
            return mainTabBarController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
