import Foundation

protocol DayLike {
    var id: UUID { get }  // Use UUID instead of String
    var date: Date { get set }
    var tasks: [any TaskLike] { get set }
    var blocks: [any BlockLike] { get set }
}
