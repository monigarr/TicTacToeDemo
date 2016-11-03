//
//  GameStates.swift
//  TicTacToeGameDemo
//
//  Created by Monica Peters on 11/1/16.
//  Copyright © 2016 monigarr. All rights reserved.
//

//  Inspired by Keith Elliott's GameStates for TicTacToe
//      https://medium.com/swift-programming/build-tic-tac-toe-with-ai-using-swift

import Foundation
import GameplayKit
import SpriteKit

class StartGameState: GKState{
    var scene: GameScene?
    var winnerLabel: SKNode!
    
    var clearNode: SKNode!
    var boardNode: SKNode!
    
    init(scene: GameScene){
        self.scene = scene
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == ActiveGameState.self
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        clearGame()
        self.stateMachine?.enter(ActiveGameState.self)
    }
    
    func clearGame(){
        let top_left: BoardCell  = BoardCell(value: .none, node: "//*top_left")
        let top_middle: BoardCell = BoardCell(value: .none, node: "//*top_middle")
        let top_right: BoardCell = BoardCell(value: .none, node: "//*top_right")
        let middle_left: BoardCell = BoardCell(value: .none, node: "//*middle_left")
        let center: BoardCell = BoardCell(value: .none, node: "//*center")
        let middle_right: BoardCell = BoardCell(value: .none, node: "//*middle_right")
        let bottom_left: BoardCell = BoardCell(value: .none, node: "//*bottom_left")
        let bottom_middle: BoardCell = BoardCell(value: .none, node: "//*bottom_middle")
        let bottom_right: BoardCell = BoardCell(value: .none, node: "//*bottom_right")
        
        boardNode = self.scene?.childNode(withName: "//Grid") as? SKSpriteNode
        
        winnerLabel = self.scene?.childNode(withName: "winnerLabel")
        winnerLabel.isHidden = true
        
        clearNode = self.scene?.childNode(withName: "clear")
        clearNode.isHidden = true

        let board = [top_left, top_middle, top_right, middle_left, center, middle_right, bottom_left, bottom_middle, bottom_right]
        
        self.scene?.gameBoard = Board(gameboard: board)
        
        self.scene?.enumerateChildNodes(withName: "//grid*") { (node, stop) in
            if let node = node as? SKSpriteNode{
                node.removeAllChildren()
            }
        }
    }
}

class EndGameState: GKState{
    var scene: GameScene?
    
    init(scene: GameScene){
        self.scene = scene
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == StartGameState.self
    }
    
    override func didEnter(from previousState: GKState?) {
        updateGameState()
    }
    
    func updateGameState(){
        let clearNode = self.scene?.childNode(withName: "clear")
        clearNode?.isHidden = false
    }

}

class ActiveGameState: GKState{
    var scene: GameScene?
    var waitingOnPlayer: Bool
    
    init(scene: GameScene){
        self.scene = scene
        waitingOnPlayer = false
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == EndGameState.self
    }
    
    override func didEnter(from previousState: GKState?) {
        waitingOnPlayer = false
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        assert(scene != nil, "scene cant be nil")
        assert(scene?.gameBoard != nil, "gameboard cant be nil")
        
        if !waitingOnPlayer{
            waitingOnPlayer = true
            updateGameState()
        }
    }
    
    // Bonus Animation / Transitions
    //  fade in / fade out or other animations to gameplay or view transitions
    func bonusAnimation(){
        
    }

    // Bonus Game State
    //  persist & resume game state during app and/or view lifecycle events
    // to allow gameplay to resume properly
    func updateGameState(){
        assert(scene != nil, "scene cant be nil")
        assert(scene?.gameBoard != nil, "gameboard cant be nil")
        
        let (state, winner) = self.scene!.gameBoard!.determineIfWinner()
        if state == .winner{
            let winnerLabel = self.scene?.childNode(withName: "winnerLabel")
            winnerLabel?.isHidden = true
            let winnerPlayer = self.scene!.gameBoard!.isPlayerOne(winner!) ? "1" : "2"
            if let winnerLabel = winnerLabel as? SKLabelNode,
                let player1_score = self.scene?.childNode(withName: "//player1_score") as? SKLabelNode,
                let player2_score = self.scene?.childNode(withName: "//player2_score") as? SKLabelNode{
                winnerLabel.text = "Player \(winnerPlayer) Won. Clear Game"
                winnerLabel.isHidden = false
                if winnerPlayer == "1"{
                    winnerLabel.text = "You Won! Clear Game"
                    player1_score.text = "\(Int(player1_score.text!)! + 1)"
                    //let this human brag
                    //let twitterNode = self.scene?.childNode(withName: "twitterLabel")
                    //twitterNode?.isHidden = false
                    //humanMustBrag()
                    
                }
                else{
                    player2_score.text = "\(Int(player2_score.text!)! + 1)"
                }
                
                self.stateMachine?.enter(EndGameState.self)
                waitingOnPlayer = false
            }
        }
        else if state == .draw{
            let winnerLabel = self.scene?.childNode(withName: "winnerLabel")
            winnerLabel?.isHidden = true
            
            
            if let winnerLabel = winnerLabel as? SKLabelNode{
                winnerLabel.text = "Game Tied"
                winnerLabel.isHidden = false
            }
            self.stateMachine?.enter(EndGameState.self)
            waitingOnPlayer = false
        }
            
        else if self.scene!.gameBoard!.isPlayerTwoTurn(){
            //game logic moves
            self.scene?.isUserInteractionEnabled = false
            
            assert(scene != nil, "scene cant be nil")
            assert(scene?.gameBoard != nil, "gameboard cant be nil")
            DispatchQueue.global(qos: .background).async{
                self.scene!.gameLogic.gameModel = self.scene!.gameBoard!
                let move = self.scene!.gameLogic.bestMoveForActivePlayer() as? Move
                
                assert(move != nil, "gamelogic should find a move")
                
                let strategistTime = CFAbsoluteTimeGetCurrent()
                let delta = CFAbsoluteTimeGetCurrent() - strategistTime
                let  gameLogicTimeCeiling: TimeInterval = 1.0
                
                let delay = min(gameLogicTimeCeiling - delta, gameLogicTimeCeiling)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay) * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
                    
                    guard let cellNode: SKSpriteNode = self.scene?.childNode(withName: self.scene!.gameBoard!.getElementAtBoardLocation(move!.cell).node) as? SKSpriteNode else{
                        return
                    }
                    
                    //default ai mark
                    var circle = SKSpriteNode(imageNamed: "o-mark")
                    
                    //if human is x, ai is o
                    if (self.scene?.firstPlayerChoice == "x") {
                        circle = SKSpriteNode(imageNamed: "o-mark")
                    } else {
                        //else human is o, ai is x
                        circle = SKSpriteNode(imageNamed: "x-mark")
                    }
                    
                    
                    circle.size = CGSize(width: 75, height: 75)
                    cellNode.addChild(circle)
                    self.scene!.gameBoard!.addPlayerValueAtBoardLocation(move!.cell, value: .o)
                    self.scene!.gameBoard!.togglePlayer()
                    self.waitingOnPlayer = false
                    self.scene?.isUserInteractionEnabled = true
                }
            }
        }
        else{
            self.waitingOnPlayer = false
            self.scene?.isUserInteractionEnabled = true
        }
    }
}
