//
//  BottleGameAbout.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 03.05.2021.
//

import UIKit

class BottleGameAbout: UIViewController {
    
    let firstAboutTextView = UITextView()
    
    let mode1Label = UILabel(text: "На поцелуи", font: UIFont.sfProDisplay(ofSize: 16, weight: .medium), textColor: .systemRed)
    let mode2Label = UILabel(text: "На выпивки", font: UIFont.sfProDisplay(ofSize: 16, weight: .medium), textColor: .systemYellow)
    let mode3Label = UILabel(text: "На желания", font: UIFont.sfProDisplay(ofSize: 16, weight: .medium), textColor: .systemPink)
    
    let mode1ImageView = UIImageView()
    let mode2ImageView = UIImageView()
    let mode3ImageView = UIImageView()
    
    let secondAboutTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstAboutTextView.text = "Есть 3 режма игры:"
        secondAboutTextView.text = "aisjdaiosdjasiodjasoid"
        
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.addSubview(firstAboutTextView)
        view.addSubview(mode1Label)
        view.addSubview(mode2Label)
        view.addSubview(mode3Label)
        view.addSubview(mode1ImageView)
        view.addSubview(mode2ImageView)
        view.addSubview(mode3ImageView)
        view.addSubview(secondAboutTextView)
    }
    
    private func setupConstraints() {
        
        firstAboutTextView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        
        mode1Label.snp.makeConstraints { (make) in
            make.top.equalTo(firstAboutTextView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
        
        mode1ImageView.snp.makeConstraints { (make) in
            make.top.equalTo(mode1Label.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        
        mode2Label.snp.makeConstraints { (make) in
            make.top.equalTo(mode1ImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
        
        mode2ImageView.snp.makeConstraints { (make) in
            make.top.equalTo(mode2Label.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        
        mode3Label.snp.makeConstraints { (make) in
            make.top.equalTo(mode2ImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
        
        mode3ImageView.snp.makeConstraints { (make) in
            make.top.equalTo(mode3Label.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        
        secondAboutTextView.snp.makeConstraints { (make) in
            make.top.equalTo(mode3ImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(10)
        }
    }
    
}
