
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNoticeButton: UIBarButtonItem!
    
    var model = Model.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.setBadge()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.groupTableViewBackground
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "cell"
        let  cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        let curentItem = self.model.toDoItems[indexPath.row]
        cell.textLabel?.text = curentItem.name
        if curentItem.isComplited {
            cell.imageView?.image = UIImage(named: "check.png")
        } else {
            cell.imageView?.image = UIImage(named: "uncheck.png")
        }
        
        if tableView.isEditing {
            cell.textLabel?.alpha = 0.4
            cell.imageView?.alpha = 0.4
        } else {
            cell.textLabel?.alpha = 1
            cell.imageView?.alpha = 1
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if model.changeState(at: indexPath.row) {
            tableView.cellForRow(at: indexPath)?.imageView?.image = UIImage(named: "check.png")
        } else {
            tableView.cellForRow(at: indexPath)?.imageView?.image = UIImage(named: "uncheck.png")
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.model.removeItem(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            self.model.adItems(name: "new Item")
        }
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        model.moveItems(from: sourceIndexPath.row, to: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .none
        } else {
            return.delete
        }
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    @IBAction func addItem(_ sender: Any) {
        let alertController = UIAlertController(title: "Create new item", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "New item"
        }
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .default) { (alert) in }
        let alertActionCreate = UIAlertAction(title: "Create", style: .cancel) { (alert) in
           let newItem = alertController.textFields![0].text
            if newItem?.count != 0 {
                self.model.adItems(name: newItem!)
                self.tableView.reloadData()
            }
        }
        alertController.addAction(alertActionCancel)
        alertController.addAction(alertActionCreate)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func editAction(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addNofice(_ sender: Any) {
        let isAdd =  Model.requestForNotification()
        if isAdd != nil  {
            addNoticeButton.isEnabled = true
            addNoticeButton.accessibilityElementsHidden = true
        }
    }
}

