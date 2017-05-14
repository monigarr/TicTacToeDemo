
# TicTacToeDemo
iOS Swift experiments

# SetUp #
- command line:  git clone https://github.com/monigarr/TicTacToeDemo
- command line:  cd  /TicTacToeDemo directory on your local machine
- command line:  pod install
- Open TicTacToeGameDemo.xcworkspace in XCode  (NOT .xcodeproj)
- DO NOT open .xcodeproj in XCode.  Open .xcworkspace with XCode! We are using CocoaPods.

# Game Play Features #
- Player chooses either X or O for their game mark
- If Player does not choose, they will be X by default
- Player plays against simple GameAILogic that looks 1 to 8 moves ahead. 

# SpriteKit #
- render images, game run loop and frames per second

# GameplayKit #
- ai opponent

# GameViewController #
- GameViewController.swift
- loads the GameScene, Admob Banner

# GameScene #
- GameScene.swift
- SKScene sets up SpriteKit and GameplayKit 
- sets up our game SKSpriteNodes, SKNodes, Labels

# GameAILogic #
- GameAILogic.swift
- Behind the scenes game logic for player 1 (human) and player 1 (ai opponent)
- GKGameModel objects

# GameStates #
- GameStates.swift
- Tracks winner and loser
- Tracks end game and active game

# Integrate Ads #
- GameViewController.swift
- Firebase integration with AdMob shows tiny advertisement on bottom center of screen
- https://firebase.google.com/docs/admob/ios/quick-start

# Persist Game State #
- GameStates.swift

# Game Requirements #
- Use vendor preferred dev environment (Swift / XCode)
- Use native UI Controls
- App must compile with most modern sdk and modern devices
- backwards compatibility is not required.
- Must display properly in portrait orientation.
- Landscape must be disabled or function properly.
- Load & Use X O images provided
- Correct functionality more important than aesthetics.
- Cleaner & more readable the code is, the better.

# Inspiration #
This project is inspired by Keith Elliott's Swift Programming Tutorial: 
https://medium.com/swift-programming/build-tic-tac-toe-with-ai-using-swift-25c5cd3085c9#.7hpiwicnk
