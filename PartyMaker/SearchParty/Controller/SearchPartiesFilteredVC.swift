//
//  SearchPartiesFilteredVC.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 07.04.2021.
//

import UIKit
//import Hero

class SearchPartiesFilteredVC: UIViewController {
    
    // MARK: - UI Elements
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let barView = SearchPartiesBar()
    
    let filterView = FilterPartiesView()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .close)
        return button
    }()
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        barView.hero.id = "ironMan"
//        filterView.hero.id = "batMan"
//        filterView.hero.modifiers = [.translate(y:300)]
        
        backView.layer.cornerRadius = 10
        
        barView.sortButton.isHidden = true
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        setupConstraints()
    }
    
    // MARK: - Handlers
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Setup constraints
extension SearchPartiesFilteredVC {
    
    private func setupConstraints() {
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.addSubview(backView)
        backView.addSubview(barView)
        backView.addSubview(filterView)
        backView.addSubview(closeButton)
        
        backView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        barView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(22)
        }
        
        filterView.snp.makeConstraints { (make) in
            make.top.equalTo(barView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
    }
}
