//
//  MyPartiesViewController.swift
//  CreateParty
//
//  Created by Руслан Садыков on 03.12.2020.
//

import UIKit

class MyPartiesViewController: UIViewController {
    
    
    @IBOutlet weak var partiesListTable: UITableView!
    
    var parties = [Party(name: "какашка", location: "унитаз", type: "Смывка", stringImage: "shit")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension MyPartiesViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! PartyTableViewCell
        
        let party = parties[indexPath.row]
        
        cell.nameLabel.text = party.name
        cell.locationLabel.text = party.location
        cell.typeLabel.text = party.type
        cell.imageOfParty.layer.cornerRadius = cell.imageOfParty.frame.size.height / 2
        cell.imageOfParty.clipsToBounds = true
        cell.imageOfParty.image = party.image
        
        return cell
    }
    
    @IBAction func unwindSegueToMyParties( _ segue: UIStoryboardSegue) {
        guard let createPartyVC = segue.source as? CreatePartyTableViewController else { return }
        createPartyVC.tappedButton(createPartyVC.saveButton)
        parties.append(createPartyVC.newParty!)
        partiesListTable.reloadData()
    }
    
    // MARK: - Table view delegate
    
}
