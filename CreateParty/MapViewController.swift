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

    var mapViewControllerDelegate: MapViewControllerDelegate?
    var party = Party()
    
    let annotationIdentifier = "annotationIdentifier"
    let locationManager = CLLocationManager()
    let regionImMeters = 10_000.0
    var incomeSegueIdentifier = ""
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var userLocationButton: UIButton!
    
    @IBOutlet weak var mapMarkerImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addressLabel.text = ""
        mapView.delegate = self
        
        userLocationButton.layer.contents = UIImage(named: "NearMe")?.cgImage
        
        setupMapView()
        checkLocationServices()
    }
    
    @IBAction func centerViewInUserLocation() {
        showUserLocation()
    }
    
    @IBAction func doneButtonPressed() {
        mapViewControllerDelegate?.getAddress(addressLabel.text)
        dismiss(animated: true) 
    }
    
    
    @IBAction func closeVC() {
        dismiss(animated: true) // Закрывает VC и выгружает его из памяти
    }
    
    private func setupMapView() {
        
        if incomeSegueIdentifier == "showParty" {
            setupPartymark()
            mapMarkerImage.isHidden = true
            addressLabel.isHidden = true
            doneButton.isHidden = true
        }
        
    }
    
    private func setupPartymark() {
        
       // guard let location = party.location else { return }
        let location = party.location
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (partymarks, error) in
            
            // Если объект error не содержит nil
            if let error = error {
                print(error)
                return
            }
            
            guard let partymarks = partymarks else { return }
            
            let partymark = partymarks.first
            
            let annotation = MKPointAnnotation()
            
            annotation.title = self.party.name
            annotation.subtitle = self.party.type
            
            guard let partymarkLocation = partymark?.location else { return }
            
            annotation.coordinate = partymarkLocation.coordinate
            
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
            
        }
        
    }
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() { //Данный метод является методом класса и поэтому мы обращаемся к классу, а не к его экземпляру locationManager
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            self.showAlert(title: "Отключены службы геолокации", message: "Для включения перейдите: Настройки -> Конфиденциальность -> Службы геолокации -> Включить")
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // Устанавливаем максимальную точность определения местоположения пользователя
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if incomeSegueIdentifier == "getAddress" { showUserLocation() }
            break
        case .denied:
            // Делаем отсрочку показа Alert на 1 секунду иначе он прогрузится раньше нужного из-за вызова метода из viewDidLoad и не отобразится
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Отсутствует разрешение на определение местоположения", message: "Для выдачи разрешения перейдите: Настройки -> Конфиденциальность -> Службы геолокации -> CreateParty -> При использовании приложения")
            }
            break
        case .restricted, .authorizedAlways:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            print("new case is Available")
        }
    }
    
    private func showUserLocation() {
        
        if let userLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: userLocation,
                                            latitudinalMeters: regionImMeters,
                                            longitudinalMeters: regionImMeters)
            mapView.setRegion(region, animated: true)
        }
        
    }
    
    private func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
        
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default)

        alert.addAction(okAction)
    
        present(alert, animated: true) // present вызывает наш Alert
    }

}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard !(annotation is MKUserLocation) else { return nil }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
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
        let center = getCenterLocation(for: mapView)
        let geocoder = CLGeocoder()
        
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

}

extension MapViewController: CLLocationManagerDelegate {
    
    // Данный метод вызывается при каждом изменении статуса авторизации приложения для использования служб геолокации
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
}
