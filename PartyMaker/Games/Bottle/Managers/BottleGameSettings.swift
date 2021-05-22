//
//  BottleGameSettings.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 14.05.2021.
//

import Foundation

enum BottleGameModes: Int, Codable {
    case kiss
    case drink
    case desire
    case secret
}

class BottleGameSettings: NSObject {
    
    private let ud = UserDefaults.standard
    
    var isMusic = true
    var isSound = true
    var historyData = [HistoryData]()
    var gameMode: BottleGameModes = .kiss
    var playersData = [PlayerData]()
    
    var settingsChanged = false
    
    private let musicKey = "music"
    private let soundKey = "sound"
    private let historyKey = "bottleHistory"
    private let gameModeKey = "bottleGameMode"
    private let playersKey = "players"
    
    override init() {
        super.init()
        loadGameSettings()
    }
    
    func savePlayersData(players: [PlayerData]) {
        playersData = players
        ud.set(try? PropertyListEncoder().encode(playersData), forKey: playersKey)
        ud.synchronize()
    }
    
    func loadPlayersData() {
        if let data = ud.value(forKey: playersKey) as? Data {
            guard let playersData = try? PropertyListDecoder().decode(Array<PlayerData>.self, from: data) else { return }
            self.playersData = playersData
        }
    }
    
    func saveGameMode(_ mode: BottleGameModes) {
        gameMode = mode
        ud.set(gameMode.rawValue, forKey: gameModeKey)
        ud.synchronize()
    }
    
    func loadGameMode() {
        guard ud.value(forKey: gameModeKey) != nil else { return }
        let rawValue = ud.integer(forKey: gameModeKey)
        gameMode = BottleGameModes(rawValue: rawValue)!
    }
    
    func saveHistory(firstPlayer: String?, secondPlayer: String, mode: BottleGameModes) {
        loadHistory()
        historyData.append(HistoryData(date: Date(), firstPlayer: firstPlayer, secondPlayer: secondPlayer, mode: mode))
        ud.set(try? PropertyListEncoder().encode(historyData), forKey: historyKey)
        ud.synchronize()
    }
    
    func loadHistory() {
        if let data = ud.value(forKey: historyKey) as? Data {
            guard let historyData = try? PropertyListDecoder().decode(Array<HistoryData>.self, from: data) else { return }
            self.historyData = historyData
        }
    }
    
    func saveGameSettings() {
        ud.setValue(isMusic, forKey: musicKey)
        ud.setValue(isSound, forKey: soundKey)
    }
    
    func loadGameSettings() {
        guard ud.value(forKey: musicKey) != nil && ud.value(forKey: soundKey) != nil else { return }
        isMusic = ud.bool(forKey: musicKey)
        isSound = ud.bool(forKey: soundKey)
       
        loadGameMode()
        loadPlayersData()
    }
}
