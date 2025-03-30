import Foundation

struct Block: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var description: String?
    var startTime: Date?
    var endTime: Date?
    var isTimeSensitive: Bool
    var isRigid: Bool
    var isCompleted: Bool
}
