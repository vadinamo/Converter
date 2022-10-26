//
//  ValuesCoefficients.swift
//  Converter
//
//  Created by Вадим Юрьев on 26.10.22.
//



let unitCategories = ["Distance", "Weight", "Currency"]

let unitTypes = [
    ["Meters", "Kilometers", "Miles"],
    ["Grams", "Kilograms", "Pounds"],
    ["USD", "BYN", "RUB"]
]

let valueCoefficients = [
    [1, 0.001, 0.000621],
    [1, 0.001, 0.00220462],
    [1, 2.4768,  61.3084]
]


func convertValue(unitCategory: Int, type1: Int, type2: Int, value: Double) -> String {
    return String(value / valueCoefficients[unitCategory][type1] * valueCoefficients[unitCategory][type2])
}
