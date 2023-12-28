import UIKit

class EditTableViewCell: UITableViewCell {

    // MARK: VARIABLES
    static let identifier = "EditTableViewCell"
    
    @IBOutlet weak var cellName: UILabel!
    
    @IBOutlet weak var cellImage: UIImageView!
    
    static func nib() -> UINib {
        return UINib(nibName: "EditTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureItem(listName: String, imageName: String) {
        cellName.text = listName
        cellImage.image = UIImage(named: imageName)
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cellImage.frame = CGRect(x: 20, y: 5, width: 30, height: 30)
    }
}
