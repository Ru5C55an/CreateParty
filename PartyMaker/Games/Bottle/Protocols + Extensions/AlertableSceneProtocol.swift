//
//  AlertableSceneProtocol.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 16.05.2021.
//

import SpriteKit

protocol Alertable { }
extension Alertable where Self: SKScene {

    func showAlert(withTitle title: String, message: String) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in }
        alertController.addAction(okAction)

        view?.window?.rootViewController?.present(alertController, animated: true)
    }

    func showAlertWithSettings(withTitle title: String, message: String) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in }
        alertController.addAction(okAction)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in

            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        alertController.addAction(settingsAction)

        view?.window?.rootViewController?.present(alertController, animated: true)
    }
}
