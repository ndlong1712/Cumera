//
//  Utils.swift
//  CustomCamera
//
//  Created by Mac Mini on 1/6/18.
//  Copyright © 2018 FAYA Corporation. All rights reserved.
//

import Foundation
import UIKit

class Utilities: NSObject {
    static func getViewController(identifier: String) -> UIViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: identifier)
        return vc
    }
    
    static func showCard(cardName: CardName, cardType: CardType) -> UIImage {
        let imageName = "b_\(cardName.rawValue)_of_\(cardType)"
        let imgCard = UIImage(named: imageName)
        return imgCard!
    }
  
  static func showAlertSavedImage(message: String, viewController: UIViewController) {
    let alertView = UIAlertController(title: "", message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
        
    })
    alertView.addAction(action)
    viewController.present(alertView, animated: true, completion: nil)
  }
}
