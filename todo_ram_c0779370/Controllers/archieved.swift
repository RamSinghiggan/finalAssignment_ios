//
//  archieved.swift
//  todo_ram_c0779370
//
//  Created by rschakar on 6/28/20.
//  Copyright © 2020 ram. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class archieved: UITableViewController {
    var archieve = [Archieved]()
    var folders = [Folder]()
       var selectedNotes: [Notes]? {
           didSet {
              // loadFolders()
           }
       }
    // create a context
       let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

       override func viewDidLoad() {
           super.viewDidLoad()
           // Do any additional setup after loading the view.
       }
     func loadFolder() {
              let request: NSFetchRequest<Archieved> = Archieved.fetchRequest()
              
              do {
                  archieve = try context.fetch(request)
              } catch {
                  print("Error loading folders \(error.localizedDescription)")
              }
              
              tableView.reloadData()
          }
     //MARK: - Action methods
        

        

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return archieve.count
        }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "")
            cell.textLabel?.text = archieve[indexPath.row].name
            cell.backgroundColor = .darkGray
            cell.textLabel?.textColor = .lightGray
            cell.tintColor = .lightText
            return cell
        }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let alert = UIAlertController(title: "Move to \(archieve[indexPath.row].name!)", message: "Are you sure?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Move", style: .default) { (action) in
                for note in self.selectedNotes! {
                   // note.arch = [Archieved]
                }
                self.performSegue(withIdentifier: "dismissMoveToVC", sender: self)
            }
            
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            noAction.setValue(UIColor.orange, forKey: "titleTextColor")
            alert.addAction(yesAction)
            alert.addAction(noAction)
            present(alert, animated: true, completion: nil)
        }
    
    
    
    
        
    @IBAction func addArch(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
        let alert = UIAlertController(title: "Add New Folder", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let folderNames = self.archieve.map {$0.name}
            guard !folderNames.contains(textField.text) else {self.showAlert(); return}
            let newFolder = Archieved(context: self.context)
            newFolder.name = textField.text!
            self.archieve.append(newFolder)
            self.saveFolders()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // change the font color of cancel action
        cancelAction.setValue(UIColor.orange, forKey: "titleTextColor")
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Folder Name"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveFolders() {
            do {
                try context.save()
                tableView.reloadData()
            } catch {
                print("Error saving folders \(error.localizedDescription)")
            }
        }
    
    func showAlert() {
             let alert = UIAlertController(title: "Name Taken", message: "Please choose another name", preferredStyle: .alert)
             let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
             okAction.setValue(UIColor.orange, forKey: "titleTextColor")
             alert.addAction(okAction)
             present(alert, animated: true, completion: nil)
         }
    }



