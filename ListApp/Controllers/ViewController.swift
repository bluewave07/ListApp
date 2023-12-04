//
//  ViewController.swift
//  ListApp
//
//  Created by Abdulkadir AKYURT on 03.12.23.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    
    var alertController = UIAlertController()
    var data = [NSManagedObject]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetch()
        
    }
    
    
    
    @IBAction func didRemoveBarButtonItemTapped(_ sender: UIBarButtonItem) {
        presentAlert(title: "Uyari",
                     message: "Bütün elemanlar Silinecek Emin Misin !!!",
                     defaultButtonTitle: "Evet",
                     cancelButtonTitle: "Vazgec"){_ in
            self.data.removeAll()
            self.tableView.reloadData()
        }
        
        
    }
    @IBAction func didAddButtonItemTapped(_ sender: UIBarButtonItem) {
        presentAddAlert()
    }
    
    
    
    func presentAddAlert(){
        presentAlert(title: "Yeni Eleman Ekle",
                     message: nil,
                     defaultButtonTitle: "Ekle",
                     cancelButtonTitle: "Vazgec",
                     isTextFieldAvaliable: true,
                     defaultButtonHandler: {_ in
            let text = self.alertController.textFields?.first?.text
            if text != "" {
                //self.data.append((text)!)
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                
                let managedObjectContect = appDelegate?.persistentContainer.viewContext
                
                let entity = NSEntityDescription.entity(forEntityName: "Listitem", in: managedObjectContect!)
                let listItem = NSManagedObject(entity: entity!, insertInto: managedObjectContect)
                
                listItem.setValue(text, forKey: "title")
                try? managedObjectContect?.save()
                
                self.fetch()
            }else{
                self.presentWarningAlert()
            }
        })
      
    }
    
    func presentWarningAlert(){
        presentAlert(title: "Uyari",
                     message: "Liste Elemani Bos Olamaz",
                     cancelButtonTitle: "Tamam")
    }
    
    func presentAlert(title: String?,
                      message: String?,
                      preferredStyle: UIAlertController.Style = .alert,
                      defaultButtonTitle: String? = nil,
                      cancelButtonTitle: String?, isTextFieldAvaliable: Bool = false,
                      defaultButtonHandler: ((UIAlertAction) -> Void)? = nil) {
        
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: preferredStyle)
        
        if defaultButtonTitle != nil {
            let defaultButton = UIAlertAction(title: defaultButtonTitle,
                                              style: .default,
                                              handler: defaultButtonHandler)
            alertController.addAction(defaultButton)
        }
        
        let cancelButton = UIAlertAction(title: cancelButtonTitle,
                                         style: .cancel)
        if isTextFieldAvaliable {
            alertController.addTextField()
        }
        
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true)
    }
    
    func fetch() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedObjectContect = appDelegate?.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Listitem")
        
        data = try! managedObjectContect!.fetch(fetchRequest)
        
        tableView.reloadData()
    }
}





extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        
        let listItem = data[indexPath.row]
        
        cell.textLabel?.text = listItem.value(forKey: "title") as? String
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "Sil") {_, _, _ in
            

            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
            let managedObjectContect = appDelegate?.persistentContainer.viewContext
            
            managedObjectContect?.delete(self.data[indexPath.row])
            try? managedObjectContect?.save()
            self.fetch()
            
            tableView.reloadData()
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Düzenle") {_, _, _ in
            
            
            self.presentAlert(title: "Elemani DÜzenle",
                              message: nil,
                              defaultButtonTitle: "Düzenle",
                              cancelButtonTitle: "Vazgec",
                              isTextFieldAvaliable: true,
                              defaultButtonHandler: {_ in
                let text = self.alertController.textFields?.first?.text
                if text != "" {
                  
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    
                    let managedObjectContect = appDelegate?.persistentContainer.viewContext
                    self.data[indexPath.row].setValue(text, forKey: "title")
                    if managedObjectContect!.hasChanges{
                        try? managedObjectContect?.save()
                    }
                    self.tableView.reloadData()
                }else{
                    self.presentWarningAlert()
                }
            })
            
        }
        
        
        deleteAction.backgroundColor = .systemRed
        let config = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
        
        return config
    }
}

