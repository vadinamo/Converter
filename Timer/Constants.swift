//
//  Constants.swift
//  Timer
//
//  Created by Вадим Юрьев on 14.11.22.
//

import Foundation

class Constants {
    public static let DARK_MODE = "DARK_MODE"
    public static let LIGHT_MODE = "LIGHT_MODE"
}

class UserDefaultsUtils {
    static var shared = UserDefaultsUtils()
    func setDarkMode(enable: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(enable, forKey: Constants.DARK_MODE)
    }
    func getDarkMode() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: Constants.DARK_MODE)
    }
}

var languages = [ "English", "Русский"]

var fonts = ["Small", "Medium", "Large"]
var fontsLocale = ["Small" : "Маленький", "Medium" : "Нормальный", "Large" : "Здоровый"]

var typesLocale = ["Preparation" : "Подготовка", "Training" : "Тренировка", "Resting" : "Отдых"]

var fontSizes = [
    "Small": 18,
    "Medium": 28,
    "Large": 36
]
