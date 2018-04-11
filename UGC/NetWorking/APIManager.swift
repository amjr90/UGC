//
//  APIManager.swift
//  UGC
//
//  Created by andres jaramillo on 3/21/18.
//  Copyright © 2018 andres jaramillo. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON
import SVProgressHUD

class APIManager
{
    let baseURL = "http://64.239.5.63/MURO/"
    
    func login(usuario: String, token: String, completion: @escaping (Usuario) -> Void)
    {
        let path = "services.php?option=login&usuario=\(usuario)&token=\(token))"
        let url = baseURL+path
        let usuario = Usuario()
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, parameters: nil).responseJSON{ response in
            
            if response.result.isSuccess
            {
                let jsonResponse : JSON = JSON(response.value!)
                
                if(jsonResponse["res"] == "OK")
                {
                    usuario.nombreusuario = jsonResponse["nombreusuario"].stringValue
                    usuario.urlImagen = jsonResponse["UrlImagen"].stringValue
                    usuario.descripcionusuario = jsonResponse["descripcionusuario"].stringValue
                    usuario.res = jsonResponse["res"].stringValue
                    usuario.token = jsonResponse["token"].stringValue
                    usuario.tipousuario = jsonResponse["tipousuario"].stringValue
                    usuario.codigousuario = jsonResponse["codigousuario"].stringValue
                    usuario.idHub = jsonResponse["idHub"].stringValue
                    usuario.descripcion = jsonResponse["descripcion"].stringValue
                    usuario.id = jsonResponse["id"].stringValue
                }
                else
                {
                    usuario.res = "ERROR"
                }
            }
            else
            {
                print("Error \(String(describing: response.result.error))")
                usuario.res = "Verifique su conexion a internet y vuelva a intentarlo"
            }
            SVProgressHUD.dismiss()
            completion(usuario)
        }
    }
    
    func buscarUsuario(busqueda: String, usuario:String, completion: @escaping ([Info]) -> Void)
    {
        let path = "services.php?option=consultaclientes&busqueda=\(busqueda)&usuario=\(usuario)"
        let url = baseURL+path
        var infos = [Info]()
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, parameters: nil).responseJSON{ response in
            
            if response.result.isSuccess
            {
                let jsonResponse : JSON = JSON(response.value!)
                
                for result in jsonResponse["info"].arrayValue
                {
                    let codigo = result["Codigo"].stringValue
                    let nombre = result["Nombre"].stringValue
                    let razonSocioal = result["Razonsocial"].stringValue
                    let nit = result["Nit"].stringValue
                    let direccion = result["Direccion"].stringValue
                    let ciudad = result["Ciudad"].stringValue
                    let telefono = result["Telefono"].stringValue
                    let barrio = result["Barrio"].stringValue
                    let canal = result["Canal"].stringValue
                    
                    let info = Info(codigo: codigo, nombre: nombre, razonSocial: razonSocioal, nit: nit, direccion: direccion, ciudad: ciudad, telefono: telefono, barrio: barrio, canal: canal)
                    infos.append(info)
                }
            }
            completion(infos)
            SVProgressHUD.dismiss()
        }
    }
    
    func buscarMensajesSinLeer()
    {
        let path = "services.php?option=consultamensajessinleer&usuario=4160"
        let url = baseURL+path
        
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, parameters: nil).responseJSON{ response in
            
            if response.result.isSuccess
            {
            }
        }
    }
    
    func buscarMensajes(codigoUsuario: String, codigoCliente: String, completion: @escaping ([InfoMensaje]) ->Void)
    {
        let path = "services.php?option=listamensajes&usuario=\(codigoUsuario)&cliente=\(codigoCliente)"
        let url = baseURL+path
        var infos = [InfoMensaje]()

        SVProgressHUD.show()
        Alamofire.request(url, method: .get, parameters: nil).responseJSON{ response in
            
            if response.result.isSuccess
            {
                let jsonResponse : JSON = JSON(response.value!)
                //print(jsonResponse)
                for result in jsonResponse["info"].arrayValue
                {
                    let id = result["id"].stringValue
                    let idmensaje = result["idmensaje"].stringValue
                    let codigocliente = result["codigocliente"].stringValue
                    let codigousuario = result["codigousuario"].stringValue
                    let nombreusuario = result["nombreusuario"].stringValue
                    let tipousuario = result["tipousuario"].stringValue
                    let descripcionusuario = result["descripcionusuario"].stringValue
                    let mensaje = result["mensaje"].stringValue
                    let fechamensaje = result["fechamensaje"].stringValue
                    let fecharegistro = result["fechaRegistro"].stringValue
                    let imagen = result["imagen"].stringValue
                    let tipomensaje = result["tipomensaje"].stringValue
                    let conteo = result["conteo"].intValue
                    
                    let info = InfoMensaje(id: id, idmensaje: idmensaje, codigocliente: codigocliente, codigousuario: codigousuario, nombreusuario: nombreusuario, tipousuario: tipousuario, descripcionusuario: descripcionusuario, mensaje: mensaje, fechamensaje: fechamensaje, fecharegistro: fecharegistro, imagen: imagen, tipomensaje: tipomensaje, conteo: conteo)
                    infos.append(info)
                }
            }
            completion(infos)
            SVProgressHUD.dismiss()
        }
    }
    
    func getImageFromUrl(url: String, completion: @escaping (Image) -> Void)
    {
        Alamofire.request(self.baseURL+"uploadImagenes/"+url).responseImage { response in
            //print(self.baseURL+"uploadImagenes/"+url)
            if let image = response.result.value {
                completion(image)
            }
        }
    }
    
    func enviarMensajeSinImagen(usuario: Usuario, info: Info, mensaje: String, completion: @escaping (String) -> Void)
    {
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmssSSS"
        
        var result = formatter.string(from: date as Date)
        let idMensaje = "A\(result)"
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        result = formatter.string(from: date as Date)
        let fechaMensaje = result

        
        let path = "services.php?option=guardamensaje&idmensaje=\(idMensaje)&codigocliente=\(info.codigo)&codigousuario=\(usuario.codigousuario)&nombreusuario=\(usuario.nombreusuario)&tipousuario=\(usuario.tipousuario)&descripcionusuario=\(usuario.descripcion)&mensaje=\(mensaje)&fechamensaje=\(fechaMensaje)&imagen=\("")&tipomensaje=1&token=\("aaaaaaa")"
        
        let url = baseURL+path
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        SVProgressHUD.show()
        
        Alamofire.request(encodedUrl!, method: .get, parameters: nil).responseJSON{ response in
            if response.result.isSuccess
            {
                completion("OK")
            }
            else
            {
                completion("ERROR")
            }
        }
        SVProgressHUD.dismiss()
    }
    
    func enviarMensajeConImagen(usuario: Usuario, info: Info, imagen: UIImage, completion: @escaping (String) -> Void)
    {
        SVProgressHUD.show()
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmssSSS"

        var result = formatter.string(from: date as Date)
        let idMensaje = "A\(result)"

        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        result = formatter.string(from: date as Date)
        let fechaMensaje = result

        let params : [String:Any] = ["option":"guardamensaje" as NSString,
                                     "idmensaje": idMensaje as NSString,
                                     "codigocliente":info.codigo as NSString,
                                     "codigousuario":usuario.codigousuario as NSString,
                                     "nombreusuario":usuario.nombreusuario as NSString,
                                     "tipousuario":usuario.tipousuario as NSString,
                                     "descripcionusuario":usuario.descripcion as NSString,
                                     "mensaje":"" as NSString,
                                     "fechamensaje":fechaMensaje as NSString,
                                     "tipomensaje":"2" as NSString,
                                     "token":"aaaaaaa" as NSString]

        let imgData = UIImageJPEGRepresentation(imagen, 1)
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data"
        ]

        Alamofire.upload(multipartFormData: { (MultipartFormData) in

             MultipartFormData.append(imgData!, withName: "imagen", fileName: "image.jpeg", mimeType: "image/jpeg")

            for (key, value) in params {
                MultipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as String)
            }

        }, usingThreshold: UInt64.init(), to: "http://64.239.5.63/MURO/services.php", method: .post, headers: headers) { (result) in
                print(result)
                switch result {
                case .success(let upload, _, _):

                    upload.responseJSON { response in
                        print(response.result.value as Any)
                        completion("OK")
                    }

                case .failure(let encodingError):
                    print(encodingError)
                    completion("ERROR")
                }
            SVProgressHUD.dismiss()
        }

////            to: "http://64.239.5.63/MURO/services.php"){
////                (result) in
////
////                switch result {
////                case .success(let upload, _, _):
////
////                    upload.responseJSON { response in
////                        print(response.result.value as Any)
////                        completion("OK")
////                    }
////
////                case .failure(let encodingError):
////                    print(encodingError)
////                    completion("ERROR")
////                }
//
//
   }

   
    
}



