//
//  MuroTableViewCell.swift
//  UGC
//
//  Created by andres jaramillo on 3/22/18.
//  Copyright © 2018 andres jaramillo. All rights reserved.
//

import UIKit

class MuroTableViewCell: UITableViewCell {

    @IBOutlet var labelNombre: UILabel!
    @IBOutlet var labelCodigoSap: UILabel!
    @IBOutlet var labelRazonSocial: UILabel!
    @IBOutlet var labelNit: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
