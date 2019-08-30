//
//  LocationSearchTable.swift
//  Day05
//
//  Created by Alisa Soroka on 4/13/19.
//  Copyright © 2019 SensoramaLab. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class LocationSearchTable : UITableViewController {
    var handleMapSearchDelegate:HandleMapSearch? = nil
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
}

extension LocationSearchTable : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}

extension LocationSearchTable
{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return Model.places.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
//        {
//
//            cell.textLabel?.text = Model.places[indexPath.row].0
//            cell.detailTextLabel?.text = "latitude: \(Model.places[indexPath.row].1), longtitude : \(Model.places[indexPath.row].2)"
//            print ("i", indexPath.row)
//            return cell
//        }
//
//
//
//        return UITableViewCell()
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let mapTab = self.tabBarController?.viewControllers![0] as! FirstViewController
//        mapTab.centerMapOnLocation(location: CLLocation(latitude: Model.places[indexPath.row].1, longitude: Model.places[indexPath.row].2))
//        self.tabBarController?.selectedIndex = 0
//    }
}

extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
}
