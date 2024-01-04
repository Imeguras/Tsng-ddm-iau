import UIKit
import MapKit
// MARK: Combine framework to watch textfield change
import Combine
import CoreLocation

class TableElementViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var elementTitle: UILabel!
    
    @IBOutlet weak var placesAmount: UILabel!
    
    @IBOutlet weak var LocationsTableView: UITableView!
    
    var cancellable: AnyCancellable?
    
    var searchText: String = ""
    var fetchedPlaces: [CLPlacemark]?
    
    var listReference = SavedListItem()
    
    var places = 0
    
    private var locationsContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var locationsModels = [LocationList]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = locationsModels[indexPath.row]
        guard let cell = LocationsTableView.dequeueReusableCell(withIdentifier: LocationsTableViewCell.identifier, for: indexPath) as? LocationsTableViewCell else {return UITableViewCell()}
        cell.configureItem(locationName: model.locationName ?? "<location-not-found>")
        
        return cell
    }
    
    @IBAction func addItemPressed(_ sender: Any) {
        createLocation(name: "teste")
    }
    
    @IBAction func deleteElementPressed(_ sender: Any) {
        let point = (sender as AnyObject).superview?.convert((sender as AnyObject).center, to: self.LocationsTableView) ?? CGPoint.zero
        guard let indexPath = self.LocationsTableView.indexPathForRow(at: point) else {return}
        
        let sheet = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
            self.deleteLocation(indexPath: indexPath)
        }))
        
        present(sheet, animated: true)
    }
    
    func getAllLocationsItems() -> [LocationList] {
        do {
            return try locationsContext.fetch(LocationList.fetchRequest())
        }
        catch {
            return []
        }
    }
    
    func getAllLocationsAndRefresh() {
        locationsModels = getAllLocationsItems()
        
        DispatchQueue.main.async {
            self.LocationsTableView.reloadData()
            self.LocationsTableView.layoutSubviews()
        }
    }

    func saveListItem() {
        do {
            try locationsContext.save()
            getAllLocationsAndRefresh()
        }
        catch {
        }
    }
    
    func createLocation(name: String) {
        let newLocation = LocationList(context: locationsContext)
        newLocation.locationName = name
        locationsModels.append(newLocation)
        
        self.LocationsTableView.beginUpdates()
        self.LocationsTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        self.LocationsTableView.endUpdates()
        
        saveListItem()
        changePlacesAmount(increaseValue: true)
    }
    
    func deleteLocation(indexPath: IndexPath) {
        do {
            let deletedItem = locationsModels[indexPath.row]
            locationsContext.delete(deletedItem)
            locationsModels.remove(at: indexPath.row)
            try locationsContext.save()
        }
        catch {
        }
        self.LocationsTableView.deleteRows(at:[indexPath], with:.fade)
        changePlacesAmount(increaseValue: false)
    }
    
    func changeDetails(listElement: SavedListItem){
        elementTitle.text = listElement.listName ?? "<no-name>"
        placesAmount.text = String(listElement.locationNumber)
        
        listReference = listElement
        places = Int(listElement.locationNumber)
    }
    
    func changePlacesAmount(increaseValue: Bool){
        increaseValue == true ? (places += 1) : (places -= 1)
        
        listReference.locationNumber = Int32(places)
        placesAmount.text = String(places)
    }
    
    func fetchPlaces (value: String){
        // MARK: Fetching places using MKLocalSearch and Asyc/Await
        Task {
            do {
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = value.lowercased()
                
                let response = try await MKLocalSearch(request: request).start()
                
                await MainActor.run(body: {
                    self.fetchedPlaces = response.mapItems.compactMap({ item -> CLPlacemark? in
                        return item.placemark
                        
                    })
                })
            }
            catch {
                // HANDLE ERROR
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Bool){
        // HANDLE ERROR
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllLocationsAndRefresh()
        LocationsTableView.delegate = self
        LocationsTableView.dataSource = self
    }
}
