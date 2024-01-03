import Foundation
import MapKit
import Combine

class LocationService {
    
}

extension LocationService {
    static func search(query: String, completion: @escaping ([MKMapItem]) -> ()) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        let search = MKLocalSearch(request: request)

        search.start { response, error in

            if let response = response {
                completion(response.mapItems)
            }
			let latitude = response?.boundingRegion.center.latitude
			let longitude = response?.boundingRegion.center.longitude
			
			let annotation = MKPointAnnotation()
			annotation.title = query
			annotation.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
			self.mapView.addAnnotation(annotation)
        }
    }
}
