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
    ["Grams", "Kilograms", "Milligrams"],
    ["USD", "BYN", "RUB"]
]

let valueCoefficients: [[BigDecimal]] = [
    [1, 1000, 1609.34],
    [1, 1000, 0.001],
    [1,  1 / 2.5,  1 / 64]
]

