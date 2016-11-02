//
//  GameScene.swift
//  TicTacToeGameDemo
//
//  Created by Monica Peters on 11/1/16.
//  Copyright © 2016 monigarr. All rights reserved.
//
//  Human player is always Player 1
//  Machine is always Player 2
//  Buttons X START & O START change Human Player 1 mark only
//
//  Inspired by Keith Elliott's AIStrategy for TicTacToe
//      https://medium.com/swift-programming/build-tic-tac-toe-with-ai-using-swift

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    weak var viewController: GameViewController!
    
    var gameBoard: Board!
    var stateMachine: GKStateMachine!
    var gameLogic: GKMinmaxStrategist!
    var node: SKSpriteNode!
    var firstPlayerChoice: String!
    var secondPlayerChoice: String!
    var player1Label: SKNode!
    var player2Label: SKNode!
    var twitterLabel: SKNode!
    
    //defaults
    var cross = SKSpriteNode(imageNamed: "x-mark")
    var circle = SKSpriteNode(imageNamed: "o-mark")

    func buttonXTapped(){
        firstPlayerX()
        secondPlayerO()
    }
    
    func buttonOTapped(){
        firstPlayerO()
        secondPlayerX()
    }
    
    //x or o?
    func xMark(){
        cross = SKSpriteNode(imageNamed: "x-mark")
        cross.size = CGSize(width: 75, height: 75)
        node = cross
    }
    
    //x or o?
    func oMark(){
        circle = SKSpriteNode(imageNamed: "o-mark")
        circle.size = CGSize(width: 75, height: 75)
        node = circle
    }
    
    //human x or o?
    func firstPlayerX(){
        oMark()
        //default labels
    }
    
    //human x or o?
    func firstPlayerO(){
        xMark()
    }
    
    //ai x or o?
    func secondPlayerX(){
        oMark()
    }
    
    //ai x or o?
    func secondPlayerO(){
        xMark()
    }
    
    func playerLabels(){
        //only change default labels when human is O
        //default labels for human as x
        let player1Label = self.scene?.childNode(withName: "player1Label")
        let player2Label = self.scene?.childNode(withName: "player2Label")
    
        if let player1Label = player1Label as? SKLabelNode{
            player1Label.text = "You are O"
        }
        
        if let player2Label = player2Label as? SKLabelNode{
            player2Label.text = "Bot is X"
        }
    }
    
    func defaultPlayerLabels(){
        let player1Label = self.scene?.childNode(withName: "player1Label")
        let player2Label = self.scene?.childNode(withName: "player2Label")
        
        if let player1Label = player1Label as? SKLabelNode{
            player1Label.text = "You are X"
        }
        
        if let player2Label = player2Label as? SKLabelNode{
            player2Label.text = "Bot is O"
        }
    }
    
    override func didMove(to view: SKView) {
        
        /* Setup your scene here */
        self.enumerateChildNodes(withName: "//Grid*") { (node, stop) in
            if let node = node as? SKSpriteNode{
                node.color = UIColor.clear
            }
        }
        
        let top_left: BoardCell  = BoardCell(value: .none, node: "//*top_left")
        let top_middle: BoardCell = BoardCell(value: .none, node: "//*top_middle")
        let top_right: BoardCell = BoardCell(value: .none, node: "//*top_right")
        let middle_left: BoardCell = BoardCell(value: .none, node: "//*middle_left")
        let center: BoardCell = BoardCell(value: .none, node: "//*center")
        let middle_right: BoardCell = BoardCell(value: .none, node: "//*middle_right")
        let bottom_left: BoardCell = BoardCell(value: .none, node: "//*bottom_left")
        let bottom_middle: BoardCell = BoardCell(value: .none, node: "//*bottom_middle")
        let bottom_right: BoardCell = BoardCell(value: .none, node: "//*bottom_right")
        
        let board = [top_left, top_middle, top_right, middle_left, center, middle_right, bottom_left, bottom_middle, bottom_right]
        
        gameBoard = Board(gameboard: board)
        
        //9 is most difficult game, 1 is easiest game
        gameLogic = GKMinmaxStrategist()
        gameLogic.maxLookAheadDepth = 1
        gameLogic.randomSource = GKARC4RandomSource()
        
        let beginGameState  = StartGameState(scene: self)
        let activeGameState = ActiveGameState(scene: self)
        let endGameState    = EndGameState(scene: self)
        
        stateMachine = GKStateMachine(states: [beginGameState, activeGameState, endGameState])
        stateMachine.enter(StartGameState.self)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let selectedNode = self.atPoint(location)
            
            if let name = selectedNode.name {
                if name == "X" || name == "x_label"{
                    firstPlayerChoice = "x"
                    secondPlayerChoice = "o"
                    defaultPlayerLabels()
                }
                if name == "O" || name == "o_label"{
                    firstPlayerChoice = "o"
                    secondPlayerChoice = "x"
                    //change default player labels
                    playerLabels()
                }
                
                if name == "clear" || name == "clear_label"{
                    self.stateMachine.enter(StartGameState.self)
                    return
                }
                
                if name == "twitter" || name == "twitter_label"{
                    //show tweet sheet
                    self.viewController.viewDidLoad()
                    return
                }

            }
            
            
            //Human is X
            if gameBoard.isPlayerOne() && firstPlayerChoice == "x"{
                firstPlayerX()
                secondPlayerO()
            } else {
                //human did not decide
                firstPlayerX()
                secondPlayerO()
            }
            
            //Human is O
            if gameBoard.isPlayerOne() && firstPlayerChoice == "o"{
                firstPlayerO()
                secondPlayerX()
            } else {
                //human did not decide
                firstPlayerX()
                secondPlayerO()
            }
            
            
            //3x3 add human marks on game board
            for i in 0...8{
                guard let cellNode: SKSpriteNode = self.childNode(withName: gameBoard.getElementAtBoardLocation(i).node) as? SKSpriteNode else{
                    return
                }
                if selectedNode.name == cellNode.name{
                    cellNode.addChild(node)
                    gameBoard.addPlayerValueAtBoardLocation(i, value: gameBoard.isPlayerOne() ? .x : .o)
                    gameBoard.togglePlayer()
                }
            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame rendered */
        self.stateMachine.update(deltaTime: currentTime)
    }
    
    
}
