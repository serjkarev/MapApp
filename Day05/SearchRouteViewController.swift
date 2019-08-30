//
//  SearchRouteViewController.swift
//  Day05
//
//  Created by Alisa Soroka on 4/14/19.
//  Copyright © 2019 SensoramaLab. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class SearchRouteViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: [MKMapItem] = []
    
    var responses: [MKMapItem] = []
    var firstVC: FirstViewController?
    var routeFirst: MKMapItem?
    var routeSecond: MKMapItem?
    var currentSearchBarTag = -1
    
    
    @IBOutlet weak var searchBar1: UISearchBar!
    @IBOutlet weak var searchBar2: UISearchBar!
    
    @IBAction func doneButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        if let first = routeFirst,
        let second = routeSecond {
            firstVC?.showRoute(first: first, second: second)
        }
        
    }
}


extension SearchRouteViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        TestSearch(str: searchText)
//        tableView.isHidden = false;
//        tableView.reloadData()
//        if searchText.isEmpty {
//            tableView.isHidden = true;
//        }
        
        currentSearchBarTag = searchBar.tag
        
        firstVC?.TestSearch(str: searchText, completionHandler: { (routes) in
            self.dataSource = routes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
//
    }
}

extension SearchRouteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentSearchBarTag == 0 {
            routeFirst = dataSource[indexPath.row]
            searchBar1.text = dataSource[indexPath.row].name
            searchBar1.isUserInteractionEnabled = false
            searchBar1.alpha = 0.5
            
        } else if currentSearchBarTag == 1 {
            routeSecond = dataSource[indexPath.row]
            searchBar2.text = dataSource[indexPath.row].name
            searchBar2.isUserInteractionEnabled = false
            searchBar2.alpha = 0.5
        } else {
            print("Error")
        }
    }
}

extension SearchRouteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = dataSource[indexPath.row].name
        return cell
    }
}
