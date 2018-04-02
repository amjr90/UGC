//
//  TextFieldBorder.swift
//  UGC
//
//  Created by andres jaramillo on 3/22/18.
//  Copyright © 2018 andres jaramillo. All rights reserved.
//

import Foundation
import UIKit

class TextFieldBorder: UITextField {
    override func didMoveToWindow() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hexString: "#209689").cgColor
        //        self.titleLabel?.minimumScaleFactor = 10
        //        self.titleLabel?.contentScaleFactor = 17
        //        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
}

extension UITextField
{
    func applyDesign()
    {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hexString: "#209689").cgColor
        //        self.titleLabel?.minimumScaleFactor = 10
        //        self.titleLabel?.contentScaleFactor = 17
        //        self.titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
}
