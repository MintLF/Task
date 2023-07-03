import SwiftUI

extension Date {
    enum DateFormatStyle {
        case time
        case date
        case all
    }
    
    init(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0) {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        let calendar = Calendar(identifier: .gregorian)
        self = calendar.date(from: components)!
    }
    
    var day: Int {
        return Calendar.current.component(Calendar.Component.day, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(Calendar.Component.month, from: self)
    }
    
    var year: Int {
        return Calendar.current.component(Calendar.Component.year, from: self)
    }
    
    var hour: Int {
        return Calendar.current.component(Calendar.Component.hour, from: self)
    }
    
    var minute: Int {
        return Calendar.current.component(Calendar.Component.minute, from: self)
    }
    
    var weekdayOfTheFirstDayOfTheMonth: Int {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        var comp = calendar.dateComponents([.year, .month, .day], from: self)
        comp.day = 1
        let firstDayInMonth = calendar.date(from: comp)!
        let weekday = calendar.ordinality(of: Calendar.Component.weekday, in: Calendar.Component.weekOfMonth, for: firstDayInMonth)
        return weekday! - 1
    }
    
    var daysInMonth: Int {
        return Calendar.current.range(of: Calendar.Component.day, in: Calendar.Component.month, for: self)!.count
    }
    
    func getNextMonthDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = 1
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    func getLastMonthDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = -1
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }

    func format(_ style: DateFormatStyle = .all) -> String {
        switch style {
        case .time:
            if self.minute < 10 {
                return "\(self.hour):0\(self.minute)"
            } else {
                return "\(self.hour):\(self.minute)"
            }
        case .date:
            return "\(self.year)年\(self.month)月\(self.day)日"
        case .all:
            if self.minute < 10 {
                return "\(self.year)年\(self.month)月\(self.day)日 \(self.hour):0\(self.minute)"
            } else {
                return "\(self.year)年\(self.month)月\(self.day)日 \(self.hour):\(self.minute)"
            }
        }
    }
}
