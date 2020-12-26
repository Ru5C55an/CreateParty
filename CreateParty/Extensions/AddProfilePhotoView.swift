//
//  AddProfilePhotoView.swift
//  CreateParty
//
//  Created by Руслан Садыков on 25.12.2020.
//

import UIKit

class AddProfilePhotoView: UIView {
    
    var circleImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "plus.viewfinder")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(circleImageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            circleImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            circleImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            circleImageView.topAnchor.constraint(equalTo: self.topAnchor),
            circleImageView.widthAnchor.constraint(equalToConstant: 128),
            circleImageView.heightAnchor.constraint(equalToConstant: 128)
        ])
        
        self.bottomAnchor.constraint(equalTo: circleImageView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Срабатывает в момент изменения view
    override func layoutSubviews() {
        super.layoutSubviews()
        
        circleImageView.layer.masksToBounds = true
        circleImageView.layer.cornerRadius = 14
    }
}
