//
//  RoundButton.swift
//  UGC
//
//  Created by andres jaramillo on 3/22/18.
//  Copyright © 2018 andres jaramillo. All rights reserved.
//

import Foundation
import UIKit

class RoundButton: UIButton {
    override func didMoveToWindow() {
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        //        self.titleLabel?.minimumScaleFactor = 10
        //        self.titleLabel?.contentScaleFactor = 17
        //        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
}

extension UIButton
{
    func applyDesign()
    {
        self.layer.cornerRadius = 12
        
        //        self.titleLabel?.minimumScaleFactor = 10
        //        self.titleLabel?.contentScaleFactor = 17
        //        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    func applyBorderColor()
    {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }
}


