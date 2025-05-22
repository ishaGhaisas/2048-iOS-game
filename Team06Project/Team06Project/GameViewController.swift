//  Nihal Shetty (ndshetty)
//  Isha Ghaisas (ighaisas)
//  App Name: Team06Project (2048Game)
//  GitHub Submission Date: 05/06/2025
//
//  GameViewController.swift
//  Team06Project
//
//  Created by Ghaisas, Isha Milind on 4/27/25.
//

import UIKit
import AVFoundation
import SpriteKit

class GameViewController: UIViewController {
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var tileView: GridView!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var bestScoreLabel: UILabel!
    
    var model: GameModel!
    var audioPlayer: AVAudioPlayer?
    var animationScene: SKScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleView.layer.borderColor = UIColor.black.cgColor
        titleView.layer.borderWidth = 2.0
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        let restartImage = UIImage(systemName: "arrow.trianglehead.2.clockwise.rotate.90.fill", withConfiguration: config)
        restartButton.setImage(restartImage, for: .normal)
        
        setupAnimationScene()

        NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: .themeChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gridSizeChanged), name: Notification.Name("GridSizeChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(scoreGainedAnimation(_:)), name: Notification.Name("ScoreGained"), object: nil)
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if model == nil {
            startNewGame()
        }
        
        tileView.grid = model.grid
        tileView.setNeedsDisplay()
        updateScore()
        updateTitleBackground()
    }
    
    @objc func themeChanged() {
        tileView.setNeedsDisplay()
        updateTitleBackground()
    }
    
    @objc func gridSizeChanged() {
        startNewGame()
    }
    
    func setupAnimationScene() {
        let skView = SKView(frame: tileView.bounds)
        skView.backgroundColor = .clear
        skView.allowsTransparency = true
        tileView.addSubview(skView)

        let scene = SKScene(size: skView.bounds.size)
        scene.backgroundColor = .clear
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)

        animationScene = scene
    }
    
    @objc func scoreGainedAnimation(_ notification: Notification) {
        guard let scoreGained = notification.object as? Int, scoreGained > 0 else { return }

        let labelNode = SKLabelNode(text: "+\(scoreGained)")
        labelNode.fontSize = 36
        labelNode.fontColor = UIColor.systemOrange
        labelNode.fontName = "Avenir-Heavy"
        labelNode.alpha = 1.0

        let gridFrame = tileView.frame
        labelNode.position = CGPoint(
            x: gridFrame.width / 2,
            y: gridFrame.height / 2
        )

        animationScene?.addChild(labelNode)

        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let moveUp = SKAction.moveBy(x: 0, y: 50, duration: 0.8)
        let fadeOut = SKAction.fadeOut(withDuration: 0.8)

        let group = SKAction.group([moveUp, fadeOut])
        let sequence = SKAction.sequence([scaleUp, group, SKAction.removeFromParent()])

        labelNode.run(sequence)
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            model.moveLeft()
        case .right:
            model.moveRight()
        case .up:
            model.moveUp()
        case .down:
            model.moveDown()
        default:
            return
        }
        
        playMoveSound() 
        
        tileView.grid = model.grid
        tileView.setNeedsDisplay()
        updateScore()
        
        if model.isGameOver() {
            showGameOverAlert()
        }
    }
    
    @IBAction func restartGame(_ sender: UIButton) {
        saveCurrentScore()
        NotificationCenter.default.post(name: .scoresUpdated, object: nil)
        startNewGame()
        
        tileView.grid = model.grid
        tileView.setNeedsDisplay()
        updateScore()
    }
    
    func startNewGame() {
        let gridSize = (UIApplication.shared.delegate as? AppDelegate)?.currentGridSize ?? 4
        model = GameModel(size: gridSize)
        model.spawnTile()
        model.spawnTile()
        tileView.grid = model.grid
    }
    
    func showGameOverAlert() {
        let alert = UIAlertController(title: "Game Over", message: "No more moves available!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
            self.restartGame(self.restartButton) 
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateScore() {
        scoreLabel.text = "\(model.score)"
        
        let decoder = PropertyListDecoder()
        let url = getScoresFileURL()
        
        if let data = try? Data(contentsOf: url),
           let decoded = try? decoder.decode([GameScore].self, from: data) {
            let best = decoded.map { $0.score }.max() ?? 0
            bestScoreLabel.text = "\(best)"
        } else {
            bestScoreLabel.text = "0"
        }
    }
    
    func updateTitleBackground() {
        let theme = ThemeManager.shared.currentTheme
        
        switch theme {
        case .green:
            titleView.backgroundColor = UIColor(red: 144/255, green: 235/255, blue: 148/255, alpha: 1)
        case .blue:
            titleView.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 255/255, alpha: 1)
        }
    }
    
    func saveCurrentScore() {
        guard model.score > 0 else { return }
        
        let newScore = GameScore(score: model.score, moves: model.moves, date: Date())
        let encoder = PropertyListEncoder()
        var scores = loadScores()
        scores.append(newScore)
        if let encoded = try? encoder.encode(scores) {
            let url = getScoresFileURL()
            try? encoded.write(to: url)
            print("scores \(url.path)")
        }
    }
    
    func loadScores() -> [GameScore] {
        let url = getScoresFileURL()
        if let data = try? Data(contentsOf: url) {
            let decoder = PropertyListDecoder()
            if let scores = try? decoder.decode([GameScore].self, from: data) {
                return scores
            }
        }
        return []
    }
    
    func getScoresFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent("scores.plist")
    }
    
    func playMoveSound() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, appDelegate.soundEnabled {
            if let soundURL = Bundle.main.url(forResource: "move", withExtension: "wav") {
                audioPlayer = try? AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            }
        }
    }
}

extension Notification.Name {
    static let scoresUpdated = Notification.Name("scoresUpdated")
}
