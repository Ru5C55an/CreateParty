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
    
    //MARK: - Delegate
    var delegate: SearchPartyFilterDelegate?
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        barView.hero.id = "ironMan"
//        filterView.hero.id = "batMan"
//        filterView.hero.modifiers = [.translate(y:300)]
        
        backView.layer.cornerRadius = 10
        
        barView.sortButton.isHidden = true
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        filterView.delegate = self
    
        setupConstraints()
    }
    
    // MARK: - Handlers
    @objc private func closeButtonTapped() {
        var filter = [String: String]()
        filter["city"] = filterView.cityLabel.text
        filter["countPeoples"] = filterView.countText.text
        filter["date"] = filterView.dateFormatter.string(from: filterView.datePicker.date)
        filter["price"] = filterView.priceTextField.text
        filter["type"] = filterView.pickedType
        
        switch filterView.segmentedCharCount.selectedSegmentIndex {
        case 0:
            filter["charCountPeoples"] = ">"
        case 1:
            filter["charCountPeoples"] = "<"
        case 2:
            filter["charCountPeoples"] = "="
        default:
            break
        }
        
        switch filterView.segmentedCharPrice.selectedSegmentIndex {
        case 0:
            filter["charPrice"] = ">"
        case 1:
            filter["charPrice"] = "<"
        case 2:
            filter["charPrice"] = "="
        default:
            break
        }
      
        delegate?.didChangeFilter(filter: filter)
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

extension SearchPartiesFilteredVC: FilterPartiesViewDelegate {
    func showCities() {
        let citiesVC = CitiesViewController()
            
        self.addChild(citiesVC)
        citiesVC.view.frame = self.view.frame
        self.view.addSubview(citiesVC.view)
            
        citiesVC.didMove(toParent: self)
    }
}
