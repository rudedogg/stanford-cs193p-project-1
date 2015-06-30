//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Austin Rude on 6/22/15.
//  Copyright © 2015 Austin Rude. All rights reserved.
//

import Foundation

class CalculatorBrain {
   
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    var history: String = "" 
    
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
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
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("×", *))
        knownOps["÷"] = Op.BinaryOperation("÷", {$1 / $0})
        knownOps["−"] = Op.BinaryOperation("−", {$1 - $0})
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["sin"] = Op.UnaryOperation("sin", sin)
        knownOps["cos"] = Op.UnaryOperation("cos", cos)
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        history = "\(opStack)" 
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        history = "\(opStack)" 
        return evaluate()
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        history = "\(opStack)"
        return result
        
    }
    
    func clear() {
        opStack = [Op]()
        history = ""
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
            }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
            if let operand1 = op1Evaluation.result {
                let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                if let operand2 = op2Evaluation.result {
                    return (operation(operand1, operand2), op2Evaluation.remainingOps)
                }
            }
        }
    }
    return (nil, ops)
}
}