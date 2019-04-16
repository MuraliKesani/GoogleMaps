//
//  ListVC.swift
//  Maps181002
//
//  Created by Murali on 3/30/19.
//  Copyright © 2019 Murali. All rights reserved.
//

import UIKit

class ListVC: UIViewController {

    var firstVC:ViewController!
    @IBOutlet var imageVIew: UIImageView!
    
    var picker:UIImagePickerController?=UIImagePickerController()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        picker?.delegate = self
        imageVIew.isUserInteractionEnabled = true
        imageVIew.addGestureRecognizer(tapGestureRecognizer)
        
    }
    

    
    
    
 

}

extension ListVC: UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "THIS DEVICE HAS NO CAMERA", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let alert = UIAlertController(title: nil, message: "OPEN", preferredStyle: .actionSheet)
        let photoLibrary = UIAlertAction(title: "Photo Library", style: UIAlertAction.Style.default) { (action) in
            self.picker?.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(self.picker!, animated: true, completion: nil)
        }
        let camera = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { (action) in
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
               
                self.present(self.picker!, animated: true, completion: nil)
            }else{
                self.noCamera()
            }
            
        }
        let cancel = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel) { (action) in
        }
        alert.addAction(photoLibrary)
        alert.addAction(camera)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageVIew.image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.dismiss(animated: true, completion: nil)
    }
}
