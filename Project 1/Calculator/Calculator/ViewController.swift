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
                // Error
                displayValue = nil
            }
        }
    }
    
    // Is used to update the value of the display at all times. Always pushes a number
    // onto the stack
    @IBAction func enter()
    {
        userIsInTheMiddleOfTypingANumber = false
        // Make sure the user has entered a valid double
        if (displayValue != nil)
        {
            // Pushes a number onto the stack
            if let result = brain.pushOperand(displayValue!)
            {
                displayValue = result
            }
            else
            {
                // Error
                displayValue = nil
            }
        }
    }
    
    // Is a Computed Property
    var displayValue: Double?
    {
        get
        {
            if occurrences(display.text!, c: ".") < 2
            {
                return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            }
            // Return nil if invalid float (more than 1 ".")
            return nil
        }
        set
        {
            // Put up an error if the user messed up, or the correct value
            if (newValue != nil)
            {
                display.text = "\(newValue!)"
            }
            else
            {
                display.text = "Error"
            }
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    // Counts the number of occurrences of a specified character in a string
    func occurrences(s: String, c: Character) -> Int
    {
        var occ_count = 0
        for ch in s
        {
            if ch == c
            {
                occ_count += 1
            }
        }
        return occ_count
    }
}

