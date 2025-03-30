import Foundation

struct Block: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var description: String? = nil
    var startTime: Date? = nil
    var endTime: Date? = nil
    var isTimeSensitive: Bool = false
    var isRigid: Bool = false
    var isCompleted: Bool = false
}
