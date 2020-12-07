//
//  MyPartiesViewController.swift
//  CreateParty
//
//  Created by Руслан Садыков on 03.12.2020.
//

import UIKit
import RealmSwift

class MyPartiesViewController: UIViewController {
    
    // private - свойства доступные только в этом классе. Мы не должны видеть эти свойства из каких-то других объектов
    private let searchController  = UISearchController(searchResultsController: nil)
    private var parties: Results<Party>!
    private var filteredParties: Results<Party>!
    private var ascendingSorting = true
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }

    @IBOutlet weak var sortingTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var partiesListTable: UITableView!
    
    @IBOutlet weak var reversedSortingButton: UIBarButtonItem!
    
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
}

extension MyPartiesViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if isFiltering {
            return filteredParties.count
        }
        
        return parties.isEmpty ? 0 : parties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! PartyTableViewCell
        
        var party = Party()
        
        if isFiltering {
            party = filteredParties[indexPath.row]
        } else {
            party = parties[indexPath.row]
        }
        
        cell.nameLabel.text = party.name
        cell.locationLabel.text = party.location
        cell.typeLabel.text = party.type
        cell.imageOfParty.layer.cornerRadius = cell.imageOfParty.frame.size.height / 2
        cell.imageOfParty.clipsToBounds = true
        cell.imageOfParty.image = UIImage(data: party.imageData!)
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetailSegue" {
            guard let indexPath = partiesListTable.indexPathForSelectedRow else { return }
            var party = Party()
            
            if isFiltering {
                party = filteredParties[indexPath.row]
            } else {
                party = parties[indexPath.row]
            }
            
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
