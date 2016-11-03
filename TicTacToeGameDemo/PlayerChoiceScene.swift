//
//  PlayerChoiceScene.swift
//  TicTacToeGameDemo
//
//  Created by Monica Peters on 11/2/16.
//  Copyright © 2016 monigarr. All rights reserved.
//
//  TODO: complete new game scene:
//      player chooses x or o on this PlayerChoiceScene.swift
//          player choice sent to GameScene.swift with loadGame()

import SpriteKit
import GameplayKit

class PlayerChoiceScene: SKScene {

    //defaults
    var firstPlayerChoice: String! = "x"
    var secondPlayerChoice: String! = "o"
    var cross = SKSpriteNode(imageNamed: "x-mark")
    var circle = SKSpriteNode(imageNamed: "o-mark")
    
    func buttonXTapped(){
        loadGame()
    }
    
    func buttonOTapped(){
        loadGame()
    }
    
    
    func loadGame(){
        /*if let scene = GameScene(fileNamed:"GameScene") {
           //send player choices to GameScene
        }*/
    }

}
