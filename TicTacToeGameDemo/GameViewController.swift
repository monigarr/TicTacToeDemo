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
import GoogleMobileAds

class GameViewController: UIViewController {

    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAds()
    }
    
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        loadGame()
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    // Bonus Integrate Ads
    // Firebase Integration because
    // iAd App Network is no longer available as of July 1 2016
    func showAds(){
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        
        bannerView.load(GADRequest())
    }
    
    func loadGame(){
        if let scene = GameScene(fileNamed:"GameScene") {
            scene.alpha = 1
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
  
/*running out of time, maybe I will add this new game scene in future
func loadPlayerChoice(){
    if let scene = PlayerChoiceScene(fileNamed:"PlayerChoiceScene") {
        scene.alpha = 1
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        
        //Sprite Kit provides optimizations to improve rendering performance
        skView.ignoresSiblingOrder = true
        
        //Set scale mode to scale to fit window
        scene.scaleMode = .aspectFill
        
        scene.alpha = 100
        skView.presentScene(scene)
    }
}*/
    
}
