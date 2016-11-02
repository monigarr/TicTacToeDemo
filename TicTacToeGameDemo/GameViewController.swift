//
//  GameViewController.swift
//  TicTacToeGameDemo
//
//  Created by Monica Peters on 11/1/16.
//  Copyright © 2016 monigarr. All rights reserved.
//
//  Inspired by Keith Elliott's TicTacToe GameViewController
//      https://medium.com/swift-programming/build-tic-tac-toe-with-ai-using-swift
import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadGame()
    }
    
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func loadGame(){
        if let scene = GameScene(fileNamed:"GameScene") {
            
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            //Sprite Kit provides optimizations to improve rendering performance
            skView.ignoresSiblingOrder = true
            
            //Set scale mode to scale to fit window
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
        }
    }
}
