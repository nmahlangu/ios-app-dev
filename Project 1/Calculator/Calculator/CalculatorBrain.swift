//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Nicholas Mahlangu on 5/27/15.
//  Copyright (c) 2015 Nicholas Mahlangu. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    // This enum implements the protocal Printable
    private enum Op: Printable
    {
        // 0,1,2,3,4,5,6,7,8,9
        case Operand(Double)
        // sqrt, sin, cos
        case UnaryOperation(String, Double -> Double)
        // ×, ÷, +, −
        case BinaryOperation(String, (Double,Double) -> Double)
        
        // Teaches the enum how to print itself. It has to be a variable
        // called description. 
        var description: String
        {
            get
            {
                switch self
                {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    // () are calling the array initializer for opStack, and dictionary
    // initializer for knownOps
    private var opStack = [Op]()
    // This is a dictionary; key is a string, value is an Op
    private var knownOps = [String: Op]()
    
    init()
    {
        // You can define functions in other functions
        func learnOp(op: Op)
        {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷") {$1 / $0})
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−") {$1 - $0})
        learnOp(Op.UnaryOperation("√", sqrt))
    }
    
    // Recursively evaluates what's on the stack
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty
        {
            // Removes the last element of the stack. The switch statement
            // essentially matches on the different cases of the last element
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op
            {
            // Returns the number on top of the stack and the remaining stack
            case .Operand(let operand):
                return (operand, remainingOps)
            // `operation` here will be a function, e.g. sqrt or cos. `operation`
            // will be applied to the result of recursively evaluating the rest
            // of the stack until a number is gotten at the top
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result
                {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            // `operation` here will be a function, e.g. × or ÷. `operation` will be
            // applied to recursively evaluating the rest of the stack until the top 
            // 2 elements of the stack a numbers
            case .BinaryOperation(_, let operation):
                // Recursively compute the first number
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result
                {
                    // Recursively compute the second number
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result
                    {
                        return (operation(operand1,operand2), op2Evaluation.remainingOps)
                    }
                }
            }
            
        }
        
        // This is returned if the user types an invalid sequence (e.g. just "×")
        return (nil,ops)
    }
    
    // Evaluates the stack based on if the last thing added was an operand
    // (a number) or an operation)
    func evaluate() -> Double?
    {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    // Pushes a number onto the stack in the form of an enum
    func pushOperand(operand: Double) -> Double?
    {
        opStack.append(Op.Operand(operand))
        // Evaluates the stack. Since the top element of the stack is just
        // a number, the display will show that number
        return evaluate()
    }
    
    // Performs an operation
    func performOperation(symbol: String) -> Double?
    {
        if let operation = knownOps[symbol]
        {
            opStack.append(operation)
        }
        return evaluate()
    }
}
