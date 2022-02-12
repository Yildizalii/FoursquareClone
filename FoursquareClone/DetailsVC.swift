//
//  DetailsVC.swift
//  FoursquareClone
//
//  Created by Ali on 9.02.2022.
//

import UIKit
import MapKit
import Parse
class DetailsVC: UIViewController, MKMapViewDelegate  {
    var chosenPlaceId = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var detailsPlaceLabel: UILabel!
    @IBOutlet weak var detailsTypeLabel: UILabel!
    @IBOutlet weak var detailsAtmosLabel: UILabel!
    @IBOutlet weak var detailsMapView: MKMapView!
        override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromParse()
        detailsMapView.delegate = self
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let okButton = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = okButton
            
        }else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLongitude != 0.0 && self.chosenLatitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                if let placeMark = placemarks {
                    if placeMark.count > 0 {
                        let mkPlacesMark = MKPlacemark(placemark: placeMark[0])
                        let mapItem = MKMapItem(placemark: mkPlacesMark)
                        mapItem.name = self.detailsPlaceLabel.text
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }
    func getDataFromParse() {
        let query = PFQuery.init(className: "Places")
        query.whereKey("objectId", equalTo: chosenPlaceId)
        query.findObjectsInBackground { objects, error in
            if error != nil {
                
            }else {
                if objects != nil {
                    if objects!.count > 0 {
                        let chosenPlaceObject = objects![0]
                        
                        if let placeName =  chosenPlaceObject.object(forKey: "name") as? String {
                            self.detailsPlaceLabel.text = placeName
                        }
                        if let placeType = chosenPlaceObject.object(forKey: "type") as? String {
                            self.detailsTypeLabel.text = placeType
                        }
                        if let placeAtmosphere = chosenPlaceObject.object(forKey: "atmosphere") as? String {
                            self.detailsAtmosLabel.text = placeAtmosphere
                        }
                        if let placeLatitude = chosenPlaceObject.object(forKey: "latitude") as? String {
                            if let placeLatitudeDouble = Double(placeLatitude) {
                                self.chosenLatitude = placeLatitudeDouble
                            }
                            if let placeLongitude = chosenPlaceObject.object(forKey: "longitude") as? String {
                                if let placeLongitude = Double(placeLongitude) {
                                    self.chosenLongitude = placeLongitude
                                }
                                if let imageData = chosenPlaceObject.object(forKey: "image") as? PFFileObject {
                                    imageData.getDataInBackground { data, error in
                                        if error == nil {
                                            if data != nil {
                                                self.detailsImageView.image = UIImage(data: data!)
                                            }
                                        }
                                    }
                                }
                                let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                                let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                                let region = MKCoordinateRegion(center: location, span: span)
                                self.detailsMapView.setRegion(region, animated: true)
                                
                                let annotation = MKPointAnnotation()
                                annotation.coordinate = location
                                annotation.title = self.detailsPlaceLabel.text
                                annotation.subtitle = self.detailsTypeLabel.text
                                self.detailsMapView.addAnnotation(annotation)
                            }
                        }
                    }
                }
            }
        }
    }
    }




