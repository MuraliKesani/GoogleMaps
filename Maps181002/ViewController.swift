//
//  ViewController.swift
//  Maps181002
//
//  Created by Murali on 3/27/19.
//  Copyright © 2019 Murali. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreData

class ViewController: UIViewController {
    
    var nameOfWonder = [String]()
    var nameOfCountry:[String]!
    var imageOfWonder = [UIImage]()
    
    
    var lattitudeArray:[Double]!
    var longitudeArray:[Double]!
    var iconImage:[UIImage]!
    var locationADD:AddLocationVC!
    var list:ListVC!
    
    @IBOutlet var listAdd: UIBarButtonItem!
    @IBOutlet var wonderTableView: UITableView!
    
    
    var appdelegate:AppDelegate!
    var managedObjectContext:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameOfWonder = ["Petra","Taj Mahal","Colosseum","Chichén Itzá","Machu Picchu","Christ the Redeemer","Great Wall of China"]
        nameOfCountry = ["Jordan","India","Italy","Mexico","Peru","Brazil","China"]
        lattitudeArray = [30.3285,27.1750,41.8902,20.6843,-13.163136,-22.951916,40.4319]
         longitudeArray = [35.4444,78.0422,12.4922,-88.5718829,-72.5471516,-43.2104872,116.5704]
        imageOfWonder = [#imageLiteral(resourceName: "Petra"),#imageLiteral(resourceName: "Taj Mahal"),#imageLiteral(resourceName: "Colosseum"),#imageLiteral(resourceName: "Chichén Itzá"),#imageLiteral(resourceName: "Machu Picchu"),#imageLiteral(resourceName: "Christ the Redeemer"),#imageLiteral(resourceName: "Great Wall of China")]
        iconImage = [#imageLiteral(resourceName: "petra-1"),#imageLiteral(resourceName: "taj-mahal"),#imageLiteral(resourceName: "colosseum-1"),#imageLiteral(resourceName: "chichen-itza-pyramid"),#imageLiteral(resourceName: "machu-picchu"),#imageLiteral(resourceName: "christ-the-redeemer"),#imageLiteral(resourceName: "great-wall-of-china")]
        
        appdelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appdelegate.persistentContainer.viewContext
    }
    override func viewWillAppear(_ animated: Bool)
    {
        dataRetriveFromCoreData()
    }

    @IBAction func onListAddBtnTapped(_ sender: UIBarButtonItem) {
        list = self.storyboard?.instantiateViewController(withIdentifier: "ListVC") as! ListVC
        list.firstVC = self
        self.navigationController?.pushViewController(list, animated: true)
    }
    @IBAction func onAddBtnTap(_ sender: UIBarButtonItem) {
        locationADD = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationVC") as! AddLocationVC
        locationADD.firstVC = self
        self.navigationController?.pushViewController(locationADD, animated: true)
    }
    
    func dataRetriveFromCoreData()
    {
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        
        
        do{
            let addLocationArray = try managedObjectContext.fetch(fetchReq)
            
            for i in 0..<addLocationArray.count
            {
                let managedObj:NSManagedObject = addLocationArray[i] as! NSManagedObject
                
                //nameOfWonder.append(managedObj.value(forKey: "place") as! String)
                lattitudeArray.append(managedObj.value(forKey: "latitude") as! Double)
                longitudeArray.append(managedObj.value(forKey: "longitude") as! Double)
                
                if let imgData = managedObj.value(forKey: "image") as? Data
                {
                    imageOfWonder.append(UIImage(data: imgData)!)
                }
            }
            wonderTableView.reloadData()
            
            
        }
        catch
        {
         print("Unable to retrive")
        }
    }
    
}

extension ViewController: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return nameOfWonder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = wonderTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = nameOfWonder[indexPath.row]
        cell.detailTextLabel?.text = nameOfCountry[indexPath.row]
        cell.imageView?.image = imageOfWonder[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
      var googleMap = self.storyboard?.instantiateViewController(withIdentifier: "GoogleMapVC") as! GoogleMapVC
        googleMap.firstVC = self
        self.present(googleMap, animated: true) {
            googleMap.marker.position = CLLocationCoordinate2D(latitude: self.lattitudeArray[indexPath.row], longitude: self.longitudeArray[indexPath.row])
            googleMap.marker.map = googleMap.mapView
            
            googleMap.marker.title = self.nameOfWonder[indexPath.row]
            googleMap.marker.snippet = self.nameOfCountry[indexPath.row]
            googleMap.marker.icon = self.iconImage[indexPath.row]
            let camera = GMSCameraPosition(latitude: self.lattitudeArray[indexPath.row], longitude: self.longitudeArray[indexPath.row], zoom: 15)
            googleMap.mapView.camera = camera
        }
    }
}
