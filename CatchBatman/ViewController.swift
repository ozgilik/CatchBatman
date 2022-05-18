//
//  ViewController.swift
//  CatchBatman
//
//  Created by Emrah Ozgilik on 17.05.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var gameTimer: UILabel!
    @IBOutlet weak var gameScore: UILabel!
    @IBOutlet weak var gameHighScore: UILabel!
    
    var gameBox = UIImageView()
    var gameScoreCount = 0
    var gameTimerCount = 20
    var gameTime = Timer()
    var gameBoxTime = Timer()
    
    var gameBoxX = [21,146,249]
    var gameBoxY = [249,373,497]
    let highScore = UserDefaults.standard.object(forKey: "score")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let newScore = highScore as? String {
            gameHighScore.text = "High Score : \(newScore)"
        }
        timerStart()
    }
    
    func timerStart(){
        gameTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(gameTimeFunc), userInfo: nil, repeats: true)
        gameBoxTime = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(gameBoxCreator), userInfo: nil, repeats: true)
    }
    
    @objc func gameBoxCreator(){
        gameBox.image = UIImage(named: "batman")
        gameBox.frame = CGRect(x: gameBoxX[Int.random(in: 0..<3)], y: gameBoxY[Int.random(in: 0..<3)], width: 122, height: 122)
        gameBox.isUserInteractionEnabled = true
        let gameBoxClick = UITapGestureRecognizer(target: self, action: #selector(gameScoreUp))
        gameBox.addGestureRecognizer(gameBoxClick)
        view.addSubview(gameBox)
    }
    
    @objc func gameScoreUp(){
        gameBoxCreator()
        gameScoreCount += 1
        gameScore.text = "Score : \(gameScoreCount)"
    }
    
    @objc func gameTimeFunc(){
        gameTimer.text = String(gameTimerCount)
        gameTimerCount -= 1
        
        if(gameTimerCount < 0){
            highScoreUpdate()
            gameTime.invalidate()
            gameBoxTime.invalidate()
            makeAlert(titleInput: "Time's Up!", messageInput: "Do you want to play again!")
        }
    }
    
    func gameRestart(alert: UIAlertAction!){
        gameScoreCount = 0
        gameScore.text = "Score : 0"
        gameTimerCount = 20
        gameTimer.text = String(10)
        timerStart()
    }
    
    func highScoreUpdate(){
        if let newScoreEnd = highScore as? String {
            if Int(newScoreEnd)! < gameScoreCount{
                UserDefaults.standard.set(String(gameScoreCount), forKey: "score")
                gameHighScore.text = "High Score : \(gameScoreCount)"
            }
        }
    }
    
    func makeAlert(titleInput: String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Restart", style: UIAlertAction.Style.default, handler: gameRestart)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}

