import Foundation

struct Task: TaskLike, Identifiable {
    var id: UUID
    var name: String
    var descriptionText: String?
    var isComplete: Bool
    var isScheduled: Bool
    var startTime: Date?
    var completionTime: Date?
}

