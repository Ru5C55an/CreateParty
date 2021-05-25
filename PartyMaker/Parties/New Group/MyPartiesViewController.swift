//
//  MyPartiesViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 03.12.2020.
//

import UIKit
import Cosmos

class MyPartiesViewController: UIViewController {
}
/*
    // private - свойства доступные только в этом классе. Мы не должны видеть эти свойства из каких-то других объектов
    private var parties: Results<Party>!
    
    private var filteredParties: Results<Party>!
    private var ascendingSorting = true
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private let searchController  = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    @IBOutlet weak var sortingTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var reversedSortingButton: UIBarButtonItem!
    
    @IBOutlet weak var partiesListTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        parties = realm.objects(Party.self)
        
        // Устанавливаем search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false // Отключаем ограничение на взаимодействие с объектами результата поиска
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true // Позволяет отпустить строку поиска, при переходе на другой экран
        
    }
    
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        
        sorting()
        
    }
    
    @IBAction func reverseSorting(_ sender: Any) {
        
        ascendingSorting.toggle()
        
        if ascendingSorting {
            reversedSortingButton.image = #imageLiteral(resourceName: "AZ")
        } else {
            reversedSortingButton.image = #imageLiteral(resourceName: "ZA")
        }
        
        sorting()
        
    }
    
    private func sorting() {
        
        if sortingTypeSegmentedControl.selectedSegmentIndex == 0 {
            parties = parties.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            parties = parties.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        
        partiesListTable.reloadData()
        
    }
    
    deinit {
        print("deinit", MyPartiesViewController.self)
    }
    
}

extension MyPartiesViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if isFiltering {
            return filteredParties.count
        }
        
        return parties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! PartyTableViewCell
        
        let party = isFiltering ? filteredParties[indexPath.row] : parties[indexPath.row]
        
        cell.nameLabel.text = party.name
        cell.locationLabel.text = party.location
        cell.typeLabel.text = party.type
        cell.imageOfParty.image = UIImage(data: party.imageData!)
        cell.cosmosView.rating = party.rating
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetailSegue" {
            guard let indexPath = partiesListTable.indexPathForSelectedRow else { return }
            
            let party = isFiltering ? filteredParties[indexPath.row] : parties[indexPath.row]
            
            let newPartyVC = segue.destination as! EditPartyTableViewController
            newPartyVC.currentParty = party
        }
        
    }
    
    @IBAction func unwindSegueToMyParties( _ segue: UIStoryboardSegue) {
        if let createPartyVC = segue.source as? CreatePartyTableViewController {
            createPartyVC.tappedButton(createPartyVC.saveButton)
        } else if let editPartyVC = segue.source as? EditPartyTableViewController {
            editPartyVC.saveChanges(editPartyVC.saveButton)
        }
        partiesListTable.reloadData()
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // Убирает выделение ячейки после возвращения с экрана EditParty
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let party = parties[indexPath.row]
            StorageManager.deleteObject(party)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    //Используется для добавления нескольких Action
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        let party = parties[indexPath.row]
//
//        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { (_, _, _) in
//            StorageManager.deleteObject(party)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//
//        return UISwipeActionsConfiguration(actions: [deleteAction])
//    }
    
}

extension MyPartiesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        filteredParties = parties.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@ OR type CONTAINS[c] %@", searchText, searchText, searchText)
        
        partiesListTable.reloadData()
        
    }
    
}
 */
