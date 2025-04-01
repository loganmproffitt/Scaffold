import Foundation

struct Block: BlockLike, Identifiable {
    var id: UUID // Change to UUID
    var name: String
    var descriptionText: String?
    var isComplete: Bool
    var isScheduled: Bool
    var startTime: Date?
    var completionTime: Date?

    var isRigid: Bool
    var duration: Double?

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
