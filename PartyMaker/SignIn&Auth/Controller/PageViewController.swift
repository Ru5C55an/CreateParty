//
//  PageViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 03.12.2020.
//

import UIKit

class PageViewController: UIPageViewController {

    // MARK: - Properties
    private let presentScreenContent = [
        "asdasdasdasdasd",
        "asdasdasdasdasdas",
        "asdasdasdasdasdas",
        "asdasdasdasdasdjhasgfajkhsgfaisfgiuas",
        ""
    ]
    
    private let emojiArray = ["😄", "🥰", "🥳", "😎", ""]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self // Подписывает делегата для работы протокола
        
        if let welcomeCarouselViewController = showViewControllerAtIndex(0) {
            setViewControllers([welcomeCarouselViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func showViewControllerAtIndex(_ index: Int) -> WelcomeCarouselViewController? {
        
        guard index >= 0 else { return nil }
        guard index < presentScreenContent.count else {
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "presentationWasViewed")
            dismiss(animated: true, completion: nil)
            return nil
        }
        guard let welcomeCarouselViewController = storyboard?.instantiateViewController(identifier: "WelcomeCarouselViewController") as? WelcomeCarouselViewController else { return nil }
        welcomeCarouselViewController.presentText = presentScreenContent[index]
        welcomeCarouselViewController.emoji = emojiArray[index]
        welcomeCarouselViewController.currentPage = index
        welcomeCarouselViewController.numberOfPages = presentScreenContent.count
        
        if index == presentScreenContent.count - 2 {
            welcomeCarouselViewController.hideButton = false
        }
        
        return welcomeCarouselViewController
    }
    
    deinit {
        print("deinit", PageViewController.self)
    }
}

// MARK: - UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var pageNumber = (viewController as! WelcomeCarouselViewController).currentPage
        pageNumber -= 1
        
        return showViewControllerAtIndex(pageNumber)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
       
        var pageNumber = (viewController as! WelcomeCarouselViewController).currentPage
        pageNumber += 1
        
        return showViewControllerAtIndex(pageNumber)
    }
}
