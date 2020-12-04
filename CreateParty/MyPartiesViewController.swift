//
//  MyPartiesViewController.swift
//  CreateParty
//
//  Created by Руслан Садыков on 03.12.2020.
//

import UIKit

class MyPartiesViewController: UIViewController {
    
    let parties = [Party(name: "какашка", location: "унитаз", type: "Смывка", image: "shit")]
    
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
        
        cell.nameLabel.text = parties[indexPath.row].name
        cell.locationLabel.text = parties[indexPath.row].location
        cell.typeLabel.text = parties[indexPath.row].type
        cell.imageOfParty.image = UIImage(named: parties[indexPath.row].image)
        cell.imageOfParty.layer.cornerRadius = cell.imageOfParty.frame.size.height / 2
        cell.imageOfParty.clipsToBounds = true
        
        return cell
    }
    
    // MARK: - Table view delegate
    
}
