
import UIKit
import Foundation
import UserNotifications

let toDoItemsKey = "ToDoDataKey"

class Item: NSObject {
    var name: String
    var isComplited: Bool
    
    override init() {
        self.name = "new"
        self.isComplited = false
    }
    
     init(name: String, isComplited: Bool) {
        self.name = name
        self.isComplited = isComplited
    }
}

class Model: NSObject {
    var toDoItems: [Item] = []
    
    override init() {
        super.init()
        loadData()
    }
    
    func adItems (name: String) {
        self.toDoItems.append(Item.init(name: name, isComplited: false))
        saveData()
        setBadge()
    }
    
    func removeItem (at Index: Int) {
        self.toDoItems.remove(at: Index)
        saveData()
        setBadge()
    }
    
    func complit(at index: Int) {
        self.toDoItems[index].isComplited = true
    }
    
    func changeState (at Item: Int) -> Bool {
        self.toDoItems[Item].isComplited = !self.toDoItems[Item].isComplited
        saveData()
        return self.toDoItems[Item].isComplited
    }
    
    func moveItems (from: Int, to: Int) {
        toDoItems.swapAt(from, to)
        saveData()
    }
    
    func saveData() {
        var savedDictionary = [String: Bool] ()
        for item in toDoItems {
            savedDictionary[item.name] = item.isComplited
        }
        UserDefaults.standard.set(savedDictionary, forKey: toDoItemsKey)
    }
    
    func loadData() {
        let loadDictionary = UserDefaults.standard.value(forKey: toDoItemsKey) as! [String: Bool]?
        if let loadDictionary = loadDictionary {
            for (name, isComplited) in loadDictionary {
                toDoItems.append(Item(name: name, isComplited: isComplited))
            }
        }
    }
    
    func setBadge() {
        var totalBadgeNumber = 0
        for item in toDoItems {
            if !item.isComplited {
                totalBadgeNumber += 1
            }
        }
        UIApplication.shared.applicationIconBadgeNumber = totalBadgeNumber
    }
    
    static func requestForNotification() -> Bool! {
        var addNotice: Bool? = nil
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) { (isEnabled , error) in
            if isEnabled {
                addNotice = true
            } else {
                addNotice = false
            }
        }
        return addNotice
    }
}


