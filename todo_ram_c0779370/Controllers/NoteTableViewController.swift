//
//  NoteTableViewController.swift
//  Note_FinalProject
//
//  Created by ram singh iggan on 2020-06-21.
//  Copyright © 2020 Geetanjali. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class NoteTableViewController: UITableViewController,UISearchResultsUpdating,UISearchBarDelegate,UNUserNotificationCenterDelegate {
    
        var archieve = [Archieved]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var array = [String]()
    @IBOutlet var searchbar: UISearchBar!
    var filteredArray = [String]()
    var searchController = UISearchController()
    var resultsController = UITableViewController()
    let userNotificationCenter = UNUserNotificationCenter.current()
 
    var notebook : Folder!
   
    @IBOutlet weak var deletebtn: UIBarButtonItem!
    @IBOutlet weak var movebtn: UIBarButtonItem!
    
    var note2 : Notes!
    var editMode: Bool = false
    var issearch=false;
    var searchNote : [Notes] = []
    var notes = [Notes]()
    
       var selectedFolder: Folder? {
           didSet {
               loadNotes()
           }
       }
   
@objc func refresh(sender:AnyObject)
 {
     // Updating your data here...

     self.tableView.reloadData()
     self.refreshControl?.endRefreshing()
 }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
       self.tableView.reloadData()
        self.userNotificationCenter.delegate = self

        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) {
            (granted, error) in
            if granted {
                print("yes")
            } else {
                print("No")
            }
        }
        
        self.searchbar.delegate = self;
        loadNotes()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    
    
    
    @IBAction func btnSort(_ sender: UIBarButtonItem) {
        sortByTitle()
        
    }
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchBar.autocapitalizationType = .none
        filteredArray = array.filter({ (array: String) -> Bool in
            if array.localizedCaseInsensitiveContains(searchController.searchBar.text!) {
                return true
            }
            else{
                return false
            }
        })
        resultsController.tableView.reloadData()
    }
    
    
    
    func sortByTitle() {
        let fetchRequest:NSFetchRequest<Notes> = Notes.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        do {
            self.notes = try context.fetch(fetchRequest)
        }
        catch{
            print(error)
            dismiss(animated: true, completion: nil)
        }
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        let serachDta = notes.filter { $0.title!.lowercased().contains(searchText.lowercased()) || $0.desc!.lowercased().contains(searchText.lowercased())}
        
        if serachDta.count>0
        {
            searchNote  = serachDta;
            issearch = true;
        }
        else
        {
            issearch = false;
        }
        self.tableView.reloadData()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    {
        return true;
    }
    
    
    
    @IBAction func editModePressed(_ sender: UIBarButtonItem) {
        editMode = !editMode
             
             tableView.setEditing(editMode ? true : false, animated: true)
             
             deletebtn.isEnabled = !deletebtn.isEnabled
             movebtn.isEnabled = !movebtn.isEnabled
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableView == resultsController.tableView{
            return filteredArray.count
        }
        else{
            return notes.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == resultsController.tableView {
            let celll = UITableViewCell()
            celll.textLabel?.text = filteredArray[indexPath.row]
            return celll
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell") as! NoteTableViewCell

           let currentDate = NSDate()
            let duedate = notes[indexPath.row].date!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            var convertedDate = dateFormatter.string(from: currentDate as Date)
            
            print(convertedDate,"Curent Date")
              print(duedate,"dueDate")
       
           var date1 = dateFormatter.date(from: duedate)!
            var date2 = dateFormatter.date(from: convertedDate)!
            
            if date2.compare(date1) == ComparisonResult.orderedDescending
            {
                print("Date1 is Later than Date2")
                cell.backgroundColor = .red
                cell.day.text = "OVER DUE"
                
                let content = UNMutableNotificationContent()
                content.categoryIdentifier = "overdue"
                content.title = "Task OverDue"
                content.subtitle = "Some tasks got overdue from todo app"
                content.body = " Notification triggered"
                content.sound = UNNotificationSound.default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
                
                   let request = UNNotificationRequest(identifier: "overdue", content: content, trigger: trigger)
                   
                let center = UNUserNotificationCenter.current()
                center.add(request) { (error : Error?) in
                    if let theError = error {
                        print(theError.localizedDescription)
                    }
                }

                
            }
            else if date2.compare(date1) == ComparisonResult.orderedAscending {
                print("Date1 is Earlier than Date2")
                 cell.backgroundColor = .green
                cell.day.text = "DUE"
                 cell.day.textColor = .black
                
            }
            else if date2.compare(date1) == ComparisonResult.orderedSame {
                print("Same dates")
                 cell.backgroundColor = .cyan
                cell.day.text = "TODAY"
                cell.day.textColor = .black
            }
           cell.dateLbl.text = duedate
           cell.titleLbl.text = notes[indexPath.row].title!

            
            return cell
        }
        
    }

    
    
    override func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let closeAction = UIContextualAction(style: .normal, title:  "Archieve", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
         

               let alert = UIAlertController(title: "Move to Archieved", message: "Are you sure?", preferredStyle: .alert)
               let yesAction = UIAlertAction(title: "Move", style: .default) { (action) in
                
            //    self.notes[indexPath.row] =
                   
                  
               }
               
               let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
               noAction.setValue(UIColor.orange, forKey: "titleTextColor")
               alert.addAction(yesAction)
               alert.addAction(noAction)
            self.present(alert, animated: true, completion: nil)
//           }
            
                print("OK, marked as Closed")
                success(true)
            })
            closeAction.image = UIImage(named: "tick")
            closeAction.backgroundColor = .purple
    
            return UISwipeActionsConfiguration(actions: [closeAction])
    
    }
    
    override func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let modifyAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.deleteNote(note: self.notes[indexPath.row])
            self.saveNotes()
            self.notes.remove(at: indexPath.row)
                               // Delete the row from the data source
                                 tableView.deleteRows(at: [indexPath], with: .fade)
            print("Update action ...")
            success(true)
        })
        modifyAction.image = UIImage(named: "trash")
        modifyAction.backgroundColor = .red
    
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        searchController.searchBar.autocapitalizationType = .none
        
        searchController = UISearchController(searchResultsController: resultsController)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        
        resultsController.tableView.delegate = self
        resultsController.tableView.dataSource = self
      
        loadNotes()
        for note in self.notes {
            let unixTimestamp = note.created/1000;
            let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp));
 
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let strDate = dateFormatter.string(from: date)
            
            
            array.append("Title \(note.title!);Desc \(String(describing: note.desc!));Created \(String(describing: strDate) )")
        }
        searchController.searchBar.autocapitalizationType = .none
        self.loadNotes()
        self.tableView.reloadData()
    }
    
    

        func loadNotes(with request: NSFetchRequest<Notes> = Notes.fetchRequest(), predicate: NSPredicate? = nil) {
        //        let request: NSFetchRequest<Note> = Note.fetchRequest()
                let folderPredicate = NSPredicate(format: "folder.name=%@", selectedFolder!.name!)
                request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
                if let addtionalPredicate = predicate {
                    request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [folderPredicate, addtionalPredicate])
                } else {
                    request.predicate = folderPredicate
                }
                
                do {
                    notes = try context.fetch(request)
                } catch {
                    print("Error loading notes \(error.localizedDescription)")
                }
                
                tableView.reloadData()
            }
    
    
     func deleteNote(note: Notes) {
         context.delete(note)
     }
    
    func movearchieve(note: Notes){
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
             
                  //  note.arch = self.archieve[indexPath.row]
                        //self.performSegue(withIdentifier: "dismissMoveToVC", sender: self)
//                }

            
    }
        func saveNotes() {
            do {
                try context.save()
            } catch {
                print("Error saving the context \(error.localizedDescription)")
            }
        }
        
        //MARK: - update note
    func updateNote(with date:String,title:String,desc:String) {
            notes = []
            let newNote = Notes(context: context)
        newNote.title = title
        newNote.desc = desc
            newNote.date = date
            newNote.folder = selectedFolder
            notes.append(newNote)
            saveNotes()
            loadNotes()
            
        }
        //MARK: - unwind segue
        @IBAction func unwindToNoteTableVC(_ unwindSegue: UIStoryboardSegue) {
    //        let sourceViewController = unwindSegue.source
            // Use data from the view controller which initiated the unwind segue
            
            saveNotes()
            loadNotes()
            tableView.setEditing(false, animated: false)
        }
    
    
    @IBAction func deleteNotes(_ sender: UIBarButtonItem) {
        
        if let indexPaths = tableView.indexPathsForSelectedRows {
            let rows = (indexPaths.map {$0.row}).sorted(by: >)
            
            let _ = rows.map {deleteNote(note: notes[$0])}
            let _ = rows.map {notes.remove(at: $0)}
            
            tableView.reloadData()
            
            saveNotes()
        }
    }
    
    
    
    
    
    
    
    
    
    
     
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
           guard identifier != "moveNoteSegue" else {
               return true
           }
           return editMode ? false : true
       }
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        

        if (segue.identifier == "addNote") {
            let editNoteVC = segue.destination as! AddNoteVC
            editNoteVC.userIsEditing = false
            editNoteVC.folder = selectedFolder
            
        }
        else  if (segue.identifier == "editNote") {
            
            let editNoteVC = segue.destination as! AddNoteVC
            editNoteVC.folder = selectedFolder
            let i = (self.tableView.indexPathForSelectedRow?.row)!
            editNoteVC.note = notes[i]
            
        }
        
        
        if let destination = segue.destination as? Move {
                  if let indexPaths = tableView.indexPathsForSelectedRows {
                      let rows = indexPaths.map {$0.row}
                      destination.selectedNotes = rows.map {notes[$0]}
                  }
              }
    }

}

