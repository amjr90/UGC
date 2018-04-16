//
//  GaleriaViewController.swift
//  UGC
//
//  Created by andres jaramillo on 4/11/18.
//  Copyright © 2018 andres jaramillo. All rights reserved.
//

import UIKit

class GaleriaViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    var infos = [InfoMensaje]()
    //var imagenes = [UIImage]()
    var imagenesDictionary: [String:UIImage] = [:]
    
    let apiManager = APIManager()
    
    var images = [UIImage]()
    let colors = [UIColor.red, UIColor.black, UIColor.blue]
   
    var idMensaje = "idmensaje"
    
    var imageViews = [imageViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descargarImagenes(){
            var i = 0
            print(self.idMensaje)
            for (index, v) in self.imagenesDictionary.enumerated()
            {
                if v.key == self.idMensaje
                {
                    i = index
                     self.scrollToPage(page: i, animated: false)
                }
            }
        }
    }
    
    func scrollToPage(page: Int, animated: Bool) {
        var frame: CGRect = self.scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page);
        frame.origin.y = 0;
        //self.scrollView.scrollRectToVisible(frame, animated: animated)
        self.scrollView.setContentOffset(CGPoint(x: frame.origin.x, y: 0), animated: animated)

    }
    
    func updateUI()
    {
        scrollView.isPagingEnabled = true
        //scrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(images.count), height: self.view.bounds.height)
        scrollView.contentSize.width = self.view.bounds.width * CGFloat(imagenesDictionary.count)
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    func loadImages()
    {
        for (index,image) in imagenesDictionary.enumerated()
        {
            if let imageView = Bundle.main.loadNibNamed("imageView", owner: self, options: nil)?.first as? imageViewController{
                imageView.imageView.image = image.value
                
                scrollView.addSubview(imageView)
                imageView.frame.size.width = self.scrollView.bounds.size.width
                imageView.frame.size.height = self.scrollView.bounds.size.height
                imageView.frame.origin.x = CGFloat( index ) * self.view.bounds.width
                imageViews.append(imageView)
            }
        }
    }
    
    func removeViews()
    {
        if imageViews.count > 0
        {
            for view in imageViews
            {
                view.removeFromSuperview()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isLandscape
        {
            self.removeViews()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1/3)) {
                self.updateUI()
                self.loadImages()
            }
        }
        else
        {
            self.removeViews()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1/3)) {
                self.updateUI()
                self.loadImages()
            }
        }
    }
    
    func descargarImagenes(completion:@escaping () -> Void )
    {
        for info in infos
        {
            apiManager.getImageFromUrl(url: info.imagen) { (imagen) in
                self.imagenesDictionary[info.idmensaje] = imagen
                //self.images.append(imagen)
                self.updateUI()
                self.loadImages()
                completion()
            }
        }
    }
    
    @IBAction func botonAtras(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
