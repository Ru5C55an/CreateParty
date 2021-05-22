//
//  BottleGameSceneManager.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 09.05.2021.
//

class BottleGameSceneManager {
    static let shared = BottleGameSceneManager()
    
    var gameScene: BottleGameScene?
    var pauseMenuScene: BottleGamePauseScene?
    var menuScene:  BottleGameMenuScene?
}
