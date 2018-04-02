//
//  ColorImageView.swift
//  UGC
//
//  Created by andres jaramillo on 3/28/18.
//  Copyright © 2018 andres jaramillo. All rights reserved.
//

import UIKit

class ColorImageView: UIImageView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.image?.withRenderingMode(.alwaysTemplate)
    }
    

}
