//
//  Color + Extension.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 08.02.2021.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1),
                     alpha: .random(in: 0...1))
    }
    
    static var randomRainbowColor: UIColor {
       
        let randInt = Int.random(in: 1...7)
        switch randInt {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        case 5: return .cyan
        case 6: return .blue
        case 7: return .purple
        default:
            break
        }
        
        return .black
    }
}
