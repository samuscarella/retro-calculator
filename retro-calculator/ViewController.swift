//
//  ViewController.swift
//  retro-calculator
//
//  Created by Stephen Muscarella on 8/28/16.
//  Copyright © 2016 samuscarella. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    @IBOutlet weak var outputLbl: UILabel!
    
    var btnSound: AVAudioPlayer!
    
    var runningNum = ""
    var leftValNum = ""
    var rightValNum = ""
    var currentOperation: Operation = Operation.Empty
    var result = ""
    var equalsLastPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        let soundUrl = NSURL(fileURLWithPath: path!)
    
        do {
            try btnSound = AVAudioPlayer(contentsOfURL: soundUrl)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func numberPressed(btn: UIButton!) {
        btnSound.play()
        runningNum += "\(btn.tag)"
        outputLbl.text = runningNum
    }
    
    @IBAction func onDividePressed(sender: AnyObject) {
        equalsLastPressed = false
        processOperation(Operation.Divide)
    }

    @IBAction func onMultiplyPressed(sender: AnyObject) {
        equalsLastPressed = false
        processOperation(Operation.Multiply)
    }

    @IBAction func onSubtractPressed(sender: AnyObject) {
        equalsLastPressed = false
        processOperation(Operation.Subtract)
    }
    
    @IBAction func onAddPressed(sender: AnyObject) {
        equalsLastPressed = false
        processOperation(Operation.Add)
    }
    
    @IBAction func onEqualsPressed(sender: AnyObject) {
        processOperation(currentOperation)
        equalsLastPressed = true
    }
    
    func processOperation(op: Operation) {
        playSound()
        
        if currentOperation != Operation.Empty && leftValNum != "" {
            
            if equalsLastPressed {
                runningNum = rightValNum
            }
            
            if runningNum != "" {
                
                rightValNum = runningNum
                runningNum = ""
            
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValNum)! * Double(rightValNum)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValNum)! / Double(rightValNum)!)"
                } else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValNum)! - Double(rightValNum)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValNum)! + Double(rightValNum)!)"
                }
            
                leftValNum = result
                outputLbl.text = result
            }
            
            currentOperation = op
            
        } else {
            leftValNum = runningNum
            runningNum = ""
            currentOperation = op
        }
    }
    
    func playSound() {
        
        if btnSound.playing {
            btnSound.stop()
        }
        btnSound.play()
    }
    
}

