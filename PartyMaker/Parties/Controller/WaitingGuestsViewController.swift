//
//  WaitingGuestsViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 09.01.2021.
//

import UIKit

class WaitingGuestsViewController: UIViewController {
    
    // enum по умолчанию hashable
    enum Section: Int, CaseIterable {
        case users
        
        func description(usersCount: Int) -> String {
            switch self {
            
            case .users:
                if usersCount < 1 || usersCount > 5 {
                    return "\(usersCount) заявок"
                } else if usersCount == 1 {
                    return "\(usersCount) заявка"
                } else if usersCount > 1 && usersCount < 5 {
                    return "\(usersCount) заявки"
                } else {
                    return "\(usersCount) заявок"
                }
            }
        }
    }
    
    private var users = [PUser]()
    private var party: Party
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, PUser>!
    
    init(users: [PUser], party: Party) {
        self.users = users
        self.party = party
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        setupCollectionView()
        createDataSource()
        reloadData()
    }
    
    private func setupCollectionView() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemGroupedBackground
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        
        collectionView.register(WaitingGuestCell.self, forCellWithReuseIdentifier: WaitingGuestCell.reuseId)
        
        collectionView.delegate = self
    }
    
    // Отвечает за заполнение реальными данными. Создает snapshot, добавляет нужные айтемы в нужные секции и регистрируется на dataSource
    private func reloadData() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, PUser>()
        snapshot.appendSections([.users])
        snapshot.appendItems(users, toSection: .users)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    deinit {
        print(users)
        print("deinit", WaitingGuestsViewController.self)
    }
}

// MARK: - Data Source
extension WaitingGuestsViewController {
    
    // Отвечает за то, в каких секциях буду те или иные ячейки
    private func createDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<Section, PUser>(collectionView: collectionView, cellProvider: { [weak self] (collectionView, indexPath, user) -> UICollectionViewCell? in
            
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Неизвестная секция для ячейки")
            }
            
            switch section {
            
            case .users:
                
                #warning("Заменил испольщование функции расширения, т.к. нужно присвоить делегата")
//                return self?.configure(collectionView: collectionView, cellType: WaitingGuestCell.self, with: user, for: indexPath)
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WaitingGuestCell.reuseId, for: indexPath) as? WaitingGuestCell else { fatalError("Unable to dequeue \(WaitingGuestCell.self)")}
                
                cell.configure(with: user)
                cell.delegate = self
                
                return cell
            }
        })
        
        dataSource?.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { fatalError("Cannot create new section header") }
            
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section kind") }
            
            // Достучались до всех объектов в секции parties
            let items = self.dataSource.snapshot().itemIdentifiers(inSection: .users)
            
            sectionHeader.configure(text: section.description(usersCount: items.count), font: .sfProRounded(ofSize: 26, weight: .medium), textColor: .label)
            
            return sectionHeader
        }
    }
}

// MARK: - Setup layout
extension WaitingGuestsViewController {
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Неизвестная секция для ячейки")
            }
            
            switch section {
            
            case .users:
                return self?.createPartiesSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 16
        layout.configuration = config
        
        return layout
    }
    
    private func createPartiesSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(188))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 16, bottom: 0, trailing: 16)
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .top)
        return sectionHeader
    }
}

extension WaitingGuestsViewController: WaitingGuestsNavigation {
    
    func removeWaitingGuest(user: PUser) {
        FirestoreService.shared.deleteWaitingGuest(user: user, party: party) { (result) in
            switch result {
            
            case .success():
                self.showAlert(title: "Успешно!", message: "Заявка пользователя \(user.username) была отклонена")
            case .failure(let error):
                self.showAlert(title: "Ошибка!", message: error.localizedDescription)
            }
        }
    }
    
    func changeToApproved(user: PUser) {
        FirestoreService.shared.changeToApproved(user: user, party: party) { (result) in
            switch result {
            
            case .success():
                self.showAlert(title: "Успешно!", message: "Приятно проведите время с \(user.username)")
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension WaitingGuestsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = self.dataSource.itemIdentifier(for: indexPath) else { return }
        
        let partyRequestVC = PartyRequestViewController(user: user)
        partyRequestVC.delegate = self
        present(partyRequestVC, animated: true, completion: nil)
    }
}
