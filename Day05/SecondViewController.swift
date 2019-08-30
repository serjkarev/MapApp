//
//  SecondViewController.swift
//  Day05
//
//  Created by SensoramaLab on 4/8/19.
//  Copyright © 2019 SensoramaLab. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var personTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        {
            
            cell.textLabel?.text = Model.places[indexPath.row].0
            cell.detailTextLabel?.text = "latitude: \(Model.places[indexPath.row].1), longtitude : \(Model.places[indexPath.row].2)"
            print ("i", indexPath.row)
            return cell
        }
        
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapTab = self.tabBarController?.viewControllers![0] as! FirstViewController
        mapTab.centerMapOnLocation(location: CLLocation(latitude: Model.places[indexPath.row].1, longitude: Model.places[indexPath.row].2))
        self.tabBarController?.selectedIndex = 0
    }
    
}

