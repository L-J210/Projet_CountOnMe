//
//  Calculator.swift
//  CountOnMe
//
//  Created by Archeron on 30/06/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Calculator {
    private(set) var currentExpression: String = "" {
        didSet {
            sendCurrentExpressionDidChangeNotification()
        }
    }

    private var elements: [String] {
        return currentExpression.split(separator: " ").map { "\($0)" }
    }

    private var expressionHaveResult: Bool {
        return elements.contains("=")
    }

    private var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }

    private var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-"
    }

    func addNumber(_ number: Int) {
        if expressionHaveResult {
            currentExpression = ""
        }
        currentExpression.append("\(number)")
    }

    func addPlusOperator() -> Bool {
        guard expressionIsCorrect, !expressionHaveResult else {
            return false
        }
        currentExpression.append(" + ")
        return true
    }

    func addMinusOperator() -> Bool {
        guard expressionIsCorrect, !expressionHaveResult else {
            return false
        }
        currentExpression.append(" - ")
        return true
    }

    func computeExpression() -> Bool {
        guard !expressionHaveResult else {
            // result is already calculated
            return true
        }

        guard expressionHaveEnoughElement else {
            return false
        }

        guard expressionIsCorrect else {
            return false
        }

        // Create local copy of operations
        var operationsToReduce = elements

        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            guard let left = Int(operationsToReduce[0]) else {
                return false
            }

            let operand = operationsToReduce[1]

            guard let right = Int(operationsToReduce[2]) else {
                return false
            }

            let result: Int
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            default: return false
            }

            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }

        guard let result = operationsToReduce.first else {
            return false
        }

        currentExpression.append(" = \(result)")

        return true
    }

    func sendCurrentExpressionDidChangeNotification() {
        let name = Notification.Name(rawValue: "ExpressionDidChange")
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)

    }
}
