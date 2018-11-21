//
//  ViewController.swift
//  Calculator
//
//  Created by Mbongeni NDLOVU on 2018/11/05.
//  Copyright © 2018 Mbongeni NDLOVU. All rights reserved.
//

import UIKit

enum modes {
    case not_set
    case addition
    case subtraction
    case multiplication
    case division
}

class ViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
   // var digitSequence: String?
    var labelString:String = "0"
    var currentMode:modes = .not_set
    var savedNum:Double = 0.0
    var lastButtonWasMode:Bool = false

    @IBOutlet weak var displayDigit: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getANumber(_ sender: UIButton) {
        
        let digit = sender.titleLabel!.text!
        if lastButtonWasMode {
            lastButtonWasMode = false
            labelString = "0"
        }
        
        if labelString.count > 6 {
            return
        }
        
        if digit == "," {
            labelString = labelString.appending(".")
        } else {
            labelString = labelString.appending(digit)
        }
        updateText()
    }

    @IBAction func operators(_ sender: UIButton) {
        let myOperator =  sender.titleLabel!.text!
        switch myOperator {
        case "+":
            changeModes(newMode: .addition)
        case "-":
            changeModes(newMode: .subtraction)
        case "x":
            changeModes(newMode: .multiplication)
        case "÷":
            changeModes(newMode: .division)
        default:
            changeModes(newMode: .not_set)
        }
    }

    @IBAction func equalTo(_ sender: Any) {
        guard let labelInt:Double = Double(labelString) else {
            return
        }
        if (currentMode == .not_set || lastButtonWasMode) {
            return
        }

        if currentMode == .addition {
            savedNum += labelInt
        } else if currentMode == .subtraction {
            savedNum -= labelInt
        } else if currentMode == .multiplication {
            savedNum *= labelInt
        } else if currentMode == .division {
            if !didDivide(labelInt) {
                return
            }
        }
        currentMode = .not_set
        labelString = "\(savedNum)"
        updateText()
        lastButtonWasMode = true
    }
    
    @IBAction func negPos(_ sender: Any) {
        if labelString.count > 0 {
            var d:Double = Double(labelString)!
            d =  d * -1
            labelString = String(d)
            updateText()
        }
    }
    
    @IBAction func percentage(_ sender: Any) {
        if labelString.count > 0 {
            var d:Double = Double(labelString)!
            d =  d / 100
            labelString = String(d)
            updateText()
        }
    }
    

    @IBAction func clear(_ sender: Any) {
        labelString = "0"
        currentMode = .not_set
        savedNum = 0
        lastButtonWasMode = false
        displayDigit.text = "0"
    }
    
    func updateText() {
        guard let labelInt:Double = Double(labelString) else {
            return
        }

        if currentMode == .not_set {
            savedNum = labelInt
        }
        let formatter:NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let num:NSNumber = NSNumber(value: labelInt)
        displayDigit.text = formatter.string(from: num)

    }
    
    func changeModes(newMode:modes) {
        if (savedNum == 0) {
            return
        }
        currentMode = newMode
        lastButtonWasMode =  true
    }
    
    func didDivide(_ number: Double) -> Bool{
        if number == 0.0 {
            labelString = "Error"
            currentMode = .not_set
            lastButtonWasMode = true
            displayDigit.text = labelString
            return false
        }
        savedNum /= number
        return true
    }
   
}

