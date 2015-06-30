//
//  ViewController.swift
//  Calculator
//
//  Created by Austin Rude on 6/21/15.
//  Copyright © 2015 Austin Rude. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsUnTheMiddleOfTypingANumber = false
    var brain = CalculatorBrain()

    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        
        set {
            display.text = "\(newValue)"
            userIsUnTheMiddleOfTypingANumber = false
        }
    }

    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsUnTheMiddleOfTypingANumber {
            switch digit {
            case ".":
                if display.text!.rangeOfString(".") == nil {
                  display.text = display.text! + digit
                }
            case "π":
                  enter()
                  display.text = "\(M_PI)"
                  enter()
            default:
              display.text = display.text! + digit
            }
        }
        else {
            if digit == "π" {
                  display.text = "\(M_PI)"
                  enter()
            }
            else {
            display.text = digit
            userIsUnTheMiddleOfTypingANumber = true
            }
        }
        
        //print("digit = \(digit)")
        history.text = brain.history
        
    }
    @IBAction func operate(sender: UIButton) {
        if userIsUnTheMiddleOfTypingANumber {
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
             displayValue = result
            }
            else {
                // todo: displayValue should accept Optional and display NaN to user
                displayValue = 0
            }
        }
        history.text = brain.history
    }
    
    @IBAction func clear(){
        brain.clear()
        history.text = ""
        displayValue = 0.0
        
    }
    @IBAction func enter() {
        userIsUnTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        }
        else {
            // todo: displayValue should accept Optional and display NaN to user
            displayValue = 0
        }
        
    }
    
       
}

