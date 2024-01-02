import UIKit
import SwiftUI

class GuardadoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: VARIABLES
    @IBOutlet weak var CreateListButton: UIButton!
    
    @IBOutlet weak var ListTableView: UITableView!
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private var models = [SavedListItem]()
    
    // MARK: HELPER FUNCTIONS
    @IBAction func PressButton(_ sender: UIButton) {
        let point = sender.superview?.convert(sender.center, to: self.ListTableView) ?? CGPoint.zero
        guard let indexPath = self.ListTableView.indexPathForRow(at: point) else {return}
        
        let sheet = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
            self.deleteItem(indexPath: indexPath)
        }))
        
        present(sheet, animated: true)
    }

    @IBAction func CreateNewList(_ sender: Any) {
        let alert = UIAlertController(title: "Nova lista", message: "Atribua um nome a esta lista.", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self]_ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            
            self?.createItem(name: text)
        }))
        
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = models[indexPath.row]
        guard let cell = ListTableView.dequeueReusableCell(withIdentifier: EditTableViewCell.identifier, for: indexPath) as? EditTableViewCell else {return UITableViewCell()}
        cell.configureItem(listName: model.listName ?? "<no_name>", imageName: "star")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = models[indexPath.row]
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        
        let controller = story.instantiateViewController(identifier: "TableElementViewController") as! TableElementViewController
        //controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
        
        
        controller.changeTitle(listElement: model)
    }
    
    func getAllListItems() -> [SavedListItem] {
        do {
            return try context.fetch(SavedListItem.fetchRequest())
        }
        catch {
            return []
        }
    }
    
    func getAllListItemsAndRefresh() {
        models = getAllListItems()
        
        DispatchQueue.main.async {
            self.ListTableView.reloadData()
            self.ListTableView.layoutSubviews()
        }
    }

    func createItem(name: String) {
        let newItem = SavedListItem(context: context)
        newItem.listName = name
        newItem.locationNumber = 0
        models.append(newItem)
        
        self.ListTableView.beginUpdates()
        self.ListTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        self.ListTableView.endUpdates()
        
        saveListItem()
    }

    func deleteItem(indexPath: IndexPath) {
        do {
            let deletedItem = models[indexPath.row]
            context.delete(deletedItem)
            models.remove(at: indexPath.row)
            try context.save()
        } 
        catch {
        }
        self.ListTableView.deleteRows(at:[indexPath], with:.fade)
    }
    
    func saveListItem() {
        do {
            try context.save()
            getAllListItemsAndRefresh()
        }
        catch {
        }
    }

    func updateListItem(item: SavedListItem, newName: String) {
        item.listName = newName
        
        saveListItem()
    }
    
    func deleteAllListItems() {
        do {
            for i in 0...1  {
                context.delete(models[i])
                
                saveListItem()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllListItemsAndRefresh()
        //deleteAllListItems()
        ListTableView.delegate = self
        ListTableView.dataSource = self
    }
}
