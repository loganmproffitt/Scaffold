import Foundation
import SwiftUI

struct Task: TaskLike, Identifiable {
    var id: UUID
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
    
    init(
           id: UUID = UUID(),
           name: String,
           descriptionText: String? = nil,
           isComplete: Bool = false,
           isScheduled: Bool = false,
           startTime: Date? = nil,
           completionTime: Date? = nil,
           colorHex: String? = nil
       ) {
           self.id = id
           self.name = name
           self.descriptionText = descriptionText
           self.isComplete = isComplete
           self.isScheduled = isScheduled
           self.startTime = startTime
           self.completionTime = completionTime
           self.colorHex = colorHex ?? Task.randomColor()
       }

   static func randomColor() -> String {
       let presetColors = ["#FF9F1C", "#2EC4B6", "#E71D36", "#011627", "#FFBF69"]
       return presetColors.randomElement() ?? "#999999"
   }
}

