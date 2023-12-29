import UIKit

class TableElementViewController: UIViewController {

    @IBOutlet weak var elementTitle: UILabel!
    
    @IBOutlet weak var placesAmount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func changeTitle(listElement: SavedListItem){
        elementTitle.text = listElement.listName ?? "<no-name>"
        placesAmount.text = String(listElement.locationNumber)
    }
}
