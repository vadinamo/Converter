//
//  Operations.swift
//  Calculator
//
//  Created by Вадим Юрьев on 23.11.22.
//

import Foundation

var several_items_operations: [String] = [
    "+",
    "-",
    "*",
    "/",
    "^"
]

var single_items_operations: [String] = [
    "sin",
    "cos",
    "tg",
    "ctg",
    "ln",
    "log",
    "!",
    "e",
    "pi"
]

var priority: [String: Int] = [
    "(": 0,
    ")": 0,
    "+": 1,
    "-": 1,
    "*": 2,
    "/": 2,
    "^": 3,
    "sin": 4,
    "cos": 4,
    "tg": 4,
    "ctg": 4,
    "ln": 4,
    "log": 4,
    "!": 4
]
