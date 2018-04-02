//
//  Info.swift
//  UGC
//
//  Created by andres jaramillo on 3/22/18.
//  Copyright © 2018 andres jaramillo. All rights reserved.
//

class Info {
    var codigo: String
    var nombre: String
    var razonSocial: String
    var nit: String
    var direccion: String
    var ciudad: String
    var telefono: String
    var barrio: String
    var canal: String
    
    init(codigo: String, nombre: String, razonSocial: String, nit: String, direccion: String, ciudad: String, telefono: String, barrio: String, canal: String) {
        
        self.codigo = codigo
        self.nombre = nombre
        self.razonSocial = razonSocial
        self.nit = nit
        self.direccion = direccion
        self.ciudad = ciudad
        self.telefono = telefono
        self.barrio = barrio
        self.canal = canal
    }
}
