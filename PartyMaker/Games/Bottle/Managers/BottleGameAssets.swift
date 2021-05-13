//
//  BottleGameAssets.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 08.05.2021.
//

import SpriteKit

class BottleGameAssets {
    
    static let shared = BottleGameAssets()
    
    var isLoaded = false
    
    let playButtonAtlas = SKTextureAtlas(named: "playButton")
   
    func preloadAssets() {
        playButtonAtlas.preload { print("playButtonAtlas preloaded") }
    }
}


