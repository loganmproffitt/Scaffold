import Foundation

struct BlockWrapper: Identifiable {
    var block: Block
    let uuid = UUID() // new every time
    var id: UUID { uuid } // this is now the sheet trigger
}
