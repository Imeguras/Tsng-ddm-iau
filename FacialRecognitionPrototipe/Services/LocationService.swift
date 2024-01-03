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
        }
    }
}
