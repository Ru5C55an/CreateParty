//
//  SearchPartiesBar.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 07.04.2021.
//

import UIKit

class SearchPartiesBar: UIView {
    
    let filterButton: UIButton = {
        let button = UIButton()
        button.layer.contents = UIImage(systemName: "line.horizontal.3.decrease.circle")?.imageWithColor(color: .gray)?.cgImage
        return button
    }()
    
    let sortButton: UIButton = {
        let button = UIButton()
        button.layer.contents = UIImage(systemName: "arrow.up.arrow.down.circle")?.imageWithColor(color: .gray)?.cgImage
//        arrow.down
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .clear
    
        setupConstraints()
        addTargets()
    }
    
    private func addTargets() {
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchPartiesBar {
    
    private func setupConstraints() {
        self.addSubview(filterButton)
        self.addSubview(sortButton)
        
        filterButton.snp.makeConstraints { (make) in
            make.trailing.top.bottom.equalToSuperview()
            make.size.equalTo(30)
        }
        
        sortButton.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalToSuperview()
            make.size.equalTo(30)
        }
    }
}
