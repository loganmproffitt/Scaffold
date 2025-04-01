import Foundation

protocol BlockLike: TaskLike {
    var isRigid: Bool { get set }
    var duration: Double? { get set }
    var endTime: Date? { get }  // computed only
}

extension BlockLike {
    var endTime: Date? {
        guard let start = startTime, let duration = duration else { return nil }
        return start.addingTimeInterval(duration)
    }

    mutating func setEndTime(_ newEndTime: Date) {
        guard let start = startTime else { return }
        duration = newEndTime.timeIntervalSince(start)
    }
}
