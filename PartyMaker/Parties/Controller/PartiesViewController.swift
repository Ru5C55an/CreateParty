//
//  PartiesViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 18.12.2020.
//

import UIKit
import FirebaseFirestore

class PartiesViewController: UIViewController {
    
    private var partiesListener: ListenerRegistration?
    
    var parties = Bundle.main.decode([Party].self, from: "parties.json")
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Party>!
    
    private var ascendingSorting = true

    var reverseSortingBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "AZ"), style: .plain, target: self, action: #selector(reverseSortingBarButtonItemTapped))
    
    let sortingSegmentedControl = UISegmentedControl(first: "Дата", second: "Имя")
    var sortingTypeSegmentControlBarButtonItem: UIBarButtonItem!
    
    let partiesSegmentedControl = UISegmentedControl(first: "Созданные мной", second: "Хочу пойти")
    
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
    
    private let currentUser: PUser
    
    init(currentUser: PUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.username
    }
    
    deinit {
        partiesListener?.remove()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sortingSegmentedControl.addTarget(self, action: #selector(sortSelection), for: .valueChanged)
        
        sortingTypeSegmentControlBarButtonItem = UIBarButtonItem(customView: sortingSegmentedControl)
        
        setupNavigationBar()
        setupSearchBar()
        setupCollectionView()
        createDataSource()
        reloadData(with: nil)
        
//        partiesListener = ...
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = reverseSortingBarButtonItem
        navigationItem.rightBarButtonItem = sortingTypeSegmentControlBarButtonItem
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        //        navigationItem.hidesSearchBarWhenScrolling = false
        //                searchController.hidesNavigationBarDuringPresentation = false
        //                searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Поиск"
        
        definesPresentationContext = true // Позволяет отпустить строку поиска, при переходе на другой экран
        searchController.searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .mainWhite()
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        
        collectionView.register(PartyCell.self, forCellWithReuseIdentifier: PartyCell.reuseId)
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
}

// MARK: - Data Source
extension PartiesViewController {
    
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
extension PartiesViewController {
    
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

// MARK: - Actions
extension PartiesViewController {
    
    @objc func sortSelection() {
        
        //ToDo sorting
//        sorting()
    }
    
    @objc func reverseSortingBarButtonItemTapped() {
        
        ascendingSorting.toggle()
        
        if ascendingSorting {
            reverseSortingBarButtonItem.image = #imageLiteral(resourceName: "AZ")
        } else {
            reverseSortingBarButtonItem.image = #imageLiteral(resourceName: "ZA")
        }
        
        //ToDo sorting
//        sorting()
    }
    
    // ToDo sorting
//    private func sorting() {
//        
//        if sortingSegmentedControl.selectedSegmentIndex == 0 {
//            parties = parties.sorted(by: { $0.date > $1.date })
//        } else {
//            parties = parties.sorted(by: { $0.username > $1.username })
//        }
//        
//        reloadData(with: nil)
//    }
}

// MARK: - UISearchBarDelegate
extension PartiesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        reloadData(with: searchText)
    }
}

//MARK: - SwiftUI
import SwiftUI

struct PartiesViewControllerProvider: PreviewProvider {
    
    static var previews: some View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let mainTabBarController = MainTabBarController()
        
        func makeUIViewController(context: Context) -> MainTabBarController {
            return mainTabBarController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}

//    private var parties: Results<Party>!
//
//    var collectionView: UICollectionView!
//
//    private var filteredParties: Results<Party>!
//    private var ascendingSorting = true
//    private var isFiltering: Bool {
//        return searchController.isActive && !searchBarIsEmpty
//    }
//
//    let searchController = UISearchController()
//    private var searchBarIsEmpty: Bool {
//        guard let text = searchController.searchBar.text else { return false }
//        return text.isEmpty
//    }
//
//    let reverseSortingBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "AZ"), style: .done, target: self, action: #selector(reverseSortingBarButtonItemTapped))
//
//    let segmentedControl = UISegmentedControl(items: ["Дата", "Имя"])
//
//    var sortingTypeSegmentControlBarButtonItem: UIBarButtonItem!
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        parties = realm.objects(Party.self)
//
//        segmentedControl.addTarget(self, action: #selector(sortSelection), for: .valueChanged)
//        segmentedControl.selectedSegmentIndex = 0
//        sortingTypeSegmentControlBarButtonItem = UIBarButtonItem(customView: segmentedControl)
//
//        setupNavigationBar()
//        setupCollectionView()
//    }
//
//    private func setupNavigationBar() {
//       // searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false // Отключаем ограничение на взаимодействие с объектами результата поиска
//        searchController.searchBar.placeholder = "Поиск"
//        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.obscuresBackgroundDuringPresentation = false
//
//        reverseSortingBarButtonItem.image = #imageLiteral(resourceName: "AZ")
//
//
//        navigationItem.searchController = searchController
////        navigationItem.hidesSearchBarWhenScrolling = false
//        navigationItem.leftBarButtonItem = reverseSortingBarButtonItem
//        navigationItem.rightBarButtonItem = sortingTypeSegmentControlBarButtonItem
//
////        navigationController?.navigationBar.prefersLargeTitles = true
//        title = "Вечеринки"
//    }
//

//
//}
//    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "showDetailSegue" {
//
//            let cell = sender as! PartyCell
//            if let indexPath = self.collectionView.indexPath(for: cell) {
//                let party = isFiltering ? filteredParties[indexPath.row] : parties[indexPath.row]
//                let newPartyVC = segue.destination as! EditPartyTableViewController
//                newPartyVC.currentParty = party
//            }
//
//        }
//
//    }
//
//}
