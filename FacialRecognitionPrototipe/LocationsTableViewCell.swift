import UIKit

class LocationsTableViewCell: UITableViewCell {

    // MARK: VARIABLES
    static let identifier = "LocationsTableViewCell"
    
    @IBOutlet weak var cellName: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "LocationsTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureItem(locationName: String) {
        cellName.text = locationName
        layoutSubviews()
    }
}
