import Foundation
import SwiftUI

struct Block: BlockLike, Identifiable {
    var id: UUID // Change to UUID
    var name: String
    var descriptionText: String?
    var isComplete: Bool
    var isScheduled: Bool
    var startTime: Date?
    var completionTime: Date?
    var colorHex: String
    var color: Color {
        Color(hex: colorHex)
    }

    var isRigid: Bool
    var duration: Double?
    
    init(
           id: UUID = UUID(),
           name: String,
           descriptionText: String? = nil,
           isComplete: Bool = false,
           isScheduled: Bool = false,
           startTime: Date? = nil,
           completionTime: Date? = nil,
           colorHex: String? = nil,
           isRigid: Bool = false,
           duration: Double? = 60
       ) {
           self.id = id
           self.name = name
           self.descriptionText = descriptionText
           self.isComplete = isComplete
           self.isScheduled = isScheduled
           self.startTime = startTime
           self.completionTime = completionTime
           self.colorHex = colorHex ?? ColorUtils.randomHexColor()
           self.isRigid = isRigid
           self.duration = duration
       }

    // Computed property
    var endTime: Date? {
        guard let start = startTime, let duration = duration else { return nil }
        return start.addingTimeInterval(duration)
    }

    mutating func setEndTime(_ newEndTime: Date) {
        guard let start = startTime else { return }
        duration = newEndTime.timeIntervalSince(start)
    }
}
