//
//  UIViewExtension.swift
//  CustomCamera
//
//  Created by NguyenDinh.Long on 1/6/18.
//  Copyright © 2018 FAYA Corporation. All rights reserved.
//

import Foundation
import UIKit

extension UIView
{
  func copyView<T: UIView>() -> T {
    return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
  }
  
  func addTapGesture(tapNumber : Int, target: Any , action : Selector) {
    
    let tap = UITapGestureRecognizer(target: target, action: action)
    tap.numberOfTapsRequired = tapNumber
    addGestureRecognizer(tap)
    isUserInteractionEnabled = true
    
  }
}
