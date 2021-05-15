//
//  BottleGameHistoryScene.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 13.05.2021.
//

import SpriteKit
import UIKit

struct HistoryData {
    let date: Date
    let firstPlayer: String?
    let secondPlayer: String
    let action: String
}

class GameBottleHistoryTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var historyData = [HistoryData]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.separatorStyle = .none
        self.backgroundColor = .clear
        
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = "\(historyData[indexPath.row].date)" + (historyData[indexPath.row].firstPlayer ?? "") + historyData[indexPath.row].action + historyData[indexPath.row].secondPlayer
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Секция \(section)"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
}

class BottleGameHistoryScene: BottleGameParentScene {
        
    var historyTableView = GameBottleHistoryTableView()

    override func didMove(to view: SKView) {
                
        setHeader(withTitle: "История")
    
        gameSettings.loadHistory()
        
        historyTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        historyTableView.frame=CGRect(x:20,y:150,width: UIScreen.main.bounds.width - 50,height:450)
        self.scene?.view?.addSubview(historyTableView)
        
        historyTableView.historyData = gameSettings.historyData
        
        historyTableView.reloadData()
        
        let backButton = BottleGameHandButton(title: "Назад", color: #colorLiteral(red: 0.9882352941, green: 0.431372549, blue: 0.2745098039, alpha: 1), hand: HandButtons.back, scale: 0.6, fontSize: 30)
        backButton.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 200)
        backButton.name = "backButton"
        addChild(backButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
       if node.name == "backButton" {
            self.scene?.view?.willRemoveSubview(historyTableView)
            let transition = SKTransition.crossFade(withDuration: 1.0)
            guard let backScene = backScene else { return }
            backScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(backScene, transition: transition)
       }
    }
}
