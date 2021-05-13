//
//  BottleGameVC.swift
//  PartyMaker
//
//  Created by Ruslan Sadykov on 30/04/2021.
//  Copyright © 2021 Ruslan Sadykov. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class BottleGameVC: UIViewController {
    
    let closeButton = UIImageView(image: UIImage(systemName: "xmark"))
    let resetButton = UIButton(title: "Перезагрузить сцену".uppercased())
    
    var gameView = SKView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        setupScene()
        setupViews()
        addTargets()
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    private func setupScene() {
        view = gameView
        if let view = self.view as! SKView? {
            let scene = BottleGameMenuScene(size: self.view.bounds.size)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            scene.size = self.view.bounds.size
            // Present the scene
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    private func setupViews() {
        view.addSubview(closeButton)
        view.addSubview(resetButton)
        
        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.size.equalTo(30)
        }
        
        resetButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.centerX.equalToSuperview()
        }
    }
    
    private func addTargets() {
        closeButton.addTap {
            self.navigationController?.popViewController(animated: true)
        }
        
        resetButton.addTarget(self, action: #selector(resetScene), for: .touchUpInside)
    }
    
    @objc private func resetScene() {
        dismiss(animated: true, completion: nil)
        view = SKView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        setupScene()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
