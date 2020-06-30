
import UIKit
import CoreData
import UserNotifications


class AddNoteVC: UIViewController{
    var selectedNote: Notes?
    weak var delegate: NoteTableViewController?
       var selectedFolder: Folder?
    
    @IBOutlet var swipe: UISwipeGestureRecognizer!
    
    @IBOutlet weak var updateBtn: UIBarButtonItem!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet var txttitle: UITextField!
    @IBOutlet var txtDesc: UITextView!
    @IBOutlet weak var locationTF: UILabel!
    @IBOutlet weak var dateSelect: UIDatePicker!
    @IBOutlet weak var showDate: UILabel!
    var listArray = [NSManagedObject]();
    
    var note:Notes!
    var notes = [Notes]()
    var folder : Folder?
    
    var userIsEditing = true
    var context:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            updateBtn.isEnabled=false
       
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        context = appDelegate.persistentContainer.viewContext
       if (userIsEditing == true) {
            updateBtn.isEnabled=true
            saveBtn.isEnabled=false
           txttitle.text = note.title!
           txtDesc.text = note.desc!
           showDate.text = note.date!
  
       }
       else {
           txtDesc.text = ""
          
           
       }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }


    @IBAction func swipeAction(_ sender: UISwipeGestureRecognizer) {
        
        view.endEditing(true)
    }
    
    
    func display_alert(msg_title : String , msg_desc : String ,action_title : String)
    {
        let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: action_title, style: .default)
        {
            (result : UIAlertAction) -> Void in
            _ = self.navigationController?.popViewController(animated: true)
        })
        present(ac, animated: true)
    }

    
    
    
    
    @IBAction func btnSave(_ sender: Any) {

        if (txtDesc.text!.isEmpty) {
            return
        }
        
        
        if (userIsEditing == true) {
            note.desc = txtDesc.text!
        }
        else {
            
            self.note = Notes(context:context)
           note.setValue(Date().currentTimeMillis(), forKey:"created")
            if (txttitle.text!.isEmpty) {
                note.title = "No Title"
              
            
            }
            else{
                note.title = txttitle.text!
                saveBtn.isEnabled=false
                updateBtn.isEnabled=true
            }
            let formatter = DateFormatter()
                         formatter.dateFormat = "dd-MM-yyyy HH:mm"
                         let myString = formatter.string(from: dateSelect.date)
                        
            note.desc = txtDesc.text!
            note.date = myString
            note.folder = self.folder
        }
        
        do {
            try context.save()
            let content = UNMutableNotificationContent()
                           content.categoryIdentifier = "add"
                           content.title = "Task Added"
                           content.subtitle = " todo app"
                           content.body = " Notification triggered"
                           content.sound = UNNotificationSound.default
                           
                           let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 01, repeats: false)
                           
                              let request = UNNotificationRequest(identifier: "add", content: content, trigger: trigger)
                              
                           let center = UNUserNotificationCenter.current()
                           center.add(request) { (error : Error?) in
                               if let theError = error {
                                   print(theError.localizedDescription)
                               }
                           }
            listArray.append(note);
            let alertBox = UIAlertController(title: "Alert", message: "Data Save Successfully", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                self.navigationController?.popViewController(animated: true)
                
            }))
            self.present(alertBox, animated: true, completion: nil)
        }
        catch {
           
            let alertBox = UIAlertController(title: "Error", message: "Error", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
        }
        if (userIsEditing == false) {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
  
    @IBAction func update(_ sender: UIButton) {
   
        
        let formatter = DateFormatter()
   formatter.dateFormat = "dd-MM-yyyy HH:mm"
   let myString = formatter.string(from: dateSelect.date)

        print("button update")
        
     //   print(delegate!.selectedFolder as Any)
          print(selectedFolder as Any)
          print(self.folder as Any)
          print(note.folder as Any)
                   note.title = txttitle.text!
                   note.desc = txtDesc.text!
                   note.date = myString
                   note.folder = self.folder

                  
               do {
                   try context.save()
                   listArray.append(note);
                   let alertBox = UIAlertController(title: "Alert", message: "Data updated Successfully", preferredStyle: .alert)
                   alertBox.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                       self.navigationController?.popViewController(animated: true)

                      // self.datecompare()
                   }))
                   self.present(alertBox, animated: true, completion: nil)
               }
               catch {

                   let alertBox = UIAlertController(title: "Error", message: "Error", preferredStyle: .alert)
                   alertBox.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                   self.present(alertBox, animated: true, completion: nil)
               }
               if (userIsEditing == false) {
                   self.navigationController?.popViewController(animated: true)
               }

    }
    
    func showDialog() {
        let alert = UIAlertController(title: "Note Image", message: "Please add title of  note.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    

    
    
    
    


    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
}
extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
  
    
       
}
