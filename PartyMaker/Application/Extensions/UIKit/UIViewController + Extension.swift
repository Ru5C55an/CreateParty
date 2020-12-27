//
//  UIViewController + Extension.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 26.12.2020.
//

import UIKit

extension UIViewController {
    
    func configure<T: SelfConfiguringCell, P: Hashable>(collectionView: UICollectionView, cellType: T.Type, with value: P, for indexPath: IndexPath) -> T {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T else { fatalError("Unable to dequeue \(cellType)")}
        
        cell.configure(with: value)
        
        return cell
    }
}
