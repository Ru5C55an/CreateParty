//
//  BackgroundCardCell.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 04.01.2021.
//

import UIKit

class CardBackgroundCell: UICollectionViewCell {
    
    var shadowView = UIView()
    var backgroundImage: UIImage!
    
    static let reuseId = "CardBackgroundCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(shadowView)
     
        shadowView.applySketchShadow(color: .gray, alpha: 50, x: -5, y: 5, blur: 20, spread: 0)
    }
    
    func configure(image: UIImage) {
        self.backgroundImage = image
        
        let imageView = UIImageView(image: backgroundImage)
        imageView.frame = self.bounds
        imageView.contentMode = .scaleToFill
        shadowView.addSubview(imageView)
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
