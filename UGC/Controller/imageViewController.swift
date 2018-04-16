//
//  imageViewController.swift
//  UGC
//
//  Created by andres jaramillo on 4/11/18.
//  Copyright © 2018 andres jaramillo. All rights reserved.
//

import UIKit

class imageViewController: UIView, UIScrollViewDelegate {

    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var imageView: UIImageView!
    
    override func awakeFromNib() {
        scrollView.delegate = self
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
