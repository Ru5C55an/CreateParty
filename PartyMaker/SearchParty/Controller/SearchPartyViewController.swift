//
//  SearchPartyViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 03.12.2020.
//

import UIKit
import Hero

class SearchPartyViewController: UIViewController {
        
    // MARK: - UI Elements
    let filterView = FilterPartiesView()
    let barView = SearchPartiesBar()
    
    var collectionView: UICollectionView!
    
    //MARK: - Properties
    // enum по умолчанию hashable
    enum Section: Int, CaseIterable {
        case parties
        
        func description(partiesCount: Int) -> String {
            switch self {
            
            case .parties:
                return partiesCount.parties()
            }
        }
    }
    
    var parties: [Party] = []
    var dataSource: UICollectionViewDiffableDataSource<Section, Party>!
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .systemGroupedBackground
        
        searchParties()
        addTargets()
        setupNavigationBar()
        setupCollectionView()
        createDataSource()
        setupConstraints()
    }
    
    // MARK: - Setup views
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Handlers
    private func addTargets() {
        filterView.cityButton.addTarget(self, action: #selector(selectCity), for: .touchUpInside)
        filterView.countStepper.addTarget(self, action: #selector(searchParties), for: .valueChanged)
        filterView.datePicker.addTarget(self, action: #selector(searchParties), for: .valueChanged)
        barView.filterButton.addTarget(self, action: #selector(showFilter), for: .touchUpInside)
    }
    
    @objc private func showFilter() {
        
//        barView.hero.id = "ironMan"
//        filterView.hero.id = "batMan"
        
        let searchPartiesFilteredVC = SearchPartiesFilteredVC()
//        searchPartiesFilteredVC.hero.isEnabled = true
        
        present(searchPartiesFilteredVC, animated: true, completion: nil)
    }
    
    @objc private func selectCity() {
        let citiesVC = CitiesViewController()
        
        self.addChild(citiesVC)
        citiesVC.view.frame = self.view.frame
        self.view.addSubview(citiesVC.view)
        
        citiesVC.didMove(toParent: self)
    }
    
    @objc private func searchParties() {
        
        FirestoreService.shared.searchPartiesWith(city: filterView.cityButton.titleLabel?.text, type: filterView.pickedType, date: filterView.dateFormatter.string(from: filterView.datePicker.date), maximumPeople: filterView.countText.text, price: filterView.priceTextField.text) { [weak self] (result) in
            
            switch result {
            
            case .success(let parties):
                self?.parties = parties
                self?.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
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
    private func reloadData() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Party>()
        snapshot.appendSections([.parties])
        snapshot.appendItems(parties, toSection: .parties)
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
        
        barView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(22)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(barView.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
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

// MARK: - UICollectionViewDelegate
extension SearchPartyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let party = self.dataSource.itemIdentifier(for: indexPath) else { return }
        
        let showPartyVC = ShowPartyViewController(party: party, target: "search")
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
        
        let mainTabBarController = MainTabBarController(currentUser: PUser(username: "", email: "", avatarStringURL: "", description: "", sex: "", birthday: "", interestsList: "", smoke: "", alco: "", personalColor: "", id: ""))
        
        func makeUIViewController(context: Context) -> MainTabBarController {
            return mainTabBarController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
