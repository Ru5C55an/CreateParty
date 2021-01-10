//
//  ShowPartyViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 30.12.2020.
//

import UIKit
import SDWebImage
import SnapKit

class ShowPartyViewController: UIViewController {
    
    private let itemsPerRow: CGFloat = 1
    private let sectionInserts = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    
    private var waitingUsers: [PUser] = []
    private var approvedUsers: [PUser] = []
    
    private let nameText = UILabel(text: "")
    
    private let dateLabel = UILabel(text: "🗓", font: .sfProDisplay(ofSize: 36, weight: .medium))
    private let dateText = UILabel(text: "")
    
    private let timeLabel = UILabel(text: "⌚️", font: .sfProDisplay(ofSize: 36, weight: .medium))
    private let startTimeText = UILabel(text: "")
    private let endTimeText = UILabel(text: "")
    
    private let typeLabel = UILabel(text: "Тип", font: .sfProDisplay(ofSize: 24, weight: .medium))
    private let typeText = UILabel(text: "")
    
    private let priceLabel = UILabel(text: "Цена", font: .sfProDisplay(ofSize: 24, weight: .medium))
    private let priceText = UILabel(text: "")
    
    private let locationLabel = UILabel(text: "Адрес", font: .sfProDisplay(ofSize: 24, weight: .medium))
    private let locationText = UILabel(text: "")
    private let locationButton = UIButton()
    
    private let descriptionLabel = UILabel(text: "Описание", font: .sfProDisplay(ofSize: 24, weight: .medium))
    private let descriptionText = AboutInputText(isEditable: false)
    
    private let countPeopleLabel = UILabel(text: "Кол-во гостей", font: .sfProDisplay(ofSize: 24, weight: .medium))
    private let currentPeopleText = UILabel(text: "")
    private let maxPeopleText = UILabel(text: "")
    
    private let ownerlabel = UILabel(text: "Хозяин вечеринки", font: .sfProDisplay(ofSize: 24, weight: .medium))
    private let ownerImage = UIImageView()
    private let ownerName = UILabel(text: "")
    private let ownerAge = UILabel(text: "")
    private let ownerRating = UILabel(text: "􀋂 0")
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }()
    
    private var collectionView: UICollectionView!
    
    private let goButton = UIButton(title: "Пойти")
    private let requestsButton = UIButton(title: "Новые заявки")
    private let cancelPartyButton = UIButton(title: "Отменить вечеринку")
    
    private let party: Party
    private var ownerParty: PUser!
    private let target: String
    
    init(party: Party, target: String){
        self.party = party
        self.target = target
        
        super.init(nibName: nil, bundle: nil)
        
        FirestoreService.shared.getUser(by: party.userId) { [weak self] result in
            
            switch result {
            
            case .success(let puser):
                self?.ownerParty = puser
                
                if puser.avatarStringURL == "" {
                    self?.ownerImage.image = UIImage(systemName: "person.crop.circle")
                } else {
                    self?.ownerImage.sd_setImage(with: URL(string: puser.avatarStringURL), completed: nil)
                }
                
                self?.ownerName.text = puser.username
                
                let birthdayString = puser.birthday
                let birthday = self?.dateFormatter.date(from: birthdayString)
                let now = Date()
                let calendar = Calendar.current
                let ageComponents = calendar.dateComponents([.year], from: birthday!, to: now)
                self?.ownerAge.text = String(ageComponents.year!)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        nameText.text = party.name
        dateText.text = party.date
        startTimeText.text = party.startTime
        endTimeText.text = party.endTime
        typeText.text = party.type
        priceText.text = party.price
        locationText.text = party.location
        descriptionText.textView.text = party.description
        currentPeopleText.text = party.currentPeople
        maxPeopleText.text = " / \(party.maximumPeople)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let dg = DispatchGroup()
        dg.enter()
        FirestoreService.shared.getApprovedGuestsId(party: party) { [weak self] result in
            
            switch result {
            
            case .success(let usersId):
                
                for userId in usersId {
                    
                    FirestoreService.shared.getUser(by: userId) { result in
                        
                        switch result {
                        
                        case .success(let puser):
                            self?.approvedUsers.append(puser)
                        case .failure(let error):
                            self?.showAlert(title: "Ошибка!", message: error.localizedDescription)
                        }
                        dg.leave()
                    }
                }
                    
            case .failure(let error):
                self?.showAlert(title: "Ошибка!", message: error.localizedDescription)
            }
        }
        
        FirestoreService.shared.getWaitingGuestsId(party: party) { [weak self] result in
            
            switch result {
            
            case .success(let usersId):
                
                for userId in usersId {
                    
                    FirestoreService.shared.getUser(by: userId) { result in
                        
                        switch result {
                        
                        case .success(let puser):
                            self?.waitingUsers.append(puser)
                        case .failure(let error):
                            self?.showAlert(title: "Ошибка!", message: error.localizedDescription)
                        }
                        dg.leave()
                    }
                }
                    
            case .failure(let error):
                self?.showAlert(title: "Ошибка!", message: error.localizedDescription)
            }
        }
        
        dg.notify(queue: .main) {
            print("done")
            print(self.waitingUsers)
            self.setupCollectionView()
            self.setupConstraints()
        }
        
        addTargets()
        setupCustomization()
        checkWaitingGuest()
    }
    
    private func addTargets() {
        goButton.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        cancelPartyButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        requestsButton.addTarget(self, action: #selector(requestsButtonTapped), for: .touchUpInside)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showOwner))
        ownerImage.addGestureRecognizer(gesture)
    }
    
    @objc private func showOwner() {
        print(123123)
        let aboutUserVC = AboutUserViewContoller(user: ownerParty)
        present(aboutUserVC, animated: true, completion: nil)
    }
    
    @objc private func cancelButtonTapped() {
        
    }
    
    @objc private func requestsButtonTapped() {
        let waitingGuestVC = WaitingGuestsViewController(users: waitingUsers, party: party)
        navigationController?.pushViewController(waitingGuestVC, animated: true)
    }
    
    private func setupCustomization() {
        
        locationButton.setImage(UIImage(named: "map"), for: .normal)
        ownerImage.layer.cornerRadius = 43
        ownerImage.clipsToBounds = true
        
        requestsButton.addIcon(image: UIImage(systemName: "bell")!, alignment: .left)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cancelPartyButton.applyGradients(cornerRadius: cancelPartyButton.layer.cornerRadius, from: .bottomLeading, to: .topTrailing, startColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), endColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        requestsButton.applyGradients(cornerRadius: cancelPartyButton.layer.cornerRadius, from: .bottomLeading, to: .topTrailing, startColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), endColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        goButton.applyGradients(cornerRadius: goButton.layer.cornerRadius, from: .bottomLeading, to: .topTrailing, startColor: .blue, endColor: .white)
    }
    
    @objc private func goButtonTapped() {
        
        FirestoreService.shared.createWaitingGuest(receiver: party.id) { [weak self] (result) in
            switch result {
            
            case .success():
                self?.showAlert(title: "Успешно!", message: "Заявка отправлена владельцу вечеринки")
                self?.checkWaitingGuest()
            case .failure(let error):
                self?.showAlert(title: "Ошибка!", message: error.localizedDescription)
            }
        }
    }
    
    @objc private func locationButtonTapped() {
        let mapViewController = MapViewController(currentParty: party, incomeIdentifier: .showParty)
        mapViewController.modalPresentationStyle = .fullScreen
        present(mapViewController, animated: false, completion: nil)
    }
    
    private func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 195, height: 86), collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseId)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func checkWaitingGuest() {
        
        FirestoreService.shared.checkWaitingGuest(receiver: party.id) { [weak self] (result) in
            
            switch result {
            
            case .success():
                self?.goButton.isEnabled = false
                self?.goButton.setTitle("Заявка отправлена", for: .normal)
            case .failure(_):
                break
            }
        }
    }
    
    deinit {
        print("deinit", ShowPartyViewController.self)
    }
}

// MARK: - Setup constraints
extension ShowPartyViewController {
    
    private func setupConstraints() {
        
        nameText.textAlignment = .center
        nameText.numberOfLines = 2
        
        let dateStackView = UIStackView(arrangedSubviews: [dateLabel, dateText], axis: .horizontal, spacing: 8)
        let timeStackView = UIStackView(arrangedSubviews: [timeLabel, startTimeText, endTimeText], axis: .horizontal, spacing: 8)
        
        let dateAndTimeStackView = UIStackView(arrangedSubviews: [dateStackView, timeStackView], axis: .horizontal, spacing: 32)
        
        let typeStackView = UIStackView(arrangedSubviews: [typeLabel, typeText], axis: .horizontal, spacing: 8)
        
        let priceStackView = UIStackView(arrangedSubviews: [priceLabel, priceText], axis: .horizontal, spacing: 8)
        
        let typeAndPriceStackView = UIStackView(arrangedSubviews: [typeStackView, priceStackView], axis: .horizontal, spacing: 16)
        
        locationButton.contentHorizontalAlignment = .leading
        let locationStackView = UIStackView(arrangedSubviews: [locationLabel, locationButton], axis: .horizontal, spacing: 8)
        locationStackView.alignment = .firstBaseline
        
        let locationVerticalStackView = UIStackView(arrangedSubviews: [locationStackView, locationText], axis: .vertical, spacing: 8)
        
        let descriptionStackView = UIStackView(arrangedSubviews: [descriptionLabel, descriptionText], axis: .vertical, spacing: 8)
        
        let countPeopleStackView = UIStackView(arrangedSubviews: [countPeopleLabel, currentPeopleText, maxPeopleText], axis: .horizontal, spacing: 8)
        
        let ownerNameAndAgeStackView = UIStackView(arrangedSubviews: [ownerName, ownerAge], axis: .horizontal, spacing: 8)
        let ownerRatingAndNameAndAgeStackView = UIStackView(arrangedSubviews: [ownerNameAndAgeStackView, ownerRating], axis: .vertical, spacing: 8)
        
        let ownerImageAndOther = UIStackView(arrangedSubviews: [ownerImage, ownerRatingAndNameAndAgeStackView], axis: .horizontal, spacing: 8)
        ownerImageAndOther.alignment = .center
        
        let ownerStackView = UIStackView(arrangedSubviews: [ownerlabel, ownerImageAndOther], axis: .vertical, spacing: 8)
        
        let stackView = UIStackView(arrangedSubviews: [nameText, dateAndTimeStackView, typeAndPriceStackView, locationVerticalStackView, descriptionStackView, countPeopleStackView], axis: .vertical, spacing: 16)
        
        stackView.alignment = .leading
        
        view.addSubview(stackView)
        view.addSubview(collectionView)
        view.addSubview(ownerStackView)
        
        nameText.translatesAutoresizingMaskIntoConstraints = false
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        ownerRatingAndNameAndAgeStackView.translatesAutoresizingMaskIntoConstraints = false
        ownerStackView.translatesAutoresizingMaskIntoConstraints = false
        ownerAge.translatesAutoresizingMaskIntoConstraints = false
        ownerName.translatesAutoresizingMaskIntoConstraints = false
        
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(32)
            make.leading.trailing.equalToSuperview().inset(22)
        }
        
        nameText.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        
        locationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(locationButton)
        }
        
        descriptionText.snp.makeConstraints { make in
            make.height.equalTo(128)
            make.leading.trailing.equalToSuperview()
//            make.leading.trailing.equalTo(stackView)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).inset(-16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(86)
        }
        
        ownerStackView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).inset(-16)
            make.leading.trailing.equalToSuperview().inset(22)
        }
        
        ownerImage.snp.makeConstraints { make in
            make.size.equalTo(86)
        }
        
        ownerAge.snp.makeConstraints { make in
            make.trailing.equalTo(stackView)
        }
        
        ownerName.snp.makeConstraints { make in
            make.trailing.equalTo(ownerAge.snp.leading).inset(-4)
        }
        
        if target == "search" {
            
            view.addSubview(goButton)
            
            goButton.translatesAutoresizingMaskIntoConstraints = false
            
            goButton.snp.makeConstraints { make in
                make.top.equalTo(ownerStackView.snp.bottom).inset(-16)
                make.leading.trailing.equalToSuperview().inset(22)
            }
            
        } else if target == "waiting" {
            
            view.addSubview(goButton)
            
            goButton.translatesAutoresizingMaskIntoConstraints = false
            
            goButton.snp.makeConstraints { make in
                make.top.equalTo(ownerStackView.snp.bottom).inset(-16)
                make.leading.trailing.equalToSuperview().inset(22)
            }
            
        } else if target == "approved" {
            
            
            
            
        } else if target == "my" {
            
            ownerStackView.removeFromSuperview()
            
            view.addSubview(requestsButton)
            view.addSubview(cancelPartyButton)
            
            requestsButton.translatesAutoresizingMaskIntoConstraints = false
            
            requestsButton.snp.makeConstraints { make in
                make.height.equalTo(60)
                make.top.equalTo(collectionView.snp.bottom).inset(-16)
                make.leading.trailing.equalToSuperview().inset(22)
            }
            
            cancelPartyButton.translatesAutoresizingMaskIntoConstraints = false
            
            cancelPartyButton.snp.makeConstraints { make in
                make.height.equalTo(60)
                make.top.equalTo(requestsButton.snp.bottom).inset(-16)
                make.leading.trailing.equalToSuperview().inset(22)
            }
        }
    }
}

// MARK: UICollectionViewDataSource
extension ShowPartyViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return approvedUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCell.reuseId, for: indexPath) as! UserCell
        
        cell.configure(with: approvedUsers[indexPath.row])
        
        return cell
    }
}

extension ShowPartyViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 240, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}

// MARK: - UICollectionViewDelegate
extension ShowPartyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = approvedUsers[indexPath.item]
        
        let aboutUserVC = AboutUserViewContoller(user: user)
        present(aboutUserVC, animated: true, completion: nil)
    }
}

// MARK: - SwiftUI
import SwiftUI

struct ShowPartyViewControllerProvider: PreviewProvider {
    
    static var previews: some View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let showPartyViewController = ShowPartyViewController(party: Party(city: "Смоленск", location: "Смоленск, ул. Ново-Мопровская 9, 2", userId: "123123", imageUrlString: "", type: "Домашний хакатон", maximumPeople: "5", currentPeople: "0", id: "idПользователя", date: "12.09", startTime: "12:00", endTime: "13:00", name: "Вечеринка у Руслана, как твои дела, васяяяяолфтыолфтыадлфыоадлфыоалдфоыадлфоадлфыоаа", price: "200", description: "Самая топовая вечеринка", alco: "Да")
            , target: "")
        func makeUIViewController(context: Context) -> ShowPartyViewController {
            return showPartyViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
