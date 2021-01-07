//
//  SearchPartyViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 03.12.2020.
//

import UIKit

class SearchPartyViewController: UIViewController {
        
    let barView = SearchPartiesView()
    
    // enum по умолчанию hashable
    enum Section: Int, CaseIterable {
        case parties
        
        func description(partiesCount: Int) -> String {
            switch self {
            
            case .parties:
                if partiesCount < 1 || partiesCount > 5 {
                    return "\(partiesCount) вечеринок"
                } else if partiesCount == 1 {
                    return "\(partiesCount) вечеринка"
                } else if partiesCount > 1 && partiesCount < 5 {
                    return "\(partiesCount) вечеринки"
                } else {
                    return "\(partiesCount) вечеринок"
                }
            }
        }
    }
    
    var parties: [Party] = []
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Party>!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirestoreService.shared.searchPartiesWith{ (result) in
            switch result {
            case .success(let parties):
                self.parties = parties
                self.reloadData(with: nil)
            case .failure(let error):
                self.showAlert(title: "Ошибка!", message: error.localizedDescription)
            }
        }

        view.backgroundColor = .systemBackground
        
        barView.cityButton.addTarget(self, action: #selector(selectCity), for: .touchUpInside)
        
        setupNavigationBar()
        setupSearchBar()
        setupCollectionView()
        createDataSource()
        reloadData(with: nil)
        setupConstraints()
    }
    
    @objc private func selectCity() {
        let citiesVC = CitiesViewController()
        
        self.addChild(citiesVC)
        citiesVC.view.frame = self.view.frame
        self.view.addSubview(citiesVC.view)
        
        citiesVC.didMove(toParent: self)
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = barView
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Поиск"
        
        definesPresentationContext = true // Позволяет отпустить строку поиска, при переходе на другой экран
        searchController.searchBar.delegate = self
    }
    
    @objc private func searchParties() {
        FirestoreService.shared.searchPartiesWith(city: barView.cityButton.titleLabel?.text, type: barView.pickedType, date: barView.dateFormatter.string(from: barView.datePicker.date), maximumPeople: barView.countText.text) { [weak self] (result) in
            switch result {
            
            case .success(let parties):
                self?.parties = parties
            case .failure(let error):
                self?.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemGroupedBackground
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        
        collectionView.register(PartyCell.self, forCellWithReuseIdentifier: PartyCell.reuseId)
        
        collectionView.delegate = self
    }
    
    // Отвечает за заполнение реальными данными. Создает snapshot, добавляет нужные айтемы в нужные секции и регистрируется на dataSource
    private func reloadData(with searchText: String?) {
        
        let filteredParties = parties.filter { (party) -> Bool in
            party.contains(filter: searchText)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Party>()
        snapshot.appendSections([.parties])
        snapshot.appendItems(filteredParties, toSection: .parties)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    deinit {
        print("deinit", SearchPartyViewController.self)
    }
}

// MARK: - Setup constraints
extension SearchPartyViewController {
    
    private func setupConstraints() {
        
        view.addSubview(barView)
        view.addSubview(collectionView)
        
        barView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            barView.topAnchor.constraint(equalTo: view.topAnchor, constant: 144),
            barView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            barView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: barView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Data Source
extension SearchPartyViewController {
    
    // Отвечает за то, в каких секциях буду те или иные ячейки
    private func createDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<Section, Party>(collectionView: collectionView, cellProvider: { [weak self] (collectionView, indexPath, party) -> UICollectionViewCell? in
            
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Неизвестная секция для ячейки")
            }
            
            switch section {
            
            case .parties:
                return self?.configure(collectionView: collectionView, cellType: PartyCell.self, with: party, for: indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { fatalError("Cannot create new section header") }
            
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section kind") }
            
            // Достучались до всех объектов в секции parties
            let items = self.dataSource.snapshot().itemIdentifiers(inSection: .parties)
            
            sectionHeader.configure(text: section.description(partiesCount: items.count), font: .sfProRounded(ofSize: 26, weight: .medium), textColor: .label)
            
            return sectionHeader
        }
    }
}

// MARK: - Setup layout
extension SearchPartyViewController {
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Неизвестная секция для ячейки")
            }
            
            switch section {
            
            case .parties:
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
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(224))
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

// MARK: - UISearchBarDelegate
extension SearchPartyViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        reloadData(with: searchText)
    }
}

// MARK: - UICollectionViewDelegate
extension SearchPartyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let party = self.dataSource.itemIdentifier(for: indexPath) else { return }
        
        let showPartyVC = ShowPartyViewController(party: party)
        present(showPartyVC, animated: true, completion: nil)
    }
}

//MARK: - SwiftUI
import SwiftUI

struct SearchPartyViewControllerProvider: PreviewProvider {
    
    static var previews: some View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let mainTabBarController = MainTabBarController(currentUser: PUser(username: "", email: "", avatarStringURL: "", description: "", sex: "", birthday: "", interestsList: "", smoke: "", alco: "", id: ""))
        
        func makeUIViewController(context: Context) -> MainTabBarController {
            return mainTabBarController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
