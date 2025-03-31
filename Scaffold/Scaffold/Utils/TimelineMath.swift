import SwiftUI

struct TimelineMath {
    static func dateFrom(hour: Int, minute: Int = 0) -> Date {
        Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date())!
    }

    static func startOfTimelineDate(startHour: Int) -> Date {
        dateFrom(hour: startHour)
    }

    static func yFrom(date: Date, startHour: Int, hourHeight: CGFloat) -> CGFloat {
        let comps = Calendar.current.dateComponents([.hour, .minute], from: date)
        let totalMinutes = ((comps.hour ?? 0) - startHour) * 60 + (comps.minute ?? 0)
        return CGFloat(totalMinutes) / 60 * hourHeight
    }

    static func minutesFrom(y: CGFloat, hourHeight: CGFloat) -> Int {
        Int((y / hourHeight) * 60)
    }

    static func dateFrom(y: CGFloat, startHour: Int, hourHeight: CGFloat) -> Date {
        let minutes = minutesFrom(y: y, hourHeight: hourHeight)
        let start = startOfTimelineDate(startHour: startHour)
        return Calendar.current.date(byAdding: .minute, value: minutes, to: start)!
    }

    static func heightForDuration(start: Date, end: Date, hourHeight: CGFloat) -> CGFloat {
        CGFloat(durationInMinutes(start: start, end: end)) / 60 * hourHeight
    }

    static func durationInMinutes(start: Date, end: Date) -> Int {
        Calendar.current.dateComponents([.minute], from: start, to: end).minute ?? 60
    }

    static func snapped(_ date: Date, interval: Int = 15) -> Date {
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.hour, .minute], from: date)
        let totalMinutes = (comps.hour ?? 0) * 60 + (comps.minute ?? 0)
        let snappedMinutes = Int(round(Double(totalMinutes) / Double(interval))) * interval
        let hour = snappedMinutes / 60
        let minute = snappedMinutes % 60
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: date)!
    }
}
