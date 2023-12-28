import UIKit

class SavedListsTableViewCell: UITableViewCell {
    
    // MARK: VARIABLES
    static let identifier = "SavedListsTableViewCell"
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet var itemName: UILabel!
    
    @IBOutlet var adressesNumber: UILabel!
    
    @IBOutlet var savedAdresses: UILabel!
    
    @IBOutlet var editButton: UIButton!
    
    static func nib() -> UINib {
        return UINib(nibName: "SavedListsTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configureItem(listName: String, imageName: String) {
        itemImage.image = UIImage(named: imageName)
        itemImage.contentMode = .scaleToFill
        
        itemName.text = listName
        itemName.textAlignment = .left
        
        //adressesNumber.text = number
        adressesNumber.textAlignment = .left
        
        savedAdresses.textAlignment = .left
        
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        itemImage.frame = CGRect(x: 20, y: 5, width: 30, height: 30)
        itemName.frame = CGRect(x: 60, y: 2, width: 100, height: 20)
        adressesNumber.frame = CGRect(x: 60, y: 22, width: 100, height: 20)
        savedAdresses.frame = CGRect(x: 70, y: 22, width: 100, height: 20)
        editButton.frame = CGRect(x: 300, y: 5, width: 100, height: 20)
    }
}

