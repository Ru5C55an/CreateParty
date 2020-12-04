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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = parties[indexPath.row]
        return cell!
    }
    
}
