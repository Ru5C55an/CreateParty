//
//  FourthCreatePartyViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 04.01.2021.
//

import UIKit
import UPCarouselFlowLayout

class FourthCreatePartyViewController: UIViewController {
    
    let subscribeLabel = UILabel(text: "Настройка фона и другие 🍪 доступны по подписке")
    
    let doneButton = UIButton(title: "Пропустить", titleColor: .white)
    let getSubscribeButton = UIButton(title: "О подписке", titleColor: .white)
    
    var collectionView: UICollectionView!
    
    let cardView = CardView()
    
    var backgrounds: [UIImage] = []
    
    private var party: Party
    private var partyImage: UIImage
    
    init(party: Party, image: UIImage) {
        self.party = party
        self.partyImage = image
 
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainWhite()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "Выберите фон"
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        
        for item in 1...34 {
            backgrounds.append(UIImage(named: "bc\(item)")!)
        }
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        setupCollectionView()
        setupConstraints()
    }
    
    @objc private func doneButtonTapped() {
        
        FirestoreService.shared.savePartyWith(party: party, partyImage: partyImage) { [weak self] (result) in
            switch result {
            
            case .success(let party):
                self?.navigationController?.popToRootViewController(animated: true)
            case .failure(let error):
                self?.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        doneButton.applyGradients(cornerRadius: doneButton.layer.cornerRadius, from: .bottomLeading, to: .topTrailing, startColor: #colorLiteral(red: 0.8980392157, green: 0.7294117647, blue: 0.1294117647, alpha: 1), endColor: #colorLiteral(red: 0.8196078431, green: 0.3647058824, blue: 0.1725490196, alpha: 1))
        getSubscribeButton.applyGradients(cornerRadius: getSubscribeButton.layer.cornerRadius, from: .bottomLeading, to: .topTrailing, startColor: #colorLiteral(red: 0.1960784314, green: 0.5647058824, blue: 0.6, alpha: 1), endColor: #colorLiteral(red: 0.1490196078, green: 0.1450980392, blue: 0.7490196078, alpha: 1))
    }
    
    private func setupCollectionView() {
        
        let layout = UPCarouselFlowLayout()
        layout.itemSize = CGSize(width: 300, height: 195)
        layout.scrollDirection = .horizontal
        layout.spacingMode = .fixed(spacing: 10)
        layout.sideItemAlpha = 0.8
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(CardBackgroundCell.self, forCellWithReuseIdentifier: CardBackgroundCell.reuseId)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Setup constraints
extension FourthCreatePartyViewController {
    
    private func setupConstraints() {
        
        let buttonsStackView = UIStackView(arrangedSubviews: [doneButton, getSubscribeButton], axis: .horizontal, spacing: 8)
        buttonsStackView.distribution = .fillEqually
        doneButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        getSubscribeButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        subscribeLabel.numberOfLines = 2
        subscribeLabel.textAlignment = .center
        
        view.addSubview(collectionView)
        view.addSubview(cardView)
        view.addSubview(subscribeLabel)
        view.addSubview(buttonsStackView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        cardView.translatesAutoresizingMaskIntoConstraints = false
        subscribeLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 112),
            collectionView.heightAnchor.constraint(equalToConstant: 300),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cardView.heightAnchor.constraint(equalToConstant: 224)
        ])
        
        NSLayoutConstraint.activate([
            subscribeLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 32),
            subscribeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            subscribeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44),
        ])
        
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: subscribeLabel.bottomAnchor, constant: 16),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44),
        ])
    }
}

// MARK: - UICollectionViewDelegate
extension FourthCreatePartyViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.row)
//        cardView.imageView.image = backgrounds[indexPath.row % backgrounds.count]
//        cardView.setNeedsDisplay()
       
       
    }
}

// MARK: UICollectionViewDataSource
extension FourthCreatePartyViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 10000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardBackgroundCell.reuseId, for: indexPath) as! CardBackgroundCell
        
        cell.configure(image: backgrounds[indexPath.row % backgrounds.count])
        cardView.imageView.image = backgrounds[indexPath.row % backgrounds.count]
        cardView.setNeedsDisplay()
        
        return cell
    }
}

// MARK: - SwiftUI
import SwiftUI

struct FourthCreatePartyViewControllerProvider: PreviewProvider {
    
    static var previews: some View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let fourthCreatePartyViewController = FourthCreatePartyViewController(party: Party(city: "", location: "", userId: "", imageUrlString: "", type: "", maximumPeople: "", currentPeople: "", id: "", date: "", startTime: "", endTime: "", name: "", price: "", description: "", alco: ""), image: UIImage(named: "")!)
        
        func makeUIViewController(context: Context) -> FourthCreatePartyViewController {
            return fourthCreatePartyViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
