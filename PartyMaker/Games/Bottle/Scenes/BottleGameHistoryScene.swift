//
//  BottleGameHistoryScene.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 13.05.2021.
//

import SpriteKit
import UIKit

class GameBottleHistoryTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var historyData = [HistoryData]()
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM yy"
        return dateFormatter
    }()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.separatorStyle = .none
        self.backgroundColor = .clear
        
        self.delegate = self
        self.dataSource = self
        
        self.allowsSelection = false
        
        self.register(BottleGameHistoryCell.self, forCellReuseIdentifier: BottleGameHistoryCell.reuseId)
    }
    
    struct DateSection {
        var date: Date
        var historyData: [HistoryData]
    }
    
    var sections = [DateSection]()
    
    private func firstDayOfMonth(date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(from: components)!
    }
    
    func reloadHistory() {
        
        let groups = Dictionary(grouping: self.historyData) { (historyData) in
            return firstDayOfMonth(date: historyData.date)
        }
        
        self.sections = groups.map { (key, values) in
            let sortedValues = values.sorted { (lhs, rhs) in lhs.date > rhs.date }
            return DateSection(date: key, historyData: sortedValues)
        }
        
        self.sections.sort { (lhs, rhs) in lhs.date > rhs.date }
        
        reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        return section.historyData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = self.sections[section]
        let view = UIView()
        
        let date = dateFormatter.string(from: section.date)
        let titleLabel = UILabel(text: "\(date) год", font: UIFont.sfProRounded(ofSize: 20, weight: .medium), textColor: .black)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.center.equalToSuperview()
        }
        
        view.layer.cornerRadius = 15
        view.backgroundColor = .systemBlue
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BottleGameHistoryCell.reuseId)! as! BottleGameHistoryCell
        
        let section = self.sections[indexPath.section]
        let historyData = section.historyData[indexPath.row]
        
        cell.configure(with: historyData)
                
        cell.backView.layer.cornerRadius = 15
        
        if section.historyData.count == 1 {
            cell.backView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else if indexPath.row == section.historyData.count - 1 {
            cell.backView.layer.maskedCorners =  [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else if  indexPath.row == 0 {
            cell.backView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            cell.backView.layer.cornerRadius = 0
        }
        
        cell.backView.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.sections[section]
        let date = section.date
        return dateFormatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
          return 10
      }

      func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
          return UIView()
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
                
        self.scene?.view?.addSubview(historyTableView)
        
        historyTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.left.right.equalToSuperview().inset(25)
            make.bottom.equalToSuperview().offset(-150)
        }
        
        historyTableView.historyData = gameSettings.historyData
        
        historyTableView.reloadHistory()
        
        let backButton = BottleGameHandButton(title: "Назад", color: #colorLiteral(red: 0.9882352941, green: 0.431372549, blue: 0.2745098039, alpha: 1), hand: HandButtons.back, scale: 0.3, fontSize: 40)
        backButton.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 100)
        backButton.name = "backButton"
        addChild(backButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "backButton" {
    
            historyTableView.removeFromSuperview()
            
            let transition = SKTransition.crossFade(withDuration: 1.0)
            guard let backScene = backScene else { return }
            backScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(backScene, transition: transition)
        }
    }
}
