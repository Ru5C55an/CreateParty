//
//  PageViewController.swift
//  CreateParty
//
//  Created by Руслан Садыков on 03.12.2020.
//

import UIKit

class PageViewController: UIPageViewController {

    let presentScreenContent = [
        "asdasdasdasdasd",
        "asdasdasdasdasdas",
        "asdasdasdasdasdas",
        "asdasdasdasdasdjhasgfajkhsgfaisfgiuas",
        ""
    ]
    
    let emojiArray = ["😄", "🥰", "🥳", "😎", ""]
    
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
        
        return welcomeCarouselViewController
    }
    
    func closePage() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "presentationWasViewed")
        dismiss(animated: true, completion: nil)
        print("workworkworkworkworkworkworkworkworkworkwork")
    }
}

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
