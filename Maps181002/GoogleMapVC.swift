//
//  GoogleMapVC.swift
//  Maps181002
//
//  Created by Murali on 3/27/19.
//  Copyright © 2019 Murali. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class GoogleMapVC: UIViewController {

    
    var firstVC:ViewController!
    
    @IBOutlet var mapView: GMSMapView!
    var marker = GMSMarker()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onBackBtnTap(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
