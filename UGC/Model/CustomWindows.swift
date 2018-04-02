//
//  CustomWindows.swift
//  UGC
//
//  Created by andres jaramillo on 3/23/18.
//  Copyright © 2018 andres jaramillo. All rights reserved.
//

import Foundation
import SCLAlertView

class  CustomWindows{
    
    func showCustomLoginAlert(function: @escaping (String) -> Void)
    {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "Montserrat", size: 17)!,
            kTextFont: UIFont(name: "Montserrat", size: 17)!,
            kButtonFont: UIFont(name: "Montserrat", size: 14)!,
            showCloseButton: false,
            dynamicAnimatorActive: false,
            buttonsLayout: .horizontal
        )
        let alert = SCLAlertView(appearance: appearance)
        let textField = alert.addTextField("")
        textField.keyboardType = .decimalPad
        _ = alert.addButton("Aceptar") {function(textField.text!)}
        
        _ = alert.addButton("Cancelar") {}
        
        let ico = UIImage(named:"settings.png")
        let color = UIColor(hexString: "#247D3D")
        
        _ = alert.show
        _ = alert.showCustom("", subTitle: "Configuracion de usuario", color: color, icon: ico!)
    }
    
    //MARK - Custom Info Alert
    func showCustomInfoAlert(function: @escaping () -> Void)
    {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "Montserrat", size: 17)!,
            kTextFont: UIFont(name: "Montserrat", size: 14)!,
            kButtonFont: UIFont(name: "Montserrat", size: 14)!,
            showCloseButton: false,
            showCircularIcon: false,
            dynamicAnimatorActive: false,
            buttonsLayout: .horizontal
        )
        let alert = SCLAlertView(appearance: appearance)
        
        _ = alert.addButton("Aceptar") {function()}
        
        _ = alert.addButton("Cancelar") {}
        
        let ico = UIImage(named:"settings.png")
        let color = UIColor(hexString: "#247D3D")
        
        _ = alert.show
        _ = alert.showCustom("Informacion", subTitle: "Por favor configure un usuario para continuar", color: color, icon: ico!)
    }
    
    func showCustomInfoAlertAndLogin(fun: @escaping (String) -> Void)
    {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "Montserrat", size: 17)!,
            kTextFont: UIFont(name: "Montserrat", size: 14)!,
            kButtonFont: UIFont(name: "Montserrat", size: 14)!,
            showCloseButton: false,
            showCircularIcon: false,
            dynamicAnimatorActive: false,
            buttonsLayout: .horizontal
        )
        let alert = SCLAlertView(appearance: appearance)
        
        _ = alert.addButton("Aceptar") {self.showCustomLoginAlert(function: fun)}
        
        _ = alert.addButton("Cancelar") {}
        
        let ico = UIImage(named:"settings.png")
        let color = UIColor(hexString: "#247D3D")
        
        _ = alert.show
        _ = alert.showCustom("Informacion", subTitle: "Por favor configure un usuario para continuar", color: color, icon: ico!)
    }
    
    //MARK - Custom Error Alert
    func showErrorAlert(errorMessage: String)
    {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("Aceptar"){}
        alertView.showError("Error", subTitle: errorMessage)
    }
}
