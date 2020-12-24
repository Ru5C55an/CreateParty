//
//  PartiesViewController.swift
//  CreateParty
//
//  Created by Руслан Садыков on 18.12.2020.
//

import UIKit
import RealmSwift

class PartiesViewController: UIViewController {
    
    private var parties: Results<Party>!
    
    var collectionView: UICollectionView!
    
    private var filteredParties: Results<Party>!
    private var ascendingSorting = true
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    let searchController = UISearchController()
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    let reverseSortingBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "AZ"), style: .done, target: self, action: #selector(reverseSortingBarButtonItemTapped))
    
    let segmentedControl = UISegmentedControl(items: ["Дата", "Имя"])
    
    var sortingTypeSegmentControlBarButtonItem: UIBarButtonItem!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parties = realm.objects(Party.self)
        
        segmentedControl.addTarget(self, action: #selector(sortSelection), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        sortingTypeSegmentControlBarButtonItem = UIBarButtonItem(customView: segmentedControl)
        
        setupNavigationBar()
        setupCollectionView()
    }
    
    private func setupNavigationBar() {
       // searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false // Отключаем ограничение на взаимодействие с объектами результата поиска
        searchController.searchBar.placeholder = "Поиск"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
        definesPresentationContext = true // Позволяет отпустить строку поиска, при переходе на другой экран
        
        reverseSortingBarButtonItem.image = #imageLiteral(resourceName: "AZ")
        
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
        navigationItem.searchController = searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.leftBarButtonItem = reverseSortingBarButtonItem
        navigationItem.rightBarButtonItem = sortingTypeSegmentControlBarButtonItem
        
//        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Вечеринки"
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        
        collectionView.backgroundColor = .gray
        view.addSubview(collectionView)
        collectionView.register(PartyCell.self, forCellWithReuseIdentifier: PartyCell.reuseID)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

extension PartiesViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredParties.count
        }
        
        return parties.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PartyCell.reuseID, for: indexPath) as! PartyCell
        
        let party = isFiltering ? filteredParties[indexPath.row] : parties[indexPath.row]
        
        cell.configure(with: party)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetailSegue" {
            
            let cell = sender as! PartyCell
            if let indexPath = self.collectionView.indexPath(for: cell) {
                let party = isFiltering ? filteredParties[indexPath.row] : parties[indexPath.row]
                let newPartyVC = segue.destination as! EditPartyTableViewController
                newPartyVC.currentParty = party
            }
        
        }
        
    }

}

extension PartiesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 343, height: 223)
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
        
        if segmentedControl.selectedSegmentIndex == 0 {
            parties = parties.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            parties = parties.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        
        collectionView.reloadData()
        
    }
}

extension PartiesViewController: UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        filteredParties = parties.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@ OR type CONTAINS[c] %@", searchText, searchText, searchText)
        
        collectionView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}


