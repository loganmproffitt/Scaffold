import Foundation
import RealmSwift

class DayObject: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var date: Date
    @Persisted var tasks: List<TaskObject>
    @Persisted var blocks: List<BlockObject>
}

