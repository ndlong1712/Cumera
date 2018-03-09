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
    var viewAlpha: UIView?
    var rootImage: UIImage?
    var delegate: IConViewDelegate?
    var brightMode: BrightStyle? {
        didSet {
            setBrightColor(mode: brightMode!)
        }
    }
    
    func setUpImageView() {
//        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
//        viewAlpha = UIView(frame: frame)
//        viewAlpha?.backgroundColor = UIColor.black
//        self.addSubview(viewAlpha!)
        rootImage = self.image
        brightMode = .Dark
    }
    
    func setBrightColor(mode: BrightStyle) {
        switch mode {
        case .Dark:
            self.image? = (rootImage?.tint(tintColor: UIColor.init(hexString: "66000000")))! // !!
            self.layer.opacity = 0.9
            break
        case .Normal:
            self.image? = (rootImage?.tint(tintColor: UIColor.init(hexString: "33000000")))! // !!
            self.layer.opacity = 0.95
            break
        case .Light:
            self.image? = (rootImage?.tint(tintColor: UIColor.init(hexString: "00000000")))! //!!
            self.layer.opacity = 1
            break
        }
    }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//    delegate?.didTapOnICon()
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

