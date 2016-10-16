import UIKit

extension Date {
    var isToday: Bool { return daysFromNow == 0 }
    var isYesterday: Bool { return daysFromNow == -1 }
}

extension Date {
    fileprivate var daysFromNow: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let fromDate = formatter.date(from: formatter.string(from: NSDate() as Date))
        let toDate = formatter.date(from: formatter.string(from: self as Date))
        
        let calendar = NSCalendar.current
//        let components = calendar.components(.day, from: fromDate!, to: toDate!, options: .WrapComponents)
        let components = calendar.dateComponents([.day], from: fromDate!, to: toDate!)
        
        return components.day!
    }
}
