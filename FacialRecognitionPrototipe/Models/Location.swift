import SwiftUI
import MapKit

struct Location: Identifiable {
    var id = UUID().uuidString
    var place: CLPlacemark
    var coordinate: CLLocationCoordinate2D
    var dist: CLLocationDistance
    
    func getLocality() -> String {
        var thoroughfare = place.thoroughfare ?? ""
        if !thoroughfare.isEmpty {
            thoroughfare += ", "
        }
        let locality = thoroughfare + (place.locality ?? "")
        return locality
    }
    
    func getDistance() -> String {
        return String(format:"%.2f", dist) + " km"
    }
    
    func getCaption() -> String {
        return getDistance() + " · " + getLocality()
    }
}
