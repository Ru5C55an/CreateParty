//
//  MapViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 08.12.2020.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate {
    func getAddress(_ address: String?)
}

enum incomeIdentifier: String {
    case showParty = "showParty"
    case getAddress = "getAddress"
}

class MapViewController: UIViewController {
    
    var party: Party
    var incomeIdentifier = ""
    
    init(currentParty: Party, incomeIdentifier: incomeIdentifier) {
        
        self.party = currentParty
        self.incomeIdentifier = incomeIdentifier.rawValue
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    let mapManager = MapManager()
    var mapViewControllerDelegate: MapViewControllerDelegate?
    
    let annotationIdentifier = "annotationIdentifier"
    
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
    
    let mapView = MKMapView()
    
    let mapMarkerImage = UIImageView(image: UIImage(named: "Marker"))
    let addressLabel = UILabel(text: "")
    let timeAndDistanceLabel = UILabel(text: "")
    
    let userLocationButton = UIButton()
    let closeButton = UIButton(type: .close)
    let doneButton = UIButton(title: "Готово", titleColor: .green, backgroundColor: .white)
    let goButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressLabel.text = ""
        mapView.delegate = self
        
        userLocationButton.layer.contents = UIImage(named: "NearMe")?.cgImage
        userLocationButton.addTarget(self, action: #selector(centerViewInUserLocation), for: .touchUpInside)
        
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        
        goButton.layer.contents = UIImage(named: "GPS")?.cgImage
        goButton.addTarget(self, action: #selector(goButtonPressed), for: .touchUpInside)
        
        closeButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        
        setupMapView()
        setupConstraints()
        
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        //        navigationItem.hidesSearchBarWhenScrolling = false
        //                searchController.hidesNavigationBarDuringPresentation = false
        //                searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Москва, ул. Твордовского, д. 5"
        
        definesPresentationContext = true // Позволяет отпустить строку поиска, при переходе на другой экран
        searchController.searchBar.delegate = self
    }
    
    @objc private func centerViewInUserLocation() {
        
        mapManager.showUserLocation(mapView: mapView)
    }
    
    @objc private func doneButtonPressed() {
        
        mapViewControllerDelegate?.getAddress(addressLabel.text)
        dismiss(animated: true) 
    }
    
    @objc private func goButtonPressed() {
        
        mapManager.getDirection(for: mapView) { (location) in
            previousLocation = location
        } getTimeAndDistance: { (timeAndDistance) in
            self.timeAndDistanceLabel.text = timeAndDistance
        }
    }
    
    @objc private func closeVC() {
        dismiss(animated: true) // Закрывает VC и выгружает его из памяти
    }
    
    private func setupMapView() {
        
        goButton.isHidden = true
        timeAndDistanceLabel.isHidden = true
        timeAndDistanceLabel.text = ""
        
        mapManager.checkLocationServices(mapView: mapView, segueIdentifier: incomeIdentifier) {
            mapManager.locationManager.delegate = self
        }
        
        if incomeIdentifier == "showParty" {
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

// MARK: - Setup constraints
extension MapViewController {
    
    private func setupConstraints() {
        
        view.addSubview(mapView)
        mapView.addSubview(closeButton)
        mapView.addSubview(doneButton)
        mapView.addSubview(goButton)
        mapView.addSubview(userLocationButton)
        mapView.addSubview(mapMarkerImage)
        mapView.addSubview(timeAndDistanceLabel)
        mapView.addSubview(addressLabel)
        
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        goButton.translatesAutoresizingMaskIntoConstraints = false
        userLocationButton.translatesAutoresizingMaskIntoConstraints = false
        mapMarkerImage.translatesAutoresizingMaskIntoConstraints = false
        timeAndDistanceLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 64),
            closeButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -32)
        ])
        
        NSLayoutConstraint.activate([
            timeAndDistanceLabel.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 128),
            timeAndDistanceLabel.centerXAnchor.constraint(equalTo: mapView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 128),
            addressLabel.centerXAnchor.constraint(equalTo: mapView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            doneButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -128),
            doneButton.centerXAnchor.constraint(equalTo: mapView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            goButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -88),
            goButton.centerXAnchor.constraint(equalTo: mapView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            userLocationButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -44),
            userLocationButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -124)
        ])
        
        NSLayoutConstraint.activate([
            mapMarkerImage.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            mapMarkerImage.centerYAnchor.constraint(equalTo: mapView.centerYAnchor, constant: -20)
        ])
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard !(annotation is MKUserLocation) else { return nil }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation,
                                                 reuseIdentifier: annotationIdentifier)
            
            annotationView?.canShowCallout = true // Включение отображения
        }

        // ToDO add image to party
//        if let imageData = party.imageUrlString {
//            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//            imageView.layer.cornerRadius = 10
//            imageView.clipsToBounds = true
//            imageView.image = UIImage(data: imageData)
//            annotationView?.rightCalloutAccessoryView = imageView
//        }

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapManager.getCenterLocation(for: mapView)
        let geocoder = CLGeocoder()
        
        if incomeIdentifier == "showParty" && previousLocation != nil {
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

// MARK: - CLLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    // Данный метод вызывается при каждом изменении статуса авторизации приложения для использования служб геолокации
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        mapManager.checkLocationAuthorization(mapView: mapView,
                                              segueIdentifier: incomeIdentifier)
    }
}

// MARK: - UISearchBarDelegate
extension MapViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        mapManager.checkSearchLocation(location: searchText, mapView: mapView)
    }
}

// MARK: - SwiftUI
import SwiftUI

struct MapViewControllerProvider: PreviewProvider {
    
    static var previews: some View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let mapViewController = MapViewController(currentParty: Party(location: "", userId: "", imageUrlString: "", type: "", maximumPeople: "", currentPeople: "", id: "", date: "", startTime: "", endTime: "", name: "", price: "", description: "", alco: ""), incomeIdentifier: .getAddress)
        
        func makeUIViewController(context: Context) -> MapViewController {
            return mapViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
