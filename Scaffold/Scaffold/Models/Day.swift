import Foundation

struct Day: Identifiable {
    let id = UUID()
    var date: Date
    var blocks: [Block]
}
