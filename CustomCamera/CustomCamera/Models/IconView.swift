//
//  IconView.swift
//  CustomCamera
//
//  Created by NguyenDinh.Long on 1/5/18.
//  Copyright © 2018 FAYA Corporation. All rights reserved.
//

import UIKit

protocol IConViewDelegate {
    func didTapOnICon()
}

enum BrightStyle: Int {
    case Light = 0
    case Normal = 1
    case Dark = 2
}

class IconView: UIImageView {
    
  private var originalCenter: CGPoint?
  private var dragStart: CGPoint?
    var delegate: IConViewDelegate?
    var brightMode: BrightStyle = .Dark
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    delegate?.didTapOnICon()
    originalCenter = center
//    dragStart = touches.first!.location(in: superview)
//    let current = self.frame.origin
//    dragStart = CGPoint(x: current.x + 6, y: current.y + 6)
    dragStart = center
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    var location = touch.location(in: superview)
    if let predicted = event?.predictedTouches(for: touch)?.last {
      location = predicted.location(in: superview)
    }
    center = dragStart! + location - originalCenter!
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: superview)
    center = dragStart! + location - originalCenter!
  }

}
