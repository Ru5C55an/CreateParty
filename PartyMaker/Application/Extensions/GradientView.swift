//
//  GradientView.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 26.12.2020.
//

import UIKit

class GradientView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    @IBInspectable private var startColor: UIColor? {
        // didSet означает, что как только изменится Color
        didSet {
            setupGradientColors(startColor: startColor, endColor: endColor)
        }
    }
    
    @IBInspectable private var endColor: UIColor? {
        // didSet означает, что как только изменится Color
        didSet {
            setupGradientColors(startColor: startColor, endColor: endColor)
        }
    }
    
    init(from: Point, to: Point, center: Point? = nil, startColor: UIColor?, endColor: UIColor?, centerColor: UIColor? = nil) {
        self.init()
        setupGradient(from: from, to: to, center: center, startColor: startColor, endColor: endColor, centerColor: centerColor)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func setupGradient(from: Point, to: Point, center: Point? = nil, startColor: UIColor?, endColor: UIColor?, centerColor: UIColor? = nil) {
        self.layer.addSublayer(gradientLayer)
        
        if let centerColor = centerColor {
            setupGradientColors(startColor: startColor, endColor: endColor, centerColor: centerColor)
        } else {
            setupGradientColors(startColor: startColor, endColor: endColor)
        }
    
        gradientLayer.startPoint = from.point
        gradientLayer.endPoint = to.point
        
        if let center = center {
            gradientLayer.anchorPoint = center.point
        }
    }
    
    private func setupGradientColors(startColor: UIColor?, endColor: UIColor?, centerColor: UIColor? = nil) {
        if let startColor = startColor, let endColor = endColor, let centerColor = centerColor {
            gradientLayer.colors = [startColor.cgColor, centerColor.cgColor, endColor.cgColor]
        } else if let startColor = startColor, let endColor = endColor {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        }
    }
    
    // Coder отвечает за взаимодействие с Interface Builder
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupGradient(from: .leading, to: .trailing, startColor: startColor, endColor: endColor)
    }
}
