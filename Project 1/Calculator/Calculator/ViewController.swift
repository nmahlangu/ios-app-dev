//
//  ViewController.swift
//  Calculator
//
//  Created by Nicholas Mahlangu on 5/26/15.
//  Copyright (c) 2015 Nicholas Mahlangu. All rights reserved.
//

// importing the UI portion
import UIKit

// ViewController inherits from UIViewController
// Swift only supports single inheritance
class ViewController: UIViewController {
    
    // Optionals are automatically set to nil. ! always unwraps `display`
    // when it is used somewhere in the code (implicitly unwrapped optional)
    @IBOutlet weak var display: UILabel!
    
    // Indicates if the user is typing or not
    var userIsInTheMiddleOfTypingANumber = false

    @IBAction func appendDigit(sender: UIButton)
    {
        // ! is unwrapping currentTitle which is an optional (String?)
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber
        {
            display.text = display.text! + digit
        }
        else
        {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    // Calls the correct operation on the top 2 elemtns of operandStack
    @IBAction func operate(sender: UIButton)
    {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber
        {
           enter()
        }
        switch operation
        {
        case "×": performOperation {$0 * $1}
        case "÷": performOperation {$1 / $0}
        case "+": performOperation {$0 + $1}
        case "−": performOperation {$1 - $0}
        default: break
        }
    }
    
    // Performs an operation on the top 2 elements of the operandStack
    func performOperation(operation: (Double,Double) -> Double)
    {
        if operandStack.count >= 2
        {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    
    // Adds the number in the display to the internal stack
    var operandStack: [Double] = []
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        println(operandStack)
    }
    
    // Is a Computed Property
    var displayValue: Double
    {
        get
        {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set
        {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
}

