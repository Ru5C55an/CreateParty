//
//  MyPartiesViewController.swift
//  CreateParty
//
//  Created by Руслан Садыков on 03.12.2020.
//

import UIKit

class MyPartiesViewController: UIViewController {
    
    let parties = [
        "Вечеринка",
        "Мазукальный вечер",
        "Поэтический вечер",
        "Игра в настольные игры",
        "Спортивный вечер",
        "Игра в компьютерные игры",
        "Игра в мобильные игры",
    ]
    
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
        
        cell.nameLabel.text = parties[indexPath.row]
        cell.imageOfParty.image = UIImage(named: "shit")
        cell.imageOfParty.layer.cornerRadius = cell.imageOfParty.frame.size.height / 2
        cell.imageOfParty.clipsToBounds = true
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
}
