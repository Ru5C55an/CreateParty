//
//  BottleGamePlayersScene.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 15.05.2021.
//

import SpriteKit
import UIKit

class BottleGamePlayersScene: BottleGameParentScene {
     
    let countPlayersPicker = UIPickerView()
    
    var countVariants = [Int]()
    
    var isCountPlayersPicked = false
    var pickedCountPlayers = 0
    
    let nameTextField = BubbleTextField(placeholder: "Имя игрока")
    
    var selectedHeadNodes = [BottleGameHead]()
    var selectedHeadNode: BottleGameHead?
    var selectedPlayerName = ""
    
    var playersArray = [PlayerData]()
    
    var unnamedPlayerCount = 0
    
    var currentPlayerNumber = 0
    
    override func didMove(to view: SKView) {
        
        setHeader(withTitle: "Кол-во игроков")
       
        for i in 2..<21 {
            countVariants.append(i)
        }
        
        countPlayersPicker.dataSource = self
        countPlayersPicker.delegate = self
        
        self.scene?.view?.addSubview(countPlayersPicker)
        
        countPlayersPicker.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.bottom.equalToSuperview().offset(-130)
            make.left.right.equalToSuperview().inset(40)
        }
        
        let nextButton = BottleGameHandButton(title: "Далее", color: #colorLiteral(red: 0.9882352941, green: 0.431372549, blue: 0.2745098039, alpha: 1), hand: HandButtons.yes, scale: 0.3, fontSize: 30)
        nextButton.position = CGPoint(x: self.frame.midX + 100, y: self.frame.minY + 100)
        nextButton.name = "nextButton"
        addChild(nextButton)
        
        let backButton = BottleGameHandButton(title: "Назад", color: #colorLiteral(red: 0.9882352941, green: 0.431372549, blue: 0.2745098039, alpha: 1), hand: HandButtons.back, scale: 0.3, fontSize: 30)
        backButton.position = CGPoint(x: self.frame.midX - 100, y: self.frame.minY + 100)
    
        backButton.name = "backButton"
        addChild(backButton)
    }
    
    private func closeScene() {
        countPlayersPicker.removeFromSuperview()
        nameTextField.removeFromSuperview()
        
        let transition = SKTransition.crossFade(withDuration: 1.0)
        guard let backScene = backScene else { return }
        backScene.scaleMode = .aspectFill
        self.scene!.view?.presentScene(backScene, transition: transition)
    }
    
    private func setHeaderPlayerNumber(_ number: Int) {
        headerLabel.text = "Игрок \(number)"
    }
    
    private func setDefaultHeadScale() {
        for node in children {
            if let nodeName = node.name, nodeName.contains("head") {
                node.setScale(0.5)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "backButton" {
            
            if !selectedHeadNodes.isEmpty {
                
                currentPlayerNumber -= 1
                
                if currentPlayerNumber == 0 {
                    closeScene()
                } else {
                    addChild(selectedHeadNodes[currentPlayerNumber - 1])
                    setDefaultHeadScale()
                    selectedHeadNodes.removeLast()
                    playersArray.removeLast()
                    setHeaderPlayerNumber(currentPlayerNumber)
                }
                
            } else {
                closeScene()
            }
            
        } else if node.name == "nextButton" {
            
            if isCountPlayersPicked {
                
                if let selectedHeadNode = selectedHeadNode {
                    
                    selectedHeadNodes.append(selectedHeadNode)
                    
                    currentPlayerNumber += 1
                    setHeaderPlayerNumber(currentPlayerNumber)
                    
                    selectedHeadNode.removeFromParent()
                    
                    if let name = nameTextField.text, name.isEmpty {
                        unnamedPlayerCount += 1
                        selectedPlayerName = "player\(unnamedPlayerCount)"
                    } else {
                        selectedPlayerName = nameTextField.text!
                    }
        
                    nameTextField.text?.removeAll()
         
                    let player = PlayerData(playerName: selectedPlayerName, imageName: selectedHeadNode.name!)
                    playersArray.append(player)
                    
                    self.selectedHeadNode = nil
                    
                    if currentPlayerNumber > pickedCountPlayers {
                        showAlert(withTitle: "Успешно", message: "Игроки выбраны")
                        gameSettings.savePlayersData(players: playersArray)
                        gameSettings.settingsChanged = true
                        closeScene()
                    }
                    
                } else {
                    showAlert(withTitle: "Выберите изображение профиля", message: "")
                }
            
            } else {
                isCountPlayersPicked = true
                currentPlayerNumber += 1
                setHeaderPlayerNumber(currentPlayerNumber)
                
                countPlayersPicker.removeFromSuperview()
                
                self.scene?.view?.addSubview(nameTextField)
                nameTextField.snp.makeConstraints { make in
                    make.bottom.equalToSuperview().offset(-150)
                    make.height.equalTo(40)
                    make.left.right.equalToSuperview().inset(40)
                }
                
                let space = screenSize.width / 5
                var xPoint: CGFloat = 0
                var yPoint: CGFloat = screenSize.height - 200
                
                for i in 1...20 {
                    
                    xPoint += space
                    
                    var isNeedChangeXAfter = false
                    
                    if i == 4 {
                        isNeedChangeXAfter = true
                    } else {
                        if i % 4 == 0 {
                            xPoint = space
                        }
                    }
                    
                    let point = CGPoint(x: xPoint, y: yPoint)
                    
                    if i % 4 == 0 {
                        yPoint -= space
                        
                        if isNeedChangeXAfter {
                            xPoint = space
                        }
                    }
             
                    let head = BottleGameHead.populateSprite(at: point, id: i, scale: 0.5)
                    
                    addChild(head)
                }
            }
            
        } else if let nodeName = node.name, nodeName.contains("head") {
            
            setDefaultHeadScale()
            
            selectedHeadNode = node as! BottleGameHead
            node.setScale(0.2)
        }
    }
}

extension BottleGamePlayersScene: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countVariants.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(countVariants[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedCountPlayers = countVariants[row]
    }
}
