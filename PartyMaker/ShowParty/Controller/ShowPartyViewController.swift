//
//  ShowPartyViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 30.12.2020.
//

import UIKit

class ShowPartyViewController: UIViewController {
    
    let dateLabel = UILabel(text: "Дата")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK: - SwiftUI
import SwiftUI

struct ShowPartyViewControllerProvider: PreviewProvider {
    
    static var previews: some View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let showPartyViewController = ShowPartyViewController()
        
        func makeUIViewController(context: Context) -> ShowPartyViewController {
            return showPartyViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
