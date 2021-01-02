//
//  ShowPartyViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 30.12.2020.
//

import UIKit
import SDWebImage

class ShowPartyViewController: UIViewController {
    
    let itemsPerRow: CGFloat = 1
    let sectionInserts = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    
    var usersId = Bundle.main.decode([AprovedUser].self, from: "aprovedUsers.json")
    
    var users: [PUser] = []
    
    let nameText = UILabel(text: "")
    
    let dateLabel = UILabel(text: "🗓", font: .sfProDisplay(ofSize: 36, weight: .medium))
    let dateText = UILabel(text: "")

    let timeLabel = UILabel(text: "⌚️", font: .sfProDisplay(ofSize: 36, weight: .medium))
    let startTimeText = UILabel(text: "")
    let endTimeText = UILabel(text: "")

    let typeLabel = UILabel(text: "Тип", font: .sfProDisplay(ofSize: 24, weight: .medium))
    let typeText = UILabel(text: "")

    let priceLabel = UILabel(text: "Цена", font: .sfProDisplay(ofSize: 24, weight: .medium))
    let priceText = UILabel(text: "")

    let locationLabel = UILabel(text: "Адрес", font: .sfProDisplay(ofSize: 24, weight: .medium))
    let locationText = UILabel(text: "")
    let locationButton = UIButton()

    let descriptionLabel = UILabel(text: "Описание", font: .sfProDisplay(ofSize: 24, weight: .medium))
    let descriptionText = AboutMeInputText(isEditable: false)

    let countPeopleLabel = UILabel(text: "Кол-во гостей", font: .sfProDisplay(ofSize: 24, weight: .medium))
    let currentPeopleText = UILabel(text: "")
    let maxPeopleText = UILabel(text: "")

    let ownerlabel = UILabel(text: "Хозяин вечеринки", font: .sfProDisplay(ofSize: 24, weight: .medium))
    let ownerImage = UIImageView()
    let ownerName = UILabel(text: "")
    let ownerAge = UILabel(text: "")
    let ownerRating = UILabel(text: "􀋂 0")
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }()
    
    var collectionView: UICollectionView!
    
    let party: Party
    
    init(party: Party){
        self.party = party
        
        super.init(nibName: nil, bundle: nil)
        
        nameText.text = party.name
        dateText.text = party.date
        startTimeText.text = party.startTime
        endTimeText.text = party.endTime
        typeText.text = party.type
        priceText.text = party.price
        locationText.text = party.location
        descriptionText.text = party.description
        currentPeopleText.text = party.currentPeople
        maxPeopleText.text = "/ \(party.maximumPeople)"
        
        FirestoreService.shared.getUser(by: party.userId) { [weak self] (result) in
            switch result {
            
            case .success(let puser):
                self?.ownerImage.sd_setImage(with: URL(string: puser.avatarStringURL), completed: nil)
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        locationButton.setImage(UIImage(named: "map"), for: .normal)
        ownerImage.layer.cornerRadius = 43
        ownerImage.clipsToBounds = true
        
        setupCollectionView()
        setupConstraints()
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

        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        ownerRatingAndNameAndAgeStackView.translatesAutoresizingMaskIntoConstraints = false
        ownerStackView.translatesAutoresizingMaskIntoConstraints = false
        ownerAge.translatesAutoresizingMaskIntoConstraints = false
        ownerName.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            locationLabel.centerYAnchor.constraint(equalTo: locationButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            descriptionText.heightAnchor.constraint(equalToConstant: 128),
            descriptionText.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            descriptionText.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 86)
        ])
        
        NSLayoutConstraint.activate([
            ownerImage.heightAnchor.constraint(equalToConstant: 86),
            ownerImage.widthAnchor.constraint(equalToConstant: 86)
        ])
        
        NSLayoutConstraint.activate([
            ownerAge.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            ownerName.trailingAnchor.constraint(equalTo: ownerAge.leadingAnchor, constant: -4)
        ])
        
        NSLayoutConstraint.activate([
            ownerStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            ownerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            ownerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22)
        ])
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
        return usersId.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCell.reuseId, for: indexPath) as! UserCell
        
        FirestoreService.shared.getUser(by: usersId[indexPath.row].uid) { [weak self] (result) in
            switch result {
            
            case .success(let puser):
                cell.configure(with: puser)
                self?.users.append(puser)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    
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
        let user = users[indexPath.item]
        
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
        
        let showPartyViewController = ShowPartyViewController(party: Party(location: "Смоленск, ул. Ново-Мопровская 9, 2", userId: "123123", imageUrlString: "", type: "Домашний хакатон", maximumPeople: "5", currentPeople: "0", id: "idПользователя", date: "12.09", startTime: "12:00", endTime: "13:00", name: "Вечеринка у Руслана, как твои дела, васяяяяолфтыолфтыадлфыоадлфыоалдфоыадлфоадлфыоаа", price: "200", description: "Самая топовая вечеринка", alco: "Да"))
        
        func makeUIViewController(context: Context) -> ShowPartyViewController {
            return showPartyViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
