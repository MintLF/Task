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
        func formatTime() -> String {
            if minute < 10 {
                return "\(hour):0\(minute)"
            } else {
                return "\(hour):\(minute)"
            }
        }
        
        func formatDate() -> String {
            if year == Date.now.year {
                if isTheSameDay(as: Date.now) {
                    return "今天"
                }
                if isTheSameDay(as: next(day: 1)) {
                    return "明天"
                }
                return "\(month)月\(day)日"
            }
            return "\(year)年\(month)月\(day)日"
        }
        
        switch style {
        case .time:
            return formatTime()
        case .date:
            return formatDate()
        case .all:
            return "\(formatDate()) \(formatTime())"
        }
    }
    
    func next(day: Int) -> Date {
        return Date(timeIntervalSince1970: Date(year: Date.now.year, month: Date.now.month, day: Date.now.day).timeIntervalSince1970 + Double(day.days()))
    }
    
    func isTheSameDay(as other: Date) -> Bool {
        if self.year == other.year && self.month == other.month && self.day == other.day {
            return true
        }
        return false
    }
    
    func isInTheNextDay(from: Int, to: Int) -> Bool {
        if self > next(day: to) {
            return false
        }
        if self < next(day: from) {
            return false
        }
        return true
    }
    
    func isAfter(day: Int) -> Bool {
        if self >= Date(timeIntervalSince1970: Date(year: Date.now.year, month: Date.now.month, day: Date.now.day).timeIntervalSince1970 + Double(day.days())) {
            return true
        }
        return false
    }
}

extension Int {
    func days() -> Int {
        return self * 24 * 60 * 60
    }
}
