//
//  FirstViewController.swift
//  Day05
//
//  Created by SensoramaLab on 4/8/19.
//  Copyright © 2019 SensoramaLab. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FirstViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, MKMapViewDelegate, UITableViewDelegate
{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        mapView.delegate = self
        tableView.dataSource = self as? UITableViewDataSource
        locationManager.startUpdatingLocation()
//        self.centerMapOnLocation(location: initialLocation)
        mapView.register(ArtworkMarkerView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        addPins()
       // TestSearch()
        locate()
        
       
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let r : [MKMapItem] = responses
        {
            print ("dlskfj")
            
                return r.count
          
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        {
            if let r : [MKMapItem] = responses
            {
                if (r.count > indexPath.row)
                {
                    print ("dlskfj")
                
                cell.textLabel?.text = r[indexPath.row].name
                //cell.detailTextLabel?.text = "latitude: \(Model.places[indexPath.row].1), longtitude : \(Model.places[indexPath.row].2)"
                cell.detailTextLabel?.text = "test"
                print ("i", indexPath.row)
                return cell
                    
                }
                
            }
            
        }
        
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let r : [MKMapItem] = responses
        {
            if (r.count > indexPath.row)
            {
                print ("tap on row")
                
                mapView.removeAnnotations(mapView.annotations)
                print ("i", indexPath.row)
                let item = r[indexPath.row]
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name
                self.mapView.addAnnotation(annotation)
                
                centerMapOnLocation(location: CLLocation(latitude: item.placemark.coordinate.latitude, longitude: item.placemark.coordinate.longitude))
                
               
                
                
//                var startPoint = MKPlacemark(coordinate: mapView.userLocation.coordinate)
//                var endPoint = MKPlacemark(coordinate: item.placemark.coordinate)
//
//                var startItem = MKMapItem(placemark: startPoint)
//                var endItem = MKMapItem(placemark: endPoint)
//
//                var request = MKDirectionsRequest()
//
//                request.source = startItem
//                request.destination = endItem
//                request.transportType = .automobile //here you can choose a transport type you need
//
//                var direction = MKDirections(request: request)
//
//                direction.calculate(completionHandler: { response, error in
//
//                    if response != nil {
//                        for route in response?.routes ?? [] {
//                            print("Distance : \(route.distance)")
//                        }
//                    }
//
//                })
                /////
                
                mapView.removeOverlays(mapView.overlays)
                print ("go HERE")
                let directionRequest = MKDirections.Request()
                print ("user loc", mapView.userLocation.coordinate.latitude, mapView.userLocation.coordinate.longitude)
                print ("point loc", item.placemark.coordinate.latitude, item.placemark.coordinate.longitude)
                let sourcePlacemark = MKPlacemark(coordinate: mapView.userLocation.coordinate, addressDictionary: nil)
                let destinationPlacemark = MKPlacemark(coordinate: item.placemark.coordinate, addressDictionary: nil)
                let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
                let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
                
                
                directionRequest.source = sourceMapItem
                directionRequest.destination = destinationMapItem
                
                
                directionRequest.transportType = .any
                // Calculate the direction
                let directions = MKDirections(request: directionRequest)
                
                // 8.
                directions.calculate {
                    (response, error) -> Void in
                    
                    guard let response = response else {
                        if let error = error {
                            print("Error: \(error)")
                            let alert = UIAlertController(title: "Alert", message: "Direction not aviable", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                        return
                    }
                    
                    let route = response.routes[0]
                    print("routes dist", response.routes[0].distance)
                    self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
                    
                    let rect = route.polyline.boundingMapRect
                    self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
                }
                 tableView.isHidden = true
            }//let
            
        }
    }
    
    
    func showRoute(first: MKMapItem, second: MKMapItem) {
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        let annotation = MKPointAnnotation()
        annotation.coordinate = first.placemark.coordinate
        annotation.title = first.name
        self.mapView.addAnnotation(annotation)
        
        let annotation1 = MKPointAnnotation()
        annotation1.coordinate = second.placemark.coordinate
        annotation1.title = second.name
        self.mapView.addAnnotation(annotation1)
        
        
        let directionRequest = MKDirections.Request()
        print ("point1 loc", first.placemark.coordinate.latitude, first.placemark.coordinate.longitude)
        print ("point2 loc", second.placemark.coordinate.latitude, second.placemark.coordinate.longitude)
        let sourcePlacemark = MKPlacemark(coordinate: first.placemark.coordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: second.placemark.coordinate, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        
        
        directionRequest.transportType = .any
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 8.
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                    let alert = UIAlertController(title: "Alert", message: "Direction not aviable", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                return
            }
            
            let route = response.routes[0]
            print("routes dist", response.routes[0].distance)
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if let annotationTitle = view.annotation?.title
        {
            print("User tapped on annotation with title: \(annotationTitle!)")
            
            print("tap")
            let l = CLLocation(latitude: view.annotation!.coordinate.latitude, longitude: view.annotation!.coordinate.longitude)
            centerMapOnLocation(location: l)
        }
    }
    
    //    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
    //
    //        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
    //        if (overlay is MKPolyline) {
    //            polylineRenderer.strokeColor = UIColor.blue.withAlphaComponent(0.75)
    //            polylineRenderer.lineWidth = 5
    //        }
    //        return polylineRenderer
    //    }
    //
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        print ("hererrekjekjbnsdknfsd")
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    
    
    
    func showRouteOnMap(coordinate1: CLLocationCoordinate2D, coordinate2: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: coordinate1, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinate2, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            if (unwrappedResponse.routes.count > 0) {
                self.mapView.addOverlay(unwrappedResponse.routes[0].polyline)
                self.mapView.setVisibleMapRect(unwrappedResponse.routes[0].polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    
    
    
    var responses : [MKMapItem]?
    
    func TestSearch(str : String, completionHandler: (([MKMapItem]) -> Void)?)
    {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = str
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
    
        search.start(completionHandler: {(response, error) in
            
            if error != nil
            {
                print("Error occurred in search:\(error!.localizedDescription)")
            } else if response!.mapItems.count == 0
            {
                print("No matches found")
            } else
            {
                print("Matches found")
                
                
                
                self.responses = response!.mapItems
                for item in response!.mapItems {
                    print("Name = \(item.name!)")
                    
                    //print("Phone = \(item.phoneNumber!)")
                }
                
                completionHandler?(response!.mapItems)
            }
        })
    }
    
    func addPins()
    {
        for i in Model.places
        {
            let d = "latitude: \(i.1), longtitude : \(i.2)"
            let c = CLLocationCoordinate2D(latitude: i.1, longitude: i.2)
            let pin = MapPin(title: i.0, locationName: i.0, discipline: d, coordinate: c)
            mapView.addAnnotation(pin)
            
        }
    }

    func locate()
    {
        
        let status  = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if status == .denied || status == .restricted {
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        self.centerMapOnLocation(location: locationManager.location!)
    }
    
    func centerMapOnLocation(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        default:
            mapView.mapType = .hybrid
        }
    }

    @IBAction func onLocateTap(_ sender: Any)
    {
        locate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "serchSegue" {
            if let viewController: SearchRouteViewController = segue.destination as? SearchRouteViewController {
                viewController.firstVC = self
            }
        }
    }
}//FirstViewController end


///////////////////////////////// Map Pin
class MapPin: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    var markerTintColor: UIColor  {
        switch title {
        case "Unit Factory"?:
            return .green
        default:
            return .blue
        }
    }
}
///////////////////////////////// Map Pin end


class ArtworkMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            // 1
            guard let artwork = newValue as? MapPin else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            // 2
            markerTintColor = artwork.markerTintColor
            glyphText = String(artwork.discipline.first!)
        }
    }
}
/////////////////////////////////////////////////////////////////////////////////

//extension FirstViewController: UITableViewDelegate
//{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {
//        return Model.places.count
//    }
//
//    private func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
//        {
//
//            cell.textLabel?.text = Model.places[indexPath.row].0
//            //cell.detailTextLabel?.text = "latitude: \(Model.places[indexPath.row].1), longtitude : \(Model.places[indexPath.row].2)"
//            cell.detailTextLabel?.text = "asf"
//            print ("i", indexPath.row)
//            return cell
//        }
//
//
//
//        return UITableViewCell()
//    }
//}
////////////////////////////////////////////////////////////////////////////////////////

extension FirstViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        //reload data
        //bool ssearching = true
        TestSearch(str: searchText, completionHandler: nil)
        tableView.isHidden = false;
        tableView.reloadData()
        if searchText.isEmpty {
            tableView.isHidden = true;
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////

//extension FirstViewController: MKMapViewDelegate {
//
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
//    {
//        if let annotationTitle = view.annotation?.title
//        {
//            print("User tapped on annotation with title: \(annotationTitle!)")
//            
//                    print("tap")
//            let l = CLLocation(latitude: view.annotation!.coordinate.latitude, longitude: view.annotation!.coordinate.longitude)
//                    centerMapOnLocation(location: l)
//        }
//    }
//
////    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
////
////        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
////        if (overlay is MKPolyline) {
////            polylineRenderer.strokeColor = UIColor.blue.withAlphaComponent(0.75)
////            polylineRenderer.lineWidth = 5
////        }
////        return polylineRenderer
////    }
////
//    private func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
//        let renderer = MKPolylineRenderer(overlay: overlay)
//        print ("hererrekjekjbnsdknfsd")
//        renderer.strokeColor = UIColor.red
//        renderer.lineWidth = 4.0
//
//        return renderer
//    }
//
//    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
//        if overlay is MKPolyline {
//            print ("hererrekjekjbnsdknfsd")
//            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
//            polylineRenderer.strokeColor = UIColor.blue
//            polylineRenderer.lineWidth = 5
//            return polylineRenderer
//        }
//        return nil
//    }
//
////    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
////        if overlay.isKind(of: MKPolyline.self){
////            print ("hererrekjekjbnsdknfsd")
////            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
////            polylineRenderer.fillColor = UIColor.blue
////            polylineRenderer.strokeColor = UIColor.blue
////            polylineRenderer.lineWidth = 5
////        }
////        return MKOverlayRenderer(overlay: overlay)
////    }
//
////    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
////        var polylineRenderer = MKPolylineRenderer(overlay: overlay)
////
////        if polyLineRenderer == nil {
////             print ("hererrekjekjbnsdknfsd")
////            polyLineRenderer = MKPolylineRenderer(overlay: overlay)
////            polyLineRenderer?.strokeColor = GeoKitStyleKit.brandBrightRed
////            polyLineRenderer?.lineWidth = 2.0
////        }
////        return polyLineRenderer!
////    }
////
////    func renderer(for overlay: MKOverlay) -> MKOverlayRenderer? {
////        if overlay.isKind(of: MKPolyline.self){
////            print ("hererrekjekjbnsdknfsd")
////            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
////            polylineRenderer.fillColor = UIColor.blue
////            polylineRenderer.strokeColor = UIColor.blue
////            polylineRenderer.lineWidth = 5
////        }
////        return MKOverlayRenderer(overlay: overlay)
////    }
////
//
//
//}//MKMapViewDelegate
//



