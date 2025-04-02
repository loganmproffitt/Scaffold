import Foundation

protocol TaskLike: Identifiable {
    var id: UUID { get }
    var name: String { get set }
    var descriptionText: String? { get set }
    var isComplete: Bool { get set }
    var isScheduled: Bool { get set }
    var startTime: Date? { get set }
    var completionTime: Date? { get set }
    var colorHex: String { get set }
}
