//
//  MapViewController.swift
//  CreateParty
//
//  Created by Руслан Садыков on 08.12.2020.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate {
    func getAddress(_ address: String?)
}


class MapViewController: UIViewController {
    
    let mapManager = MapManager()
    var mapViewControllerDelegate: MapViewControllerDelegate?
    var party = Party2()
    
    let annotationIdentifier = "annotationIdentifier"
    
    var incomeSegueIdentifier = ""
    
    
    var previousLocation: CLLocation? {
        didSet {
            mapManager.startTrackingUserLocation(for: mapView, and: previousLocation) { (currentLocation) in
                self.previousLocation = currentLocation
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.mapManager.showUserLocation(mapView: self.mapView)
                }
            }
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var userLocationButton: UIButton!
    
    @IBOutlet weak var mapMarkerImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var timeAndDistanceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addressLabel.text = ""
        mapView.delegate = self
        
        userLocationButton.layer.contents = UIImage(named: "NearMe")?.cgImage
        goButton.layer.contents = UIImage(named: "GPS")?.cgImage
        
        setupMapView()
    }
    
    @IBAction func centerViewInUserLocation() {
        mapManager.showUserLocation(mapView: mapView)
    }
    
    @IBAction func doneButtonPressed() {
        mapViewControllerDelegate?.getAddress(addressLabel.text)
        dismiss(animated: true) 
    }
    
    @IBAction func goButtonPressed() {
        mapManager.getDirection(for: mapView) { (location) in
            previousLocation = location
        } getTimeAndDistance: { (timeAndDistance) in
            self.timeAndDistanceLabel.text = timeAndDistance
        }

    }
    
    @IBAction func closeVC() {
        dismiss(animated: true) // Закрывает VC и выгружает его из памяти
    }
    
    private func setupMapView() {
        
        goButton.isHidden = true
        timeAndDistanceLabel.isHidden = true
        timeAndDistanceLabel.text = ""
        
        mapManager.checkLocationServices(mapView: mapView, segueIdentifier: incomeSegueIdentifier) {
            mapManager.locationManager.delegate = self
        }
        
        if incomeSegueIdentifier == "showParty" {
            mapManager.setupPartymark(party: party, mapView: mapView)
            mapMarkerImage.isHidden = true
            addressLabel.isHidden = true
            doneButton.isHidden = true
            goButton.isHidden = false
            timeAndDistanceLabel.isHidden = false
        }
        
    }
    
    deinit {
        print("deinit", MapViewController.self)
    }

}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard !(annotation is MKUserLocation) else { return nil }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation,
                                                 reuseIdentifier: annotationIdentifier)
            
            annotationView?.canShowCallout = true // Включение отображения
        }

        if let imageData = party.imageData {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageData)
            annotationView?.rightCalloutAccessoryView = imageView
        }

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapManager.getCenterLocation(for: mapView)
        let geocoder = CLGeocoder()
        
        if incomeSegueIdentifier == "showParty" && previousLocation != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.mapManager.showUserLocation(mapView: self.mapView)
            }
        }
        
        geocoder.cancelGeocode() // Для оптимизации
        
        geocoder.reverseGeocodeLocation(center) { (partymarks, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let partymarks = partymarks else { return }
            
            let partymark = partymarks.first
            let streetName = partymark?.thoroughfare
            let buildNumber = partymark?.subThoroughfare
            
            DispatchQueue.main.async {
                if streetName != nil && buildNumber != nil {
                    self.addressLabel.text = "\(streetName!), \(buildNumber!)"
                } else if streetName != nil {
                    self.addressLabel.text = "\(streetName!)"
                } else {
                    self.addressLabel.text = ""
                }
                
            }
            
        }
    }

    // Для отображения наложения маршрута его необходимо отрендерить
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .orange
        
        return renderer
        
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    // Данный метод вызывается при каждом изменении статуса авторизации приложения для использования служб геолокации
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        mapManager.checkLocationAuthorization(mapView: mapView,
                                              segueIdentifier: incomeSegueIdentifier)
    }
    
}
