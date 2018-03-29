//
//  PersistentService.swift
//  Cheese
//
//  Created by Tien on 3/30/18.
//  Copyright © 2018 FAYA Corporation. All rights reserved.
//

import UIKit

class PersistentService: NSObject {
    static let shared = PersistentService()
    
    let ud_timesWrong = "times_wrong"
    let verification_passed = "verification_passed"
    
    func getNumberOfInvalidCode() -> Int {
        return UserDefaults.standard.integer(forKey: ud_timesWrong)
    }
    
    func saveNumberOfInvalidCode(number: Int) {
        UserDefaults.standard.set(number, forKey: ud_timesWrong)
    }
    
    func verificationStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: verification_passed)
    }
    
    func setVerificationStatus(_ status: Bool) {
        UserDefaults.standard.set(status, forKey: verification_passed)
    }
}
