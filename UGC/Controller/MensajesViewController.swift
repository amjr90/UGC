//
//  MensajesViewController.swift
//  UGC
//
//  Created by andres jaramillo on 3/26/18.
//  Copyright © 2018 andres jaramillo. All rights reserved.
//

import UIKit
import SVProgressHUD

struct StrechyHeader
{
    let headerHeight : CGFloat = 200
    let headerCut : CGFloat = 0
}

class MensajesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    @IBOutlet var mensajesTableView: UITableView!
    @IBOutlet var navigationBar: UIView!
    @IBOutlet var infoBarHeightConstant: NSLayoutConstraint!
    @IBOutlet var mensajesTableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var camara: RoundUIView!
    @IBOutlet var infoView: infoUIView!
    @IBOutlet var btnAttatch: UIButton!
    @IBOutlet var btnPhoto: UIButton!
    @IBOutlet var comentarioTextField: UITextField!
    @IBOutlet var comentarioBarConstraint: NSLayoutConstraint!
    
    let apiManager = APIManager()
    var headerView : UIView!
    var newHeaderLayer : CAShapeLayer!
    var usuario:Usuario!
    var info:Info!
    var infoMensajes = [InfoMensaje]()
    var images = [UIImage]()
    var imagenesGeleria = [String]()
    var imagePicker: UIImagePickerController!
    var idMensaje = "idMensaje"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        mensajesTableView.delegate = self
        mensajesTableView.dataSource = self
        
        buscarMensajes()
        
        infoView.labelNombreUsuario.text = info.razonSocial
        infoView.labelDescripcionUsuario.text = info.nombre
        infoView.codigo.text = info.codigo
        infoView.direccion.text = info.direccion
        infoView.ciudad.text = info.ciudad
        infoView.telefono.text = info.telefono
        infoView.barrio.text = info.barrio
        
        setButtonColor(button: btnAttatch)
        setButtonColor(button: btnPhoto)
        
        comentarioTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.hideKeyboard()

        updateView()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    func buscarMensajes()
    {
        apiManager.buscarMensajes(codigoUsuario: usuario.codigousuario, codigoCliente: info.codigo) { (infos) in
            
            self.infoMensajes = infos
            self.mensajesTableView.reloadData()
            self.animateTable()
            
        }
    }
    
    func updateView()
    {
        mensajesTableView.backgroundColor = UIColor.white
        headerView = mensajesTableView.tableHeaderView
        mensajesTableView.tableHeaderView = nil
        mensajesTableView.rowHeight = UITableViewAutomaticDimension
        mensajesTableView.addSubview(headerView)
        
        newHeaderLayer = CAShapeLayer()
        newHeaderLayer.fillColor = UIColor.black.cgColor
        headerView.layer.mask = newHeaderLayer
        
        let newHeight = StrechyHeader().headerHeight - StrechyHeader().headerCut/2
        
        mensajesTableView.contentInset = UIEdgeInsets(top: newHeight, left: 0, bottom: 0, right: 0)
        mensajesTableView.contentOffset = CGPoint(x: 0, y: -newHeight)
        
        infoBarHeightConstant.constant = 0
        setNewView()
    }
    
    func setNewView()
    {
        let newHeight = StrechyHeader().headerHeight - StrechyHeader().headerCut/2
        var getHeaderFrame = CGRect(x: 0, y: -newHeight, width: mensajesTableView.bounds.width, height: StrechyHeader().headerHeight)
        
        if(mensajesTableView.contentOffset.y < newHeight)
        {
            getHeaderFrame.origin.y = mensajesTableView.contentOffset.y
            getHeaderFrame.size.height = -mensajesTableView.contentOffset.y + StrechyHeader().headerCut/2
        }
        headerView.frame = getHeaderFrame
        let cutDirection = UIBezierPath()
        cutDirection.move(to: CGPoint(x: 0, y: 0))
        cutDirection.addLine(to: CGPoint(x: getHeaderFrame.width, y: 0))
        cutDirection.addLine(to: CGPoint(x: getHeaderFrame.width, y: getHeaderFrame.height))
        cutDirection.addLine(to: CGPoint(x: 0, y: getHeaderFrame.height - StrechyHeader().headerCut))
        
        newHeaderLayer.path = cutDirection.cgPath
    }
    
    @IBAction func botonInfo(_ sender: Any)
    {
        UIView.animate(withDuration: 0.3) {
            if(self.infoBarHeightConstant.constant == 100)
            {
                self.infoBarHeightConstant.constant = 0
                self.mensajesTableViewTopConstraint.constant = 0
            }
            else
            {
                self.infoBarHeightConstant.constant = 100
                self.mensajesTableViewTopConstraint.constant = 200
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func botonAtras(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoMensajes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mensajesCell", for: indexPath) as! MensajeTableViewCell
        
        cell.resetImg()
        cell.tituloLabel.text = infoMensajes[indexPath.row].nombreusuario
        cell.textoLabel.text = infoMensajes[indexPath.row].descripcionusuario
        cell.fechaLabel.text = infoMensajes[indexPath.row].fechamensaje
        cell.comentarioLabel.text = infoMensajes[indexPath.row].mensaje
        cell.comentarioCountLabel.text = "\(infoMensajes[indexPath.row].conteo)"
        
        if(infoMensajes[indexPath.row].imagen != "")
        {
            if(self.infoMensajes[indexPath.row].image == nil)
            {
                apiManager.getImageFromUrl(url: infoMensajes[indexPath.row].imagen) { (image) in
                    
                    var scaledImg = UIImage()
                    
                    if(image.size.height > CGFloat(600))
                    {
                        scaledImg = self.resizeImage(image: image, scaleFactor: 0.3)
                        //scaledImg = self.resizeImage2(image: image)
                    }
                    else if(image.size.height < CGFloat(300))
                    {
                        scaledImg = self.resizeImage(image: image, scaleFactor: 2)
                        //scaledImg = self.resizeImage2(image: image)
                    }
                    else
                    {
                        scaledImg = image
                    }
                    
                    self.infoMensajes[indexPath.row].image = scaledImg
                    //cell.imagen.image = self.infoMensajes[indexPath.row].image
                    cell.setMensajeImagen(img: self.infoMensajes[indexPath.row].image)
                    self.mensajesTableView.reloadData()
                    cell.setNeedsLayout()
                }
            }
            else
            {
                //cell.imagen.image = self.infoMensajes[indexPath.row].image
                cell.setMensajeImagen(img: self.infoMensajes[indexPath.row].image)
                cell.layoutIfNeeded()
            }
        }
        else
        {
             cell.resetImg()
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(infoMensajes[indexPath.row].imagen != "")
        {
            idMensaje = infoMensajes[indexPath.row].idmensaje
            performSegue(withIdentifier: "goToGaleria", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "goToGaleria")
        {
            let destinationVC = segue.destination as! GaleriaViewController
            destinationVC.infos = infoMensajes
            destinationVC.idMensaje = idMensaje
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        setNewView()
        let offset = scrollView.contentOffset.y / 220 + 1.2
        cameraButtonAnimation(offsetValue: offset)
        navigationBarAnimation(offsetValue: offset)
    }
    
    func navigationBarAnimation(offsetValue: CGFloat)
    {
        var offset = offsetValue
        if(self.infoBarHeightConstant.constant == 0)
        {
            //print(offset)
            if(offset > 0.8)
            {
                offset = 1
                navigationBar.alpha = offset
            }
            else
            {
                if(offset < 0.25)
                {
                    navigationBar.backgroundColor = UIColor.darkGray
                }
                else
                {
                    navigationBar.backgroundColor = UIColor.init(hexString: "247D3D")
                }
                navigationBar.alpha = offset
            }
        }
        else
        {
            UIView.animate(withDuration: 0.3, animations: {
                self.navigationBar.backgroundColor = UIColor.init(hexString: "247D3D")
                self.navigationBar.alpha = 1
            })
        }
    }
    
    func cameraButtonAnimation(offsetValue: CGFloat)
    {
        let offset = offsetValue
        if(offset > 0 && offset < 0.35)
        {
            UIView.animate(withDuration: 0.3, animations: {
                self.camara.bounds.size = CGSize(width: 50, height: 50)
            })
        }
        else if(offset > 0.35)
        {
            UIView.animate(withDuration: 0.3, animations: {
                self.camara.bounds.size = CGSize(width: 0, height: 0)
            })
        }
    }
    
    func animateTable()
    {
        mensajesTableView.reloadData()
        let cells = mensajesTableView.visibleCells
        
        let tableViewHeight = mensajesTableView.bounds.size.height
        
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

    func setButtonColor(button: UIButton)
    {
        let origImage = button.imageView?.image
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = UIColor(hexString: "209689")
    }
    
    @objc func keyboardWillShow(notification: Notification)
    {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        // do whatever you want with this keyboard height
        
        UIView.animate(withDuration: 0.25) {
            self.comentarioBarConstraint.constant = -(keyboardHeight)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification)
    {
        // keyboard is dismissed/hidden from the screen
        UIView.animate(withDuration: 0.25) {
            self.comentarioBarConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func botonCargarFoto(_ sender: Any)
    {
        openLibrary()
    }
    
    
    @IBAction func botonTomarFoto(_ sender: Any)
    {
        openCamera()
    }
    
    @IBAction func botonEnviarMensaje(_ sender: Any)
    {
        apiManager.enviarMensajeSinImagen(usuario: usuario, info: info, mensaje: comentarioTextField.text!) { (result) in
            self.dismissKeyboard()
            if result == "OK"
            {
                self.buscarMensajes()
            }
            else
            {
                print("error")
            }
        }
    }
    
    func openCamera()
    {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func openLibrary()
    {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        dismiss(animated: true)
        {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            let imageData = UIImageJPEGRepresentation(image,0.0)
            
            self.apiManager.enviarMensajeConImagen(usuario: self.usuario, info: self.info, imgData: imageData!) { (result) in
                self.dismissKeyboard()
                if result == "OK"
                {
                    self.buscarMensajes()
                    SVProgressHUD.dismiss()
                }
                else
                {
                    print("error")
                }
            }
        }
    }
    
    
}

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func resizeImage(image: UIImage, scaleFactor: CGFloat) -> UIImage
    {
        let img = image
        
        let size = __CGSizeApplyAffineTransform(img.size, CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
        
        let hasAlpha = false
        let scale = CGFloat(0.0)
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        img.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let scaledImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImg!
    }
    
    func resizeImage2(image: UIImage) -> UIImage
    {
        let cgImage = image.cgImage
        
        let width = (cgImage?.width)! / 2
        let height = (cgImage?.height)! / 2
        let bitsPerComponent = cgImage?.bitsPerComponent
        let bitsPerRow = cgImage?.bytesPerRow
        let colorSpace = cgImage?.colorSpace
        let bitmapInfo  = cgImage?.bitmapInfo
        
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent!, bytesPerRow: bitsPerRow!, space: colorSpace!, bitmapInfo: (bitmapInfo?.rawValue)!)
        
        context?.interpolationQuality = .high
        
        context?.draw(cgImage!, in: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height)))
        
        let scaledImage = UIImage(cgImage: (context?.makeImage())!)
        return scaledImage
    }
}
