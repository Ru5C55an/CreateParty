//
//  WelcomeCarouselViewController.swift
//  CreateParty
//
//  Created by Руслан Садыков on 03.12.2020.
//

import UIKit

class WelcomeCarouselViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var presentTextLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    var presentText = ""
    var emoji = ""
    var currentPage = 0 // Текущая страница
    var numberOfPages = 0 // Количество страниц
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentTextLabel.text = presentText
        emojiLabel.text = emoji
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = currentPage
    }
    
    @IBAction func tappedButton(_ sender: UIButton) {
        if sender == closeButton {
            if let pageViewController = storyboard?.instantiateViewController(
                identifier: "PageViewController") as? PageViewController {
                pageViewController.closePage()
            }
        }
    }
    
    
    
}
