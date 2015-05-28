//
//  ViewController.swift
//  Calculator
//
//  Created by Nicholas Mahlangu on 5/26/15.
//  Copyright (c) 2015 Nicholas Mahlangu. All rights reserved.
//

// Importing the UI portion
import UIKit

// ViewController inherits from UIViewController
// Swift only supports single inheritance
class ViewController: UIViewController
{
    
    // Optionals are automatically set to nil. ! always unwraps `display`
    // when it is used somewhere in the code (implicitly unwrapped optional)
    @IBOutlet weak var display: UILabel!
    
    // Indicates if the user is typing or not
    var userIsInTheMiddleOfTypingANumber = false
    
    let brain = CalculatorBrain()

    // Appends a digit to the top label
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
    
    // Is called when the user presses one of the operations ×, ÷, +, −
    @IBAction func operate(sender: UIButton)
    {
        // Stop typing of the user didn't hit enter before an operand
        if userIsInTheMiddleOfTypingANumber
        {
           enter()
        }
        // currentTitle gets the text that is being displayed on the button.
        // operation will be one of ×, ÷, +, −
        if let operation = sender.currentTitle
        {
            if let result = brain.performOperation(operation)
            {
                // Set the display value to the result of the operation
                // that was just performed
                displayValue = result
            }
            else
            {
                // This means the operation failed. Putting a 0 in the display is a
                // temporary solution
                displayValue = 0
            }
        }
    }
    
    // Is used to update the value of the display at all times. Always pushes a number
    // onto the stack
    @IBAction func enter()
    {
        userIsInTheMiddleOfTypingANumber = false
        // Pushes a number onto the stack
        if let result = brain.pushOperand(displayValue)
        {
            displayValue = result
        }
        else
        {
            // Fix this to make it be an optional.
            // Want to have it put up an error message here
            displayValue = 0
        }
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

