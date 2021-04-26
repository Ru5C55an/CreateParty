//
//  FourthCreatePartyViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 04.01.2021.
//

import UIKit
import UPCarouselFlowLayout

class FourthCreatePartyViewController: UIViewController {
    
    // MARK: - UI Elements
    private let subscribeLabel = UILabel(text: "Настройка фона и другие 🍪 доступны по подписке")
    
    private let doneButton = UIButton(title: "Пропустить", titleColor: .white)
    private let getSubscribeButton = UIButton(title: "О подписке", titleColor: .white)
    
    private var collectionView: UICollectionView!
    
    private let cardView = CardView()
    
    // MARK: - Properties
    private var backgrounds: [UIImage] = []
    
    private var prevIndex = 0
    
    private var party: Party
    private var partyImage: UIImage
    
    // MARK: - Lifecycle
    init(party: Party, image: UIImage) {
        self.party = party
        self.partyImage = image
        
        super.init(nibName: nil, bundle: nil)
        
        title = "Выберите фон 🎨"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainWhite()
        
        setupNavigationBar()
        setupCards()
        
        setupTargets()
        
        setupCollectionView()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        doneButton.applyGradients(cornerRadius: doneButton.layer.cornerRadius, from: .bottomLeading, to: .topTrailing, startColor: #colorLiteral(red: 0.8980392157, green: 0.7294117647, blue: 0.1294117647, alpha: 1), endColor: #colorLiteral(red: 0.8196078431, green: 0.3647058824, blue: 0.1725490196, alpha: 1))
        getSubscribeButton.applyGradients(cornerRadius: getSubscribeButton.layer.cornerRadius, from: .bottomLeading, to: .topTrailing, startColor: #colorLiteral(red: 0.1960784314, green: 0.5647058824, blue: 0.6, alpha: 1), endColor: #colorLiteral(red: 0.1490196078, green: 0.1450980392, blue: 0.7490196078, alpha: 1))
    }
    
    private func setupCards() {
        for item in 1...34 {
            backgrounds.append(UIImage(named: "bc\(item)")!)
        }
    }
    
    private func setupTargets() {
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        getSubscribeButton.addTarget(self, action: #selector(getSubscribeButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Setup views
    private func setupNavigationBar() {
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationBar.topItem?.title = "Выберите фон"
//        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
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
        
        print("skldasdjasoidjasdioajs: ", backgrounds.count / 2)
 

        collectionView.scrollToItem(at: [0, 7], at: .centeredHorizontally, animated: true)
//        collectionView.selectItem(at: [0, backgrounds.count / 2 % backgrounds.count], animated: true, scrollPosition: .right)
    }
    
    // MARK: - Handlers
    @objc private func doneButtonTapped() {
        
        FirestoreService.shared.savePartyWith(party: party, partyImage: partyImage) { [weak self] (result) in
            switch result {
            
            case .success(_):
                self?.showAlert(title: "Ура! 🎉", message: "Вечеринка создана. Вы можете найти ее в Мои вечеринки") {
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            case .failure(let error):
                self?.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
    
    @objc private func getSubscribeButtonTapped() {
        
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
        
        subscribeLabel.numberOfLines = 2
        subscribeLabel.textAlignment = .center
        
        view.addSubview(collectionView)
        view.addSubview(cardView)
        view.addSubview(subscribeLabel)
        view.addSubview(buttonsStackView)
        
        cardView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(224)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(cardView.snp.bottom).offset(16)
            make.height.equalTo(246)
            make.leading.trailing.equalToSuperview()
        }
        
        subscribeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(44)
        } 
        
        buttonsStackView.snp.makeConstraints { (make) in
            make.top.equalTo(subscribeLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(44)
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
        
        doneButton.snp.makeConstraints { (make) in
            make.height.equalTo(60)
        }
        
        getSubscribeButton.snp.makeConstraints { (make) in
            make.height.equalTo(60)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension FourthCreatePartyViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //        print(indexPath.row)
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
        
        print("asodijasdoiasdi: ", indexPath)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardBackgroundCell.reuseId, for: indexPath) as! CardBackgroundCell
        
        cell.configure(image: backgrounds[indexPath.row % backgrounds.count])
        
        if (prevIndex - indexPath.row % backgrounds.count) == 3 {
            cardView.imageView.image = backgrounds[indexPath.row % backgrounds.count + 1]
        } else if ((prevIndex - indexPath.row % backgrounds.count) == 1) && ((indexPath.row % backgrounds.count - 1) != -1) {
            cardView.imageView.image = backgrounds[indexPath.row % backgrounds.count + 1]
        } else if (indexPath.row % backgrounds.count - 1) != -1 {
            cardView.imageView.image = backgrounds[indexPath.row % backgrounds.count - 1]
        } else {
            cardView.imageView.image = backgrounds[indexPath.row % backgrounds.count]
        }
        
        //        if (prevIndex - indexPath.row) == 3 {
        //            cardView.imageView.image = backgrounds[indexPath.row + 1]
        //        } else if ((prevIndex - indexPath.row) == 1) && ((indexPath.row - 1) != -1) {
        //            cardView.imageView.image = backgrounds[indexPath.row + 1]
        //        } else if (indexPath.row - 1) != -1 {
        //            cardView.imageView.image = backgrounds[indexPath.row - 1]
        //        } else {
        //            cardView.imageView.image = backgrounds[indexPath.row]
        //        }
        
        prevIndex = indexPath.row % backgrounds.count
        
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
