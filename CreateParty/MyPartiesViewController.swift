//
//  MyPartiesViewController.swift
//  CreateParty
//
//  Created by Руслан Садыков on 03.12.2020.
//

import UIKit
import RealmSwift

class MyPartiesViewController: UIViewController {
    
    
    @IBOutlet weak var partiesListTable: UITableView!
    
    var parties: Results<Party>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        parties = realm.objects(Party.self)
    }

}

extension MyPartiesViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parties.isEmpty ? 0 : parties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! PartyTableViewCell
        
        let party = parties[indexPath.row]
        
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
            let party = parties[indexPath.row]
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
