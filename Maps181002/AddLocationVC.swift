//
//  AddLocationVC.swift
//  Maps181002
//
//  Created by Murali on 3/27/19.
//  Copyright © 2019 Murali. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import MapKit
import CoreData


class AddLocationVC: UIViewController{

    @IBOutlet var longitude: UILabel!
    @IBOutlet var lattitude: UILabel!
    
    
    var firstVC:ViewController!
    
    let locationManager = CLLocationManager()
    var currenLocation:CLLocation?
    var marker:GMSMarker!
    
    var appdelegate:AppDelegate!
    var managedObjectContext:NSManagedObjectContext!
    var locationEntity:NSEntityDescription!
    
    @IBOutlet var mapToView: GMSMapView!
    @IBOutlet var imagePicker: UIImageView!
    var picker:UIImagePickerController?=UIImagePickerController()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        picker?.delegate = self
        
       mapMarker()
        
        mapToView.isMyLocationEnabled = true
        mapToView.settings.compassButton = true
        mapToView.delegate = self
        mapToView.settings.myLocationButton = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imagePicker.isUserInteractionEnabled = true
        imagePicker.addGestureRecognizer(tapGestureRecognizer)
        
        
        appdelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appdelegate.persistentContainer.viewContext
        locationEntity = NSEntityDescription.entity(forEntityName: "Location", in: managedObjectContext)
        
        
    }
    
    
    func savingLocationInCoreData()
    {
        
        let managedObj = NSManagedObject(entity: locationEntity, insertInto: managedObjectContext)

        managedObj.setValue(Double(lattitude.text!), forKey: "latitude")
        managedObj.setValue(Double(longitude.text!), forKey: "longitude")
        
        if let imgData = imagePicker.image!.jpegData(compressionQuality: 1.0)
        {
            managedObj.setValue(imgData, forKey: "image")
        }
        do
        {
            try managedObjectContext.save()
            print("data saved")
        }
        catch
        {
            print("Unable to save")
        }
    }

    @IBAction func onSaveBtnTap(_ sender: UIButton)
    {
       savingLocationInCoreData()
    }
    
}
extension AddLocationVC: CLLocationManagerDelegate,GMSMapViewDelegate{
    
    func mapMarker(){
       
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
      
        
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker)
    {
        print("IS Dragging")
    }
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker)
    {
        longitude.text = "\(marker.position.longitude)"
        lattitude.text = "\(marker.position.latitude)"
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker)
    {
        longitude.text = "\(marker.position.longitude)"
        lattitude.text = "\(marker.position.latitude)"
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if currenLocation == nil
        {
            currenLocation = locations.last
        }
       
                marker = GMSMarker()
                marker.position = currenLocation!.coordinate
                marker.map = mapToView
                marker.title = "ffdgdgdfg"
                //marker.snippet = "retetertert"
                marker.isDraggable = true
        
        let cam = GMSCameraPosition(latitude: currenLocation!.coordinate.latitude, longitude: currenLocation!.coordinate.longitude, zoom: 12.0)
        mapToView.camera = cam
    }
    
}
extension AddLocationVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "THIS DEVICE HAS NO CAMERA", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        let alert = UIAlertController(title: nil, message: "open", preferredStyle: UIAlertController.Style.actionSheet)
        let photo = UIAlertAction(title: "PHOTO LIBRARY", style: UIAlertAction.Style.default) { (action) in
            self.picker!.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(self.picker!, animated: true, completion: nil)
        }
        let camera = UIAlertAction(title: "CAMERA", style: UIAlertAction.Style.default) { (action) in
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                self.present(self.picker!, animated: true, completion: nil)
            }else{
                self.noCamera()
            }
            
            
        }
        let cancel = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel) { (action) in
        }
        alert.addAction(photo)
        alert.addAction(camera)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.dismiss(animated: true, completion: nil)
    }
}
