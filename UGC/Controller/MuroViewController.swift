//
//  MuroViewController.swift
//  UGC
//
//  Created by andres jaramillo on 3/21/18.
//  Copyright © 2018 andres jaramillo. All rights reserved.
//

import UIKit

class MuroViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var searchTextField: TextFieldBorder!
    @IBOutlet var searchButton: RoundButton!
    @IBOutlet var muroTableView: UITableView!
    @IBOutlet var textFieldBusqueda: UITextField!
    
    @IBOutlet var busquedaLabel: UILabel!
    
    @IBOutlet var messageButton: UIButton!
    @IBOutlet var messageTextField: UILabel!
    
    @IBOutlet var comentarioButton: UIButton!
    @IBOutlet var comentarioTextField: UILabel!
    
    let apiManager = APIManager()
    var usuario = Usuario()
    var infos = [Info]()
    var infoToSend:Info!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InitUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func InitUI()
    {
        muroTableView.delegate = self
        muroTableView.dataSource = self
        muroTableView.register(UINib(nibName:"MuroTableViewCell", bundle: nil), forCellReuseIdentifier: "muroCell")
        configureTableView()
        
        searchTextField.applyDesign()
        searchButton.applyDesign()
        
        messageButton.imageView?.contentMode = .scaleAspectFit
        comentarioButton.imageView?.contentMode = .scaleAspectFit
        setSelected(button: messageButton, text: messageTextField,imageName: "message")
        setUnSelected(button: comentarioButton, text: comentarioTextField,imageName: "comment")
    }
    
    func setSelected(button: UIButton, text: UILabel,imageName: String)
    {
        let origImage = UIImage(named: imageName)
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = UIColor(hexString: "209689")
        text.textColor = UIColor(hexString: "209689")
    }
    
    func setUnSelected(button: UIButton, text: UILabel,imageName: String)
    {
        let origImage = UIImage(named: imageName)
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = UIColor.gray
        text.textColor = UIColor.gray
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "muroCell", for: indexPath) as! MuroTableViewCell
        cell.labelNombre.text = infos[indexPath.row].nombre
        cell.labelNit.text = infos[indexPath.row].nit
        cell.labelCodigoSap.text = infos[indexPath.row].codigo
        cell.labelRazonSocial.text = infos[indexPath.row].razonSocial
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        infoToSend = infos[indexPath.row]
        performSegue(withIdentifier: "goToMensajes", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "goToMensajes")
        {
            let destinationVC = segue.destination as! MensajesViewController
            destinationVC.usuario = usuario
            destinationVC.info = infoToSend
        }
    }
    
    func configureTableView()
    {
        //muroTableView.rowHeight = UITableViewAutomaticDimension
        muroTableView.estimatedRowHeight = 65.5
    }
    
    func animateTable()
    {
        muroTableView.reloadData()
        let cells = muroTableView.visibleCells
        
        let tableViewHeight = muroTableView.bounds.size.height
        
        for cell in cells
        {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        var delayCounter:Double = 0;
        for cell in cells
        {
            UIView.animate(withDuration: 1, delay: delayCounter * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
        
    }
    
    @IBAction func buscarUsuarios(_ sender: Any) {
        textFieldBusqueda.endEditing(true)
        apiManager.buscarUsuario(busqueda: textFieldBusqueda.text!, usuario: usuario.codigousuario) { (info) in
            if(info.count>0)
            {
                self.infos = info
                self.busquedaLabel.text = "Clientes encontrados (\(self.infos.count))"
                self.muroTableView.reloadData()
                self.animateTable()
            }
            else
            {
                //TODO mostrar mensaje
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func botonMensaje(_ sender: Any) {
        setSelected(button: messageButton, text: messageTextField,imageName: "message")
        setUnSelected(button: comentarioButton, text: comentarioTextField,imageName: "comment")
        self.busquedaLabel.text = "Mensajes nuevos (0)"
    }
    
    @IBAction func botonComentarios(_ sender: Any) {
        setUnSelected(button: messageButton, text: messageTextField,imageName: "message")
        setSelected(button: comentarioButton, text: comentarioTextField,imageName: "comment")
        self.busquedaLabel.text = "Comentarios nuevos (0)"
    }
    
    

}






