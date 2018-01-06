//
//  CardCollectionViewCell.swift
//  CustomCamera
//
//  Created by Mac Mini on 1/6/18.
//  Copyright © 2018 FAYA Corporation. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    static let ClassName = "CardCollectionViewCell"
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected {
                selectItem()
            } else {
                deselectItem()
            }
        }
    }
    
    @IBOutlet weak var labelCardName: UILabel!
    
    func setupView() {
        self.layer.cornerRadius = self.frame.width/2
        self.layer.masksToBounds = true
    }
    
    func deselectItem() {
        self.backgroundColor = UIColor.white
        self.labelCardName.textColor = UIColor.black
    }
    func selectItem() {
        self.backgroundColor = UIColor().hexToColor(hexString: selectColor, alpha: 1)
        self.labelCardName.textColor = UIColor.white
    }
    
}
