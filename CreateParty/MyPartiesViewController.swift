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
    
    @IBAction func unwindSegueToMyParties( _ segue: UIStoryboardSegue) {
        guard let createPartyVC = segue.source as? CreatePartyTableViewController else { return }
        createPartyVC.tappedButton(createPartyVC.saveButton)
        partiesListTable.reloadData()
    }
    
    // MARK: - Table view delegate
    
}
