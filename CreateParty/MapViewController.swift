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
    let regionImMeters = 1000.0
    var incomeSegueIdentifier = ""
    var partyCoordinate: CLLocationCoordinate2D?
    var directionsArray: [MKDirections] = []
    var previousLocation: CLLocation? {
        didSet {
            startTrackingUserLocation()
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
        checkLocationServices()
    }
    
    @IBAction func centerViewInUserLocation() {
        showUserLocation()
    }
    
    @IBAction func doneButtonPressed() {
        mapViewControllerDelegate?.getAddress(addressLabel.text)
        dismiss(animated: true) 
    }
    
    @IBAction func goButtonPressed() {
        getDirection()
    }
    
    @IBAction func closeVC() {
        dismiss(animated: true) // Закрывает VC и выгружает его из памяти
    }
    
    private func setupMapView() {
        
        goButton.isHidden = true
        timeAndDistanceLabel.isHidden = true
        timeAndDistanceLabel.text = ""
        
        if incomeSegueIdentifier == "showParty" {
            setupPartymark()
            mapMarkerImage.isHidden = true
            addressLabel.isHidden = true
            doneButton.isHidden = true
            goButton.isHidden = false
            timeAndDistanceLabel.isHidden = false
        }
        
    }
    
    // Метод отменяет все действующие маршруты и удаляет их с карты
    private func resetMapView(withNew directions: MKDirections) {
        
        mapView.removeOverlays(mapView.overlays) // Удаление всех наложений с карты
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() } // Отменем маршрут у каждого элемента массива
        directionsArray.removeAll() // Удаляем все элементы массива
        
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
            self.partyCoordinate = partymarkLocation.coordinate
            
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
    
    private func startTrackingUserLocation() {
        
        guard let previousLocation = previousLocation else { return }
        let center = getCenterLocation(for: mapView)
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showUserLocation()
        }
    }
    
    private func getDirection() {
        
        guard let location = locationManager.location?.coordinate else {
            showAlert(title: "Ошибка", message: "Не удалость определить ваше местоположение")
            return
        }
        
        locationManager.startUpdatingLocation() // Постоянное отслеживание местоположения пользователя
        previousLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        
        guard let request = createDirectionsRequest(from: location) else {
            showAlert(title: "Ошибка", message: "Место назначения не найдено")
            return
        }
        
        let directions = MKDirections(request: request)
        resetMapView(withNew: directions)
        
        directions.calculate { (response, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let response = response else {
                self.showAlert(title: "Ошибка", message: "Маршрут не доступен")
                return
            }
            
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                let distance = String(format: "%.1f",route.distance / 1000)
                let timeInterval = String(format: "%", route.expectedTravelTime / 60)
                
                self.timeAndDistanceLabel.text = "Расстояние до места: \(distance) км. /n Время в пути составит: \(timeInterval) мин."
            }
        }
        
    }
    
    private func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        
        guard let destinationCoordinate = partyCoordinate else { return nil }
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        
        return request
        
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
        
        if incomeSegueIdentifier == "showParty" && previousLocation != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.showUserLocation()
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
        checkLocationAuthorization()
    }
    
}
