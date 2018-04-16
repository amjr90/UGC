//
//  ViewController.swift
//  UGC
//
//  Created by andres jaramillo on 3/20/18.
//  Copyright © 2018 andres jaramillo. All rights reserved.
//

import UIKit
import SCLAlertView
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var centerYConstraint: NSLayoutConstraint!
    @IBOutlet var configuracionButton: RoundButton!
    
    @IBOutlet var labelConfiguracion: UILabel!
    
    var usuario = Usuario()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Usuario.plist")
    
    let customWindows = CustomWindows()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuracionButton.applyDesign()
        configuracionButton.applyBorderColor()
        
        loadUser()
        
        if(self.usuario.res == "OK")
        {
            self.updateUIWithUserData(usuario: self.usuario)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func BotonConfiguracion(_ sender: Any)
    {
        customWindows.showCustomLoginAlert(function: self.login)
    }
    
    @IBAction func botonMuro(_ sender: Any)
    {
        if(usuario.res == "OK")
        {
            performSegue(withIdentifier: "goToMuro", sender: self)
        }
        else
        {
            customWindows.showCustomInfoAlertAndLogin(fun: self.login)
        }
    }
    
    func login(user: String)
    {
        let apiManager = APIManager()
        apiManager.login(usuario: user, token: "jdhskfhdsjkhfkjasdf") { (user) in
            
            self.usuario = user
            
            if(self.usuario.res == "OK")
            {
                self.updateUIWithUserData(usuario: self.usuario)
                self.saveUser()
            }
            else if(self.usuario.res == "ERROR")
            {
                self.customWindows.showErrorAlert(errorMessage: "Este usuario no existe")
                self.loadUser()
            }
            else
            {
                self.customWindows.showErrorAlert(errorMessage: self.usuario.res)
                self.loadUser()
            }
        }
    }
    
    func saveUser()
    {
        let encoder = PropertyListEncoder()
        do
        {
            let data = try encoder.encode(usuario)
            try data.write(to: dataFilePath!)
        }
        catch {print("error encoding \(error)")}
    }
    
    func loadUser()
    {
        if let data = try? Data(contentsOf: dataFilePath!)
        {
            let decoder = PropertyListDecoder()
            do
            {
                 usuario = try decoder.decode(Usuario.self, from: data)
            }
            catch {print("error dencoding \(error)")}
        }
    }
    
    func deleteUser()
    {
        do
        {
            try FileManager.default.removeItem(at: dataFilePath!)
        }
        catch {print("error deleting \(error)")}
    }
    
    func updateUIWithUserData(usuario: Usuario)
    {
        labelConfiguracion.text = "\(usuario.codigousuario)\n\(usuario.nombreusuario)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "goToMuro")
        {
            let destinationVC = segue.destination as! MuroViewController
            destinationVC.usuario = usuario
        }
    }
    
//MARK - Verifica la orientacion de la pantalla
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isLandscape
        {
            heightConstraint.isActive = true
            centerYConstraint.isActive = false
            scrollView.isScrollEnabled = true
        }
        else
        {
            heightConstraint.isActive = false
            centerYConstraint.isActive = true
            scrollView.isScrollEnabled = false
        }
    }
    
}




