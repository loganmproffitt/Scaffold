import Foundation
import RealmSwift

class TaskObject: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var name: String = ""
    @Persisted var descriptionText: String? = nil
    @Persisted var isComplete: Bool = false
    @Persisted var isScheduled: Bool = false
    @Persisted var startTime: Date? = nil
    @Persisted var completionTime: Date? = nil
    @Persisted var colorHex: String = "#FFCC00"
}

