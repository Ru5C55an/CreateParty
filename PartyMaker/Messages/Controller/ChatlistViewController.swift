//
//  MessagesViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 03.12.2020.
//

import UIKit
import FirebaseFirestore

class ChatlistViewController: UIViewController {
    
    var activeChats = [PChat]()
    var waitingChats = [PChat]()
    
    private var waitingChatsListener: ListenerRegistration?
    private var activeChatsListener: ListenerRegistration?
    
    // enum по умолчанию hashable
    enum Section: Int, CaseIterable {
        case waitingChats
        case activeChats
        
        func description() -> String {
            switch self {
            
            case .waitingChats:
                return "Ожидающие чаты"
            case .activeChats:
                return "Активные чаты"
            }
        }
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, PChat>?
    
    private let currentUser: PUser
    
    init(currentUser: PUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit", ChatlistViewController.self)
        waitingChatsListener?.remove()
        activeChatsListener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupCollectionView()
        createDataSource()
        reloadData()
        
        waitingChatsListener = ListenerService.shared.waitingChatsObserve(chats: waitingChats, completion: { (result) in
            switch result {
        
            case .success(let chats):
                
                if self.waitingChats != [], self.waitingChats.count <= chats.count {
                    let chatRequestVC = ChatRequestViewController(chat: chats.last!)
                    chatRequestVC.delegate = self
                    self.present(chatRequestVC, animated: true, completion: nil)
                }
                
                self.waitingChats = chats
                self.reloadData()
                
            case .failure(let error):
                self.showAlert(title: "Ошибка!", message: error.localizedDescription)
            }
        })
        
        activeChatsListener = ListenerService.shared.activeChatsObserve(chats: activeChats, completion: { (result) in
            switch result {
            
            case .success(let chats):
                self.activeChats = chats
                self.reloadData()
                
            case .failure(let error):
                self.showAlert(title: "Ошибка!", message: error.localizedDescription)
            }
        })
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
//        navigationItem.hidesSearchBarWhenScrolling = true
//        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .mainWhite()
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        
        collectionView.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseId)
        collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseId)
        
        collectionView.delegate = self
    }
    
    // Отвечает за заполнение реальными данными. Создает snapshot, добавляет нужные айтемы в нужные секции и регистрируется на dataSource
    private func reloadData() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, PChat>()
        snapshot.appendSections([.waitingChats, .activeChats])
        snapshot.appendItems(waitingChats, toSection: .waitingChats)
        snapshot.appendItems(activeChats, toSection: .activeChats)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Data Source
extension ChatlistViewController {
    
    // Отвечает за то, в каких секциях буду те или иные ячейки
    private func createDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<Section, PChat>(collectionView: collectionView, cellProvider: { [weak self] (collectionView, indexPath, chat) -> UICollectionViewCell? in
            
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Неизвестная секция для ячейки")
            }
            
            switch section {
            
            case .activeChats:
                return self?.configure(collectionView: collectionView, cellType: ActiveChatCell.self, with: chat, for: indexPath)
            case .waitingChats:
                return self?.configure(collectionView: collectionView, cellType: WaitingChatCell.self, with: chat, for: indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { fatalError("Cannot create new section header") }
            
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section kind") }
            
            sectionHeader.configure(text: section.description(), font: .sfProRounded(ofSize: 20, weight: .medium), textColor: #colorLiteral(red: 0.5725490196, green: 0.5725490196, blue: 0.5725490196, alpha: 1))
            
            return sectionHeader
        }
    }
}

// MARK: - Setup layout
extension ChatlistViewController {
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Неизвестная секция для ячейки")
            }
            
            switch section {
            
            case .activeChats:
                return self?.createActiveChats()
            case .waitingChats:
                return self?.createWaitingChats()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 16
        layout.configuration = config
        
        return layout
    }
    
    private func createWaitingChats() -> NSCollectionLayoutSection {
        
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(88), heightDimension: .absolute(88))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 16, bottom: 0, trailing: 16)
        section.orthogonalScrollingBehavior = .continuous
        
        let sectionHeader = createSectionHeader()
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func createActiveChats() -> NSCollectionLayoutSection {
        
        // section -> group -> item -> size
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(78))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
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
extension ChatlistViewController: UISearchBarDelegate {
    
    //    func updateSearchResults(for searchController: UISearchController) {
    //      filterContentForSearchText(searchController.searchBar.text!)
    //    }
    //
    //    private func filterContentForSearchText(_ searchText: String) {
    //
    //        filteredParties = parties.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@ OR type CONTAINS[c] %@", searchText, searchText, searchText)
    //
    //        collectionView.reloadData()
    //
    //    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

// MARK: - UICollectionViewDelegate
extension ChatlistViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let chat = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        switch section {

        case .waitingChats:
            let chatRequestVC = ChatRequestViewController(chat: chat)
            chatRequestVC.delegate = self
            self.present(chatRequestVC, animated: true, completion: nil)
        case .activeChats:
            let chatVC = ChatViewController(user: currentUser, chat: chat)
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }
}

extension ChatlistViewController: WaitingChatsNavigation {
    func removeWaitingChat(chat: PChat) {
        FirestoreService.shared.deleteWaitingChat(chat: chat) { (result) in
            switch result {
            
            case .success():
                self.showAlert(title: "Успешно!", message: "Час с \(chat.friendUsername) был удален")
            case .failure(let error):
                self.showAlert(title: "Ошибка!", message: error.localizedDescription)
            }
        }
    }
    
    func changeToActive(chat: PChat) {
        FirestoreService.shared.changeToActive(chat: chat) { (result) in
            switch result {
            
            case .success():
                self.showAlert(title: "Успешно!", message: "Приятного общения с \(chat.friendUsername)")
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
}

//MARK: - SwiftUI
import SwiftUI

struct ChatlistControllerProvider: PreviewProvider {
    
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
