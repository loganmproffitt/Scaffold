import Foundation
import RealmSwift

class BlockObject: TaskObject {
    @Persisted var isRigid: Bool = false     // Whether the block has a fixed duration
    @Persisted var duration: Double = 0.0    // Duration in seconds, optional (instead of endTime)
}
