
import UIKit

class NoteTableViewCell: UITableViewCell {

       @IBOutlet weak var createdLbl: UILabel!
       @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
       override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
       }

       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)

          
       }

   }

