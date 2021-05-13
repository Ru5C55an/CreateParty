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
        return button
    }()
    
    let partiesSegmentedControl = UISegmentedControl(items: ["🗓", "Имя", "🙋‍♀️🙋‍♂️", "💶"])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .clear
        partiesSegmentedControl.isHidden = true
        partiesSegmentedControl.selectedSegmentIndex = 0
        setupConstraints()
    }

   func sortAscending() {
        sortButton.layer.contents = UIImage(systemName: "arrow.down.circle.fill")?.imageWithColor(color: .gray)?.cgImage
    partiesSegmentedControl.isHidden = false
    }
    
    
    func sortDescending() {
         sortButton.layer.contents = UIImage(systemName: "arrow.up.circle.fill")?.imageWithColor(color: .gray)?.cgImage
        partiesSegmentedControl.isHidden = false
    }
    
    func clearSort() {
        sortButton.layer.contents = UIImage(systemName: "arrow.up.arrow.down.circle")?.imageWithColor(color: .gray)?.cgImage
        partiesSegmentedControl.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchPartiesBar {
    
    private func setupConstraints() {
        addSubview(filterButton)
        addSubview(sortButton)
        addSubview(partiesSegmentedControl)
        
        filterButton.snp.makeConstraints { (make) in
            make.trailing.top.bottom.equalToSuperview()
            make.size.equalTo(30)
        }
        
        sortButton.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalToSuperview()
            make.size.equalTo(30)
        }
        
        partiesSegmentedControl.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalTo(sortButton.snp.trailing).offset(10)
            make.trailing.equalTo(filterButton.snp.leading).offset(-10)
        }
    }
}
