import SwiftUI

struct DayView: View {
    @ObservedObject var day: Day
    
    @State private var activeBlock: Block? = nil
    
    func formattedDate(_ date: Date) -> String {
         let formatter = DateFormatter()
         formatter.dateStyle = .full
         return formatter.string(from: date)
     }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(formattedDate(day.date))
                .font(.title)
                .padding()
            ZStack(alignment: .bottomTrailing) {
                TimelineView(
                    onHourTap: { time in
                        let newBlock = Block(
                            name: "",
                            startTime: time,
                            endTime: Calendar.current.date(byAdding: .minute, value: 60, to: time),
                            isTimeSensitive: false,
                            isRigid: false,
                            isCompleted: false
                        )
                        activeBlock = newBlock
                    },
                    onEditBlock: { block in
                        activeBlock = block
                    },
                    onStartBlock: { block in
                        print("Started block: \(block.name)")
                    },
                    blocks: day.blocks
                )
                
                Button(action: {
                    let now = Date()
                    let newBlock = Block(
                        name: "",
                        startTime: now,
                        endTime: Calendar.current.date(byAdding: .minute, value: 60, to: now),
                        isTimeSensitive: false,
                        isRigid: false,
                        isCompleted: false
                    )
                    activeBlock = newBlock
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(Color.white)
                        .font(.system(size: 20, weight: .bold))
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                }
            }
            .sheet(item: $activeBlock) { block in
                let isNew = !day.blocks.contains(where: { $0.id == block.id })
                BlockCreationView(
                    block: block,
                    isNew: isNew,
                    onSave: { updated in
                        if let index = day.blocks.firstIndex(where: { $0.id == updated.id }) {
                            day.blocks[index] = updated
                        } else {
                            day.blocks.append(updated)
                        }
                        activeBlock = nil
                    },
                    onDelete: {
                        day.blocks.removeAll { $0.id == block.id }
                        activeBlock = nil
                    }
                )
            }

        }
    }
}

