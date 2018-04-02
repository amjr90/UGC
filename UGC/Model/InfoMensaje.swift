//
//  InfoMensaje.swift
//  UGC
//
//  Created by andres jaramillo on 3/27/18.
//  Copyright © 2018 andres jaramillo. All rights reserved.
//

import Foundation
import UIKit
class InfoMensaje {
    var id: String
    var idmensaje: String
    var codigocliente: String
    var codigousuario: String
    var nombreusuario: String
    var tipousuario: String
    var descripcionusuario: String
    var mensaje: String
    var fechamensaje: String
    var fecharegistro: String
    var imagen: String
    var tipomensaje: String
    var conteo: Int
    var image:UIImage!
    
    init(id: String, idmensaje: String,codigocliente: String, codigousuario: String, nombreusuario: String, tipousuario: String, descripcionusuario: String, mensaje: String, fechamensaje: String, fecharegistro: String, imagen: String, tipomensaje: String, conteo: Int) {
        
        self.id = id
        self.idmensaje = idmensaje
        self.codigocliente = codigocliente
        self.codigousuario = codigousuario
        self.nombreusuario = nombreusuario
        self.tipousuario = tipousuario
        self.descripcionusuario = descripcionusuario
        self.mensaje = mensaje
        self.fechamensaje = fechamensaje
        self.fecharegistro = fecharegistro
        self.imagen = imagen
        self.tipomensaje = tipomensaje
        self.conteo = conteo
    }
}
