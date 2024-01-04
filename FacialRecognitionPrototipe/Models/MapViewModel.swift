import SwiftUI
import MapKit
import CoreLocation

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var mapView = MKMapView()

    @Published var region: MKCoordinateRegion!

    @Published var permissionDenied = false

    @Published var searchText: String = ""

    @Published var locations: [Location] = []
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied:
            permissionDenied.toggle()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            manager.requestLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        self.mapView.setRegion(self.region, animated: true)
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
    }
    
    func search() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText

        locations.removeAll()

        MKLocalSearch(request: request).start { response, error in
            guard let result = response else {return}
            var location: CLLocation!

            if self.region != nil {
                location = CLLocation(latitude: self.region.center.latitude, longitude: self.region.center.longitude)
            }

            self.locations = result.mapItems.compactMap({(item) -> Location? in
                let latitude = item.placemark.coordinate.latitude, longitude = item.placemark.coordinate.longitude
                let itemLocation = CLLocation(latitude: latitude, longitude: longitude)
                let dist = location != nil ? location.distance(from: itemLocation) / 1000 : 0
                return Location(place: item.placemark, coordinate: item.placemark.coordinate, dist: dist)
            })
        }
    }
}
