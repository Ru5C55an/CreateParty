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
    
    init(from: Point, to: Point, startColor: UIColor?, endColor: UIColor?) {
        self.init()
        setupGradient(from: from, to: to, startColor: startColor, endColor: endColor)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func setupGradient(from: Point, to: Point, startColor: UIColor?, endColor: UIColor?) {
        self.layer.addSublayer(gradientLayer)
        setupGradientColors(startColor: startColor, endColor: endColor)
        gradientLayer.startPoint = from.point
        gradientLayer.endPoint = to.point
    }
    
    private func setupGradientColors(startColor: UIColor?, endColor: UIColor?) {
        if let startColor = startColor, let endColor = endColor {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        }
    }
    
    // Coder отвечает за взаимодействие с Interface Builder
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupGradient(from: .leading, to: .trailing, startColor: startColor, endColor: endColor)
    }
}
