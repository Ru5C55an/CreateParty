//
//  SelectProfileColorViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 11.04.2021.
//

import UIKit
import UPCarouselFlowLayout
import iCarousel

protocol SelectProfileColorDelegate {
    func selectProfileColor(colorName: String)
}

class SelectProfileColorViewController: UIViewController {
    
    // MARK: - UI Elements
    private let subscribeLabel = UILabel(text: "Настройка персонального цвета и другие 🍪 доступны по подписке")
    
    private let backButton = UIButton(title: "Отмена", titleColor: .white)
    private let getSubscribeButton = UIButton(title: "О подписке", titleColor: .white)
    
    private let carouselView = iCarousel()
    
    private var profileView = GradientView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel(text: "Gandi", font: .sfProDisplay(ofSize: 20, weight: .medium))
    private let ageLabel = UILabel(text: "21", font: .sfProDisplay(ofSize: 20, weight: .medium))
    private let ratingLabel = UILabel(text: "􀋂 0", font: .sfProDisplay(ofSize: 16, weight: .medium))
    
    private let userCellView = UserCell()
    private var selectedColor = ""
    
    // MARK: - Properties
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }()
    
    private var backgrounds: [String] = ["viceCity", "cosmicFusion", "susetGradient", "bradyFun", "sherbert", "dusk", "grapefruitSunset", "politics", "redSunset", "dania", "jupiter", "transfile", "nighthawk", "atlas", "megaTron", "punYeta", "kingYna"]
    
    private var prevIndex = 0
    
    private var currentUser: PUser
    
    // MARK: - Delegate
    var delegate: SelectProfileColorDelegate?
    
    // MARK: - Lifecycle
    init(currentUser: PUser) {
        self.currentUser = currentUser
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainWhite()
    
        checkSubscription()
        setupUserView()
        
        setupCustomizations()
        setupNavigationBar()
        
        setupTargets()
        
        setupCaroueslView()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backButton.applyGradients(cornerRadius: backButton.layer.cornerRadius, from: .bottomLeading, to: .topTrailing, startColor: #colorLiteral(red: 0.8980392157, green: 0.7294117647, blue: 0.1294117647, alpha: 1), endColor: #colorLiteral(red: 0.8196078431, green: 0.3647058824, blue: 0.1725490196, alpha: 1))
        getSubscribeButton.applyGradients(cornerRadius: getSubscribeButton.layer.cornerRadius, from: .bottomLeading, to: .topTrailing, startColor: #colorLiteral(red: 0.1960784314, green: 0.5647058824, blue: 0.6, alpha: 1), endColor: #colorLiteral(red: 0.1490196078, green: 0.1450980392, blue: 0.7490196078, alpha: 1))
    }
    
    private func setupTargets() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Setup views
    private func setupUserView() {
        
        if currentUser.personalColor != "" {
            
        } else {
            userCellView.backgroundColor = .white
            profileView.backgroundColor = .white
        }
        
        if currentUser.avatarStringURL != "" {
            self.avatarImageView.sd_setImage(with: URL(string: currentUser.avatarStringURL), completed: nil)
            self.userCellView.userImageView.sd_setImage(with: URL(string: currentUser.avatarStringURL), completed: nil)
        } else {
            self.avatarImageView.image = UIImage(systemName: "person.crop.circle")
            self.userCellView.userImageView.image = UIImage(systemName: "person.crop.circle")
        }
        
        userCellView.userImageView.sd_setImage(with: URL(string: currentUser.avatarStringURL), completed: nil)
        userCellView.usernameText.text = currentUser.username
        nameLabel.text = currentUser.username
        
        let birthdayString = currentUser.birthday
        let birthday = dateFormatter.date(from: birthdayString)
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday!, to: now)
        userCellView.userAgeText.text = String(ageComponents.year!)
        ageLabel.text = String(ageComponents.year!)
    }
    
    private func checkSubscription() {
        #warning("Добавить проверку, что подписка есть")
        
        if true {
            getSubscribeButton.setTitle("Выбрать", for: .normal)
            getSubscribeButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        }
    }

    private func setupCustomizations() {
        avatarImageView.layer.cornerRadius = 64
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        
        profileView.backgroundColor = .white
        profileView.layer.cornerRadius = 30
        profileView.clipsToBounds = true
    }
    
    private func setupNavigationBar() {
//        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "Выберите фон"
//        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
    }
    
    private func setupCaroueslView() {
        carouselView.dataSource = self
        carouselView.delegate = self
        carouselView.type = .invertedWheel
    }
    
    @objc private func saveButtonTapped() {
        delegate?.selectProfileColor(colorName: selectedColor)
        dismiss(animated: true) {
//            self.delegate?.selectProfileColor(colorName: self.selectedColor)
        }
    }
    
    // MARK: - Handlers
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Setup constraints
extension SelectProfileColorViewController {
    
    private func setupConstraints() {
        
        let buttonsStackView = UIStackView(arrangedSubviews: [backButton, getSubscribeButton], axis: .horizontal, spacing: 8)
        buttonsStackView.distribution = .fillEqually
        
        let nameAgeRaringStackView = UIStackView(arrangedSubviews: [nameLabel, ageLabel, ratingLabel], axis: .horizontal, spacing: 8)
        nameAgeRaringStackView.distribution = .equalSpacing
        
        subscribeLabel.numberOfLines = 2
        subscribeLabel.textAlignment = .center
        
        view.addSubview(carouselView)
        view.addSubview(profileView)
        view.addSubview(subscribeLabel)
        view.addSubview(buttonsStackView)
        view.addSubview(nameAgeRaringStackView)
        view.addSubview(userCellView)
        
        profileView.addSubview(avatarImageView)

        profileView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(266)
        }
        
        avatarImageView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.size.equalTo(156)
            make.centerX.equalToSuperview()
        }
        
        nameAgeRaringStackView.snp.makeConstraints { (make) in
            make.top.equalTo(avatarImageView.snp.bottom)
            make.bottom.equalTo(profileView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(44)
        }
        
        userCellView.snp.makeConstraints { (make) in
            make.top.equalTo(profileView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(44)
            make.height.equalTo(86)
        }
        
        carouselView.snp.makeConstraints { (make) in
            make.height.equalTo(70)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(subscribeLabel.snp.bottom).offset(-64)
        }
        
        subscribeLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(44)
            make.bottom.equalTo(buttonsStackView.snp.top).offset(-16)
        }
        
        buttonsStackView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(44)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.height.equalTo(60)
        }
        
        getSubscribeButton.snp.makeConstraints { (make) in
            make.height.equalTo(60)
        }
    }
}

// MARK: UICollectionViewDataSource
extension SelectProfileColorViewController: iCarouselDataSource, iCarouselDelegate {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return backgrounds.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        var view = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        
        view = PersonalColors.init(rawValue: backgrounds[index])!.gradient
        
        view.frame = CGRect(x: 0, y: 0, width: 60, height: 60)

        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        
        profileView.setNeedsDisplay()
        
        return view
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing {
            return 1.2
        }

        if option == iCarouselOption.arc {
//            return 4
            return 5
        }
        
        return value
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        
        selectedColor = backgrounds[carousel.currentItemIndex]
        
        for view in profileView.subviews {
            if view.tag == 1 {
                view.removeFromSuperview()
            }
        }
        
        for view in userCellView.subviews {
            if view.tag == 1 {
                view.removeFromSuperview()
            }
        }
        
        let gradient = PersonalColors.init(rawValue: backgrounds[carousel.currentItemIndex])!.gradient
        let gradient2 = PersonalColors.init(rawValue: backgrounds[carousel.currentItemIndex])!.gradient
        gradient.tag = 1
        gradient2.tag = 1
        profileView.insertSubview(gradient, at: 0)
        userCellView.insertSubview(gradient2, at: 0)
        
        gradient2.layer.cornerRadius = 10
        gradient2.clipsToBounds = true
        
        gradient.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        gradient2.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - SwiftUI
import SwiftUI

struct SelectProfileColorViewControllerProvider: PreviewProvider {
    
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
