//
//  BottleGameSettings.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 14.05.2021.
//

import Foundation

class BottleGameSettings: NSObject {
    
    private let ud = UserDefaults.standard
    
    var isMusic = true
    var isSound = true
    var historyData = [HistoryData]()
    var gameMode = 1
    
    private let musicKey = "music"
    private let soundKey = "sound"
    private let historyKey = "bottleHistory"
    private let gameModeKey = "bottleGameMode"
    
    override init() {
        super.init()
        loadGameSettings()
        loadHistory()
    }
    
    func saveGameMode(_ index: Int) {
        gameMode = index
        ud.set(gameMode, forKey: gameModeKey)
        ud.synchronize()
    }
    
    func loadGameMode() {
        guard ud.value(forKey: gameModeKey) != nil else { return }
        gameMode = ud.integer(forKey: gameModeKey)
    }
    
    func saveHistory(firstPlayer: String?, secondPlayer: String, action: String) {
        historyData.append(HistoryData(date: Date(), firstPlayer: firstPlayer, secondPlayer: secondPlayer, action: action))
        ud.set(historyData, forKey: historyKey)
        ud.synchronize()
    }
    
    func loadHistory() {
        guard ud.value(forKey: historyKey) != nil else { return }
        historyData = ud.array(forKey: historyKey) as! [HistoryData]
    }
    
    func saveGameSettings() {
        ud.setValue(isMusic, forKey: musicKey)
        ud.setValue(isSound, forKey: soundKey)
    }
    
    func loadGameSettings() {
        guard ud.value(forKey: musicKey) != nil && ud.value(forKey: soundKey) != nil else { return }
        isMusic = ud.bool(forKey: musicKey)
        isSound = ud.bool(forKey: soundKey)
    }
}
