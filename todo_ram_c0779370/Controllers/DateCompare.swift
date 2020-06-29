//
//  DateCompare.swift
//  Note_FinalProject
//
//  Created by rschakar on 6/26/20.
//  Copyright © 2020 Geetanjali. All rights reserved.
//

import Foundation
import CoreData

class DateCompare {
var date:Date!
    
    func datecompare(){

   // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
      
     let fetchRequest:NSFetchRequest<Notes> = Notes.fetchRequest()
    
    var calendar = Calendar.current
    calendar.timeZone = NSTimeZone.local

    // Get today's beginning & end
    let dateFrom = calendar.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
    let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
    // Note: Times are printed in UTC. Depending on where you live it won't print 00:00:00 but it will work with UTC times which can be converted to local time

    // Set predicate as date being today's date
    let fromPredicate = NSPredicate(format: "%@ >= %@", date as NSDate, dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "%@ < %@", date as NSDate, dateTo as! NSDate)
    let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
    fetchRequest.predicate = datePredicate
 print(datePredicate)
    
    
    }
    
}

