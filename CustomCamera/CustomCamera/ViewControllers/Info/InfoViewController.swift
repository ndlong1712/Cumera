//
//  InfoViewController.swift
//  CustomCamera
//
//  Created by Mac Mini on 1/15/18.
//  Copyright © 2018 FAYA Corporation. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    static let ClassName = "InfoViewController"

    @IBOutlet weak var imgInfo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func didTapCloseButton(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
