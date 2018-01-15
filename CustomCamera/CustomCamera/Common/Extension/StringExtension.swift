//
//  StringExtension.swift
//  CustomCamera
//
//  Created by Mac Mini on 1/12/18.
//  Copyright © 2018 FAYA Corporation. All rights reserved.
//

import Foundation

extension String {
    func localized() ->String {
        let lang = UserDefaultHelper.getLanguage()
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    func localized(lang: String) ->String {
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
}
