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
    [1, 1000, 1609.34],
    [1, 1000, 453.592],
    [1,  1 / 2.4768,  1 / 61.3084]
]

