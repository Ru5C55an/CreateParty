//
//  PartiesViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 18.12.2020.
//

import UIKit
import FirebaseFirestore

class PartiesViewController: UIViewController {
    
    private var ascendingSorting = true
    lazy var reverseSortingBarButtonItem: UIBarButtonItem = {
        UIBarButtonItem.init(image: #imageLiteral(resourceName: "AZ"), style: .plain, target: self, action: #selector(reverseSortingBarButtonItemTapped))
    }()
    
    let sortingSegmentedControl = UISegmentedControl(first: "Дата", second: "Имя")
    var sortingTypeSegmentControlBarButtonItem: UIBarButtonItem!
    private let partiesSegmentedControl = UISegmentedControl(items: ["􀊫", "􀆅", "􀇲", "􀉩"])
    
    private var parties = [Party]()
    
    private var searchedParties = [Party]()
    
    private var waitingPartiesListener: ListenerRegistration?
    private var waitingParties = [Party]()
    private var approvedPartiesListener: ListenerRegistration?
    private var approvedParties = [Party]()
    private var myPartiesListener: ListenerRegistration?
    private var myParties = [Party]()
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Party>!
    
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
    
    private let currentUser: PUser
    
    init(currentUser: PUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.username
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        partiesSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.sfProDisplay(ofSize: 12, weight: .medium)], for: .normal)
        
        sortingSegmentedControl.addTarget(self, action: #selector(sortSelection), for: .valueChanged)
        partiesSegmentedControl.addTarget(self, action: #selector(reloadPartiesType), for: .valueChanged)
        partiesSegmentedControl.selectedSegmentIndex = 0
        
        sortingTypeSegmentControlBarButtonItem = UIBarButtonItem(customView: sortingSegmentedControl)
        
        setupNavigationBar()
        setupSearchBar()
        setupCollectionView()
        createDataSource()
        reloadData(with: nil)
        
        waitingPartiesListener = ListenerService.shared.waitingPartiesObserve(parties: waitingParties, completion: { (result) in
            switch result {
        
            case .success(let parties):
                self.waitingParties = parties
                self.reloadPartiesType()
                
            case .failure(let error):
                self.showAlert(title: "Ошибка!", message: error.localizedDescription)
            }
        })
        
        approvedPartiesListener = ListenerService.shared.approvedPartiesObserve(parties: approvedParties, completion: { (result) in
            switch result {
        
            case .success(let parties):
                self.approvedParties = parties
                self.reloadPartiesType()
                
            case .failure(let error):
                self.showAlert(title: "Ошибка!", message: error.localizedDescription)
            }
        })
        
        myPartiesListener = ListenerService.shared.myPartiesObserve(parties: myParties, completion: { (result) in
            switch result {
        
            case .success(let parties):
                self.myParties = parties
                self.reloadPartiesType()
                
            case .failure(let error):
                self.showAlert(title: "Ошибка!", message: error.localizedDescription)
            }
        })
    }
    
    private var target = ""
    
    @objc private func reloadPartiesType() {
        
        switch partiesSegmentedControl.selectedSegmentIndex {
        case 0:
            searchParties(filter: [String : String]())
            target = "searched"
        case 1:
            parties = approvedParties
            target = "approved"
        case 2:
            parties = waitingParties
            target = "waiting"
        case 3:
            parties = myParties
            target = "my"
        default:
            break
        }
        
        reloadData(with: nil)
        
        // Костыльно наверное. Нужно чтобы число вечеринок обновлялось
        collectionView.reloadData()
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
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = reverseSortingBarButtonItem
        reverseSortingBarButtonItem.action = #selector(reverseSortingBarButtonItemTapped)
        navigationItem.rightBarButtonItem = sortingTypeSegmentControlBarButtonItem
        navigationItem.titleView = partiesSegmentedControl
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
//                        searchController.hidesNavigationBarDuringPresentation = true
        //                searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Поиск"
        
        definesPresentationContext = true // Позволяет отпустить строку поиска, при переходе на другой экран
        searchController.searchBar.delegate = self
    }
    
    deinit {
        print("deinit", PartiesViewController.self)
        waitingPartiesListener?.remove()
        approvedPartiesListener?.remove()
        myPartiesListener?.remove()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        sorting()
    }
    
    @objc func reverseSortingBarButtonItemTapped() {
        
        ascendingSorting.toggle()
        
        if ascendingSorting {
            reverseSortingBarButtonItem.image = #imageLiteral(resourceName: "AZ")
        } else {
            reverseSortingBarButtonItem.image = #imageLiteral(resourceName: "ZA")
        }
        
        sorting()
    }
    
    private func sorting() {
        
        if sortingSegmentedControl.selectedSegmentIndex == 0 {
            if ascendingSorting {
                parties = parties.sorted(by: { $0.date > $1.date })
            } else {
                parties = parties.sorted(by: { $0.date < $1.date })
            }
        } else {
            if ascendingSorting {
                parties = parties.sorted(by: { $0.name > $1.name })
            } else {
                parties = parties.sorted(by: { $0.name < $1.name })
            }
        }
        
        reloadData(with: nil)
    }
}

// MARK: - UISearchBarDelegate
extension PartiesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(with: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        reloadData(with: nil)
    }
}

// MARK: - UICollectionViewDelegate
extension PartiesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let party = self.dataSource.itemIdentifier(for: indexPath) else { return }
        
        let showPartyVC = ShowPartyViewController(party: party, target: target)
        present(showPartyVC, animated: true, completion: nil)
    }
}

// MARK: - Search parties
extension PartiesViewController {
    @objc private func searchParties(filter: [String: String]) {
        
        FirestoreService.shared.searchPartiesWith(city: filter["city"], type: filter["type"], date: filter["date"], countPeoples: filter["countPeoples"], price: filter["price"], charCountPeoples: filter["charCountPeoples"], charPrice: filter["charPrice"]) { [weak self] (result) in
            
            switch result {
            
            case .success(let parties):
           
          
                self?.searchedParties = parties
                
                if filter["charCountPeoples"] == ">" {
                    if let countPeoples = filter["countPeoples"], countPeoples != "" { self?.searchedParties.removeAll(where: { $0.maximumPeople < countPeoples }) }
                } else if filter["charCountPeoples"] == "<" {
                    if let countPeoples = filter["countPeoples"], countPeoples != "" { self?.searchedParties.removeAll(where: { $0.maximumPeople > countPeoples }) }
                } else if filter["charCountPeoples"] == "=" {
                    if let countPeoples = filter["countPeoples"], countPeoples != "" { self?.searchedParties.removeAll(where: { $0.maximumPeople != countPeoples }) }
                }
                
                if filter["charPrice"] == ">" {
                    if let price = filter["price"], price != "" {  self?.searchedParties.removeAll(where: { $0.price < price }) }
                } else if filter["charPrice"] == "<" {
                    if let price = filter["price"], price != "" { self?.searchedParties.removeAll(where: { $0.price > price }) }
                } else if filter["charPrice"] == "=" {
                    if let price = filter["price"], price != "" { self?.searchedParties.removeAll(where: { $0.price != price }) }
                }
                
                self?.parties = self?.searchedParties ?? [Party]()
                
                self?.reloadData(with: nil)
                
                // Костыльно наверное. Нужно чтобы число вечеринок обновлялось
                self?.collectionView.reloadData()
                
            case .failure(let error):
                self?.parties = [Party]()
                print(error.localizedDescription)
                self?.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
}

extension PartiesViewController: SearchPartyFilterDelegate {
    func didChangeFilter(filter: [String : String]) {
        searchParties(filter: filter)
    }
}

//MARK: - SwiftUI
import SwiftUI

struct PartiesViewControllerProvider: PreviewProvider {
    
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
