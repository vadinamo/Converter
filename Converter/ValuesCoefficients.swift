//
//  ValuesCoefficients.swift
//  Converter
//
//  Created by Вадим Юрьев on 26.10.22.
//

import BigDecimal

let unitCategories = ["Distance", "Weight", "Currency"]

let unitTypes = [
    ["Meters", "Kilometers", "Miles"],
    ["Grams", "Kilograms", "Pounds"],
    ["USD", "BYN", "RUB"]
]

let valueCoefficients: [[BigDecimal]] = [
    [1, 0.001, 0.000621],
    [1, 0.001, 0.00220462],
    [1, 2.4768,  61.3084]
]
