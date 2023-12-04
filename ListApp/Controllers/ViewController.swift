//
//  ViewController.swift
//  ListApp
//
//  Created by Abdulkadir AKYURT on 03.12.23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var alertController = UIAlertController()
    var data = [String]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
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
                self.data.append((text)!)
                self.tableView.reloadData()
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
}

