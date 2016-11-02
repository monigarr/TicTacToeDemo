//
//  StartGameViewController.swift
//  TicTacToeGameDemo
//
//  Created by Monica Peters on 11/1/16.
//  Copyright © 2016 monigarr. All rights reserved.
//

import UIKit

class StartGameViewController: UIViewController {
    
    @IBOutlet weak var buttonX: UIButton!
    @IBOutlet weak var buttonO: UIButton!
    
    //pass this to GameScene
    var firstPlayerChoice: String!
    
    var currentGame: GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        currentGame = scene as! GameScene
        currentGame.viewController = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func firstPlayer(sender: UIButton){
        switch sender{
        case buttonX:
            firstPlayerChoice = "x"
            currentGame.buttonXTapped()
            //currentGame.firstPlayer(buttonXTapped)
        case buttonO:
            firstPlayerChoice = "o"
            currentGame.buttonOTapped()
            //currentGame.firstPlayer(buttonX)
        default:
            firstPlayerChoice = "x"
            currentGame.buttonXTapped()
        }
    }
    
    
    
}
