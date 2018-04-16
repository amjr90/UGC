//
//  MensajeTableViewCell.swift
//  UGC
//
//  Created by andres jaramillo on 3/26/18.
//  Copyright © 2018 andres jaramillo. All rights reserved.
//

import UIKit

class MensajeTableViewCell: UITableViewCell {

    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var textoLabel: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var comentarioLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var comentarioCountLabel: UILabel!
    @IBOutlet weak var comentariosUIImageView: UIImageView!
    @IBOutlet weak var likeUIImageView: UIImageView!
    @IBOutlet weak var copyUIImageView: UIImageView!
    @IBOutlet weak var uiViewImage: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setImage(uiImageView: comentariosUIImageView)
        setImage(uiImageView: likeUIImageView)
        setImage(uiImageView: copyUIImageView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setMensajeImagen(img: UIImage)
    {
        imagen.image = img
    }
    
    func resetImg()
    {
        imagen.image = nil
    }

    func setImage(uiImageView: UIImageView)
    {
        let origImage = uiImageView.image
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        
        uiImageView.image = tintedImage
        uiImageView.tintColor = UIColor(hexString: "209689")
    }
}
