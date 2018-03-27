
//
//  BorderedLabel.swift
//  Cheese
//
//  Created by Tien on 3/27/18.
//  Copyright © 2018 FAYA Corporation. All rights reserved.
//

import UIKit

class BorderedLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 16
        layer.borderWidth = 1.0
    }
}
