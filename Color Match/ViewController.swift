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
    
    var gamestate = 1 // 1 = pre-start, 2 = playing, 3 = gameover
    var score: Int = 0
    var timerCount = 60
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
    
    // Called each second as the timer ticks
    @objc func updateTimer(timer: Timer) -> Void {
        if timerCount > 9 && timerCount <= 60 {
            timerCount -= 1
            timerLabel.text = "0:" + String(timerCount)
        } else if timerCount > 0 && timerCount < 10 {
            timerCount -= 1
            timerLabel.text = "0:0" + String(timerCount)
        } else if timerCount == 0 {
            timerLabel.text = "0:00"
            gamestate = 3
            colorWord.text = "Time's Up!"
        }
    }
    
    // PLAY
    @IBOutlet var playButton: UIButton!
    @IBAction func playPressed(_ sender: Any) {
        if gamestate == 1 {
            gamestate += 1
            playButton.setTitle("", for: [])
            score = 0
            timerLabel.text = "1:00"
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            genRandomColor()
        }
    }
    
    func clickColorButton(button: UIButton, color: String) {
        resetColorButtons()
        chosenColor = color
        
        if gamestate == 2 {
            if chosenColor == correctColor {
                score += 1
                button.setTitle("✓", for: [])
            } else {
                if score > 0 { score -= 1 } // score shouldn't go below 0
                button.setTitle("X", for: [])
            }
            
            scoreLabel.text = "Score: \(score)"
            genRandomColor()
        }
    }
    
    // BUTTON CLICKING
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
        scoreLabel.text = "Score: 0"
        colorWord.text = ""
    }
}

