import Foundation

class Day: ObservableObject, Identifiable {
    let id = UUID()
    var date: Date
    @Published var blocks: [Block]
    
    init(date: Date, blocks: [Block] = []) {
        self.date = date
        self.blocks = blocks
    }
}
