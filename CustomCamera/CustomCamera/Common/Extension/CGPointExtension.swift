//
//  CGPointExtension.swift
//  CustomCamera
//
//  Created by Mac Mini on 1/6/18.
//  Copyright © 2018 FAYA Corporation. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}
