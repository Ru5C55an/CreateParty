//
//  FourthCreatePartyViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 04.01.2021.
//

import UIKit
import UPCarouselFlowLayout

class FourthCreatePartyViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
    let cardView = CardView()
    
    var backgrounds: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainWhite()

        navigationController?.navigationItem.title = "asjkdhaskjfa"
        navigationItem.largeTitleDisplayMode = .always
//        title = "Выберите фон"
//        navigationController?.navigationBar.largeContentTitle =
        
        for item in 1...34 {
            backgrounds.append(UIImage(named: "bc\(item)")!)
        }
        
        setupCollectionView()
        setupConstraints()
    }
    
    private let party: Party
    
    init(party: Party) {
        self.party = party
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}

// MARK: - Setup constraints
extension FourthCreatePartyViewController {
    
    private func setupConstraints() {
        
        view.addSubview(collectionView)
        view.addSubview(cardView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 128),
            collectionView.heightAnchor.constraint(equalToConstant: 300),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 128),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cardView.heightAnchor.constraint(equalToConstant: 224)
        ])
    }
}

// MARK: - UICollectionViewDelegate
extension FourthCreatePartyViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(backgrounds[indexPath.row % backgrounds.count])
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
//        cardView.applyBackground(image: backgrounds[indexPath.row % backgrounds.count])
        cardView.imageView = UIImageView(image: backgrounds[indexPath.row % backgrounds.count])
        
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
        
        let fourthCreatePartyViewController = FourthCreatePartyViewController(party: Party(city: "", location: "", userId: "", imageUrlString: "", type: "", maximumPeople: "", currentPeople: "", id: "", date: "", startTime: "", endTime: "", name: "", price: "", description: "", alco: ""))
        
        func makeUIViewController(context: Context) -> FourthCreatePartyViewController {
            return fourthCreatePartyViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
