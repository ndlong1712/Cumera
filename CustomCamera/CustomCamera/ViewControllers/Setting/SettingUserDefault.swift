//
//  SettingUserDefault.swift
//  CustomCamera
//
//  Created by Mac Mini on 1/6/18.
//  Copyright © 2018 FAYA Corporation. All rights reserved.
//

import Foundation

let cardName = "cardName"
let cardType = "cardType"
let isCaptureTimer = "isCaptureTimer"
let captureTimer = "captureTimer"
let language = "language"

class UserDefaultHelper: NSObject {
    static func saveSetting(setting: SettingModel) {
        saveCardName(name: setting.cardName.rawValue)
        saveCardType(type: setting.cardType.rawValue)
        saveStatusIsCaptureTimer(isCapture: setting.isCaptureTimer)
        saveCaptureTimer(timer: setting.timer)
        saveLanguage(lang: setting.language.rawValue)
    }
    
    static func saveCardName(name: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(name, forKey: cardName)
        userDefaults.synchronize()
    }
    
    static func getCardName() -> String {
        let userDefaults = UserDefaults.standard
        let name = userDefaults.value(forKey: cardName)
        if name == nil {
            return CardModel.ofCards[0].name.rawValue
        }
        return name as! String
    }
    
    static func saveCardType(type: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(type, forKey: cardType)
        userDefaults.synchronize()
    }
    
    static func getCardType() -> String {
        let userDefaults = UserDefaults.standard
        let type = userDefaults.value(forKey: cardType)
        if type == nil {
            return CardType.hearts.rawValue
        }
        return type as! String
    }
    
    static func saveStatusIsCaptureTimer(isCapture: Bool) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(isCapture, forKey: isCaptureTimer)
        userDefaults.synchronize()
    }
    
    static func getStatusIsCaptureTimer() -> Bool {
        let userDefaults = UserDefaults.standard
        let status = userDefaults.value(forKey: isCaptureTimer)
        if status == nil {
            return false
        }
        return status as! Bool
    }
    
    static func saveCaptureTimer(timer: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(timer, forKey: captureTimer)
        userDefaults.synchronize()
    }
    
    static func getCaptureTimer() -> Int {
        let userDefaults = UserDefaults.standard
        let timer = userDefaults.value(forKey: captureTimer)
        if timer == nil {
            return 1
        }
        return timer as! Int
    }
    
    static func saveLanguage(lang: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(lang, forKey: language)
        userDefaults.synchronize()
    }
    
    static func getLanguage() -> String {
        let userDefaults = UserDefaults.standard
        let lang = userDefaults.value(forKey: language)
        if lang == nil {
            return "en"
        }
        return lang as! String
    }
    
    
}
