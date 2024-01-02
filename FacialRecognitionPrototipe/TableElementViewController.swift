import UIKit

class TableElementViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var elementTitle: UILabel!
    
    @IBOutlet weak var placesAmount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func changeTitle(listElement: SavedListItem){
        elementTitle.text = listElement.listName ?? "<no-name>"
        placesAmount.text = String(listElement.locationNumber)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}
