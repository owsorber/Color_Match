//
//  ViewController.swift
//  Color Match
//
//  Created by Owen Sorber on 7/14/19.
//  Copyright © 2019 Owen Sorber. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let COLORS = ["GREEN", "RED", "BLUE", "YELLOW"]
    
    var chosenColor: String = ""
    var correctColor: String = ""
    
    var playing: Bool = false
    var highscore: Int = -1
    var score: Int = 0
    var timerCount: Int = 60
    var timer: Timer?
    
    
    // Color Buttons
    @IBOutlet var green: UIButton!
    @IBOutlet var red: UIButton!
    @IBOutlet var blue: UIButton!
    @IBOutlet var yellow: UIButton!
    
    // Labels
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var colorWord: UILabel!
    @IBOutlet var highscoreLabel: UILabel!
    @IBOutlet var hsMessage: UILabel!
    
    
    /* HELPER FUNCTIONS */
    
    // Generates random color and updates text displayed
    func genRandomColor() {
        let randVal = Int.random(in: 0 ..< COLORS.count)
        correctColor = COLORS[randVal]
        colorWord.text = correctColor
    }
    
    // Color buttons display no text
    func resetColorButtons() {
        green.setTitle("", for: [])
        red.setTitle("", for: [])
        blue.setTitle("", for: [])
        yellow.setTitle("", for: [])
    }
    
    // Score label updating (called when color button pressed for score and when game over for high score)
    func updateScoreLabel() {
        scoreLabel.text = "Score: \(score)"
    }
    func updateHighscoreLabel() {
        highscoreLabel.text = "High Score: \(highscore)"
    }
    
    // Called when time runs out
    func gameover() {
        playing = false
        resetColorButtons()
        colorWord.text = "Time's Up!"
        timerLabel.text = ""
        playButton.setTitle("Play Again", for: [])
        
        // check for high score
        if score > highscore {
            highscore = score
            hsMessage.text = "New High Score!"
            UserDefaults.standard.set(highscore, forKey: "highScore") // enable permanent data storage
            updateHighscoreLabel()
        }
    }
    
    // Called each second as the timer ticks
    @objc func updateTimer(timer: Timer) -> Void {
        timerCount -= 1 // at every tick, there is 1 less second left
        if timerCount >= 10 {
            timerLabel.text = "0:" + String(timerCount)
        } else if timerCount > 0 {
            timerLabel.text = "0:0" + String(timerCount)
        } else if timerCount == 0 {
            timerLabel.text = "0:00"
            gameover()
        }
    }
    
    // PLAY
    @IBOutlet var playButton: UIButton!
    @IBAction func playPressed(_ sender: Any) {
        if !playing {
            playing = true
            playButton.setTitle("", for: [])
            
            score = 0
            updateScoreLabel()
            hsMessage.text = ""
            
            timerCount = 60
            timerLabel.text = "1:00"
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            genRandomColor()
        }
    }
    
    // General function for color button pressing
    func clickColorButton(button: UIButton, color: String) {
        if playing { // only apply when in game
            resetColorButtons()
            chosenColor = color
            
            if chosenColor == correctColor {
                score += 1
                button.setTitle("✓", for: [])
            } else {
                if score > 0 { score -= 1 } // score shouldn't go below 0
                button.setTitle("X", for: [])
            }
            
            updateScoreLabel()
            genRandomColor() // generate new color
        }
    }
    
    // BUTTON PRESSING IBActions
    @IBAction func greenPressed(_ sender: Any) {
        clickColorButton(button: green, color: "GREEN")
    }
    @IBAction func redPressed(_ sender: Any) {
        clickColorButton(button: red, color: "RED")
    }
    @IBAction func yellowPressed(_ sender: Any) {
        clickColorButton(button: yellow, color: "YELLOW")
    }
    @IBAction func bluePressed(_ sender: Any) {
        clickColorButton(button: blue, color: "BLUE")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        resetColorButtons()
        timerLabel.text = ""
        scoreLabel.text = ""
        hsMessage.text = ""
        colorWord.text = ""
        
        if highscore == -1 {
            highscoreLabel.text = ""
        } else {
            updateHighscoreLabel()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // if there's already a value stored for key "highScore", store it in highscore
        if let hs: Int = UserDefaults.standard.object(forKey: "highScore") as? Int {
            highscore = hs
            updateHighscoreLabel()
        }
    }
}

