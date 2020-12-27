//
//  MapManager.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 10.12.2020.
//

import UIKit
import MapKit

class MapManager {
    let locationManager = CLLocationManager()
    private var partyCoordinate: CLLocationCoordinate2D?
    private let regionImMeters = 1000.0
    private var directionsArray: [MKDirections] = []
   
    
    // Установка маркера вечеринки
    func setupPartymark(party: Party2, mapView: MKMapView) {
        
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
            
            annotation.title = party.name
            annotation.subtitle = party.type
            
            guard let partymarkLocation = partymark?.location else { return }
            
            annotation.coordinate = partymarkLocation.coordinate
            self.partyCoordinate = partymarkLocation.coordinate
            
            mapView.showAnnotations([annotation], animated: true)
            mapView.selectAnnotation(annotation, animated: true)
            
        }
        
    }
    
    // Проверка доступности сервисов геолокации
    func checkLocationServices(mapView: MKMapView, segueIdentifier: String, closure: () -> ()) {
        if CLLocationManager.locationServicesEnabled() { //Данный метод является методом класса и поэтому мы обращаемся к классу, а не к его экземпляру locationManager
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAuthorization(mapView: mapView, segueIdentifier: segueIdentifier)
            closure()
        } else {
            self.showAlert(title: "Отключены службы геолокации", message: "Для включения перейдите: Настройки -> Конфиденциальность -> Службы геолокации -> Включить")
        }
    }
    
    // Проверка авторизации приложения для использования сервисов геолокации
    func checkLocationAuthorization(mapView: MKMapView, segueIdentifier: String) {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if segueIdentifier == "getAddress" { showUserLocation(mapView: mapView) }
            break
        case .denied:
            // Делаем отсрочку показа Alert на 1 секунду иначе он прогрузится раньше нужного из-за вызова метода из viewDidLoad и не отобразится
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Отсутствует разрешение на определение местоположения", message: "Для выдачи разрешения перейдите: Настройки -> Конфиденциальность -> Службы геолокации -> PartyMaker -> При использовании приложения")
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

    // Фокус карты на местоположение пользователя
    func showUserLocation(mapView: MKMapView) {
        
        if let userLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: userLocation,
                                            latitudinalMeters: regionImMeters,
                                            longitudinalMeters: regionImMeters)
            mapView.setRegion(region, animated: true)
        }
        
    }
    
    // Построение маршрута от местоположения пользователя до заведения
    func getDirection(for mapView: MKMapView, previousLocation: (CLLocation) -> (), getTimeAndDistance: @escaping (String) -> ()) {
        
        guard let location = locationManager.location?.coordinate else {
            showAlert(title: "Ошибка", message: "Не удалость определить ваше местоположение")
            return
        }
        
        locationManager.startUpdatingLocation() // Постоянное отслеживание местоположения пользователя
        previousLocation(CLLocation(latitude: location.latitude, longitude: location.longitude))
        
        guard let request = createDirectionsRequest(from: location) else {
            showAlert(title: "Ошибка", message: "Место назначения не найдено")
            return
        }
        
        let directions = MKDirections(request: request)
        resetMapView(mapView: mapView, withNew: directions)
        
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
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                let distance = String(format: "%.1f",route.distance / 1000)
                let timeInterval = String(format: "%", route.expectedTravelTime / 60)
                
                let timeAndDistance = "Расстояние до места: \(distance) км.\n Время в пути: \(timeInterval) м."
                
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    getTimeAndDistance(timeAndDistance)
                }
                
            }
        }
        
    }
    
    // Метод отменяет все действующие маршруты и удаляет их с карты
    func resetMapView(mapView: MKMapView, withNew directions: MKDirections) {
        
        mapView.removeOverlays(mapView.overlays) // Удаление всех наложений с карты
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() } // Отменем маршрут у каждого элемента массива
        directionsArray.removeAll() // Удаляем все элементы массива
        
    }
    
    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        
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
    
    // Изменение отображаемой зоны области карты в соответствии с перемещением пользователя
    func startTrackingUserLocation(for mapView: MKMapView,
                                   and location: CLLocation?,
                                   closure: (_ currentLocation: CLLocation) -> ()) {
        
        guard let location = location else { return }
        let center = getCenterLocation(for: mapView)
        guard center.distance(from: location) > 50 else { return }
        
        closure(center)
        
    }
    
    // Определение центра отображаемой области карты
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
        
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default)

        alert.addAction(okAction)
    
        // Так как мы не наследуемся от view контроллера, нам не доступен present. Поэтому нам нужно создать:
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: true) // present вызывает наш Alert
        
    }
    
}
