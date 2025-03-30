import SwiftUI

struct DayView: View {
    @ObservedObject var day: Day
    @State private var activeBlockWrapper: BlockWrapper? = nil

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
                        activeBlockWrapper = BlockWrapper(block: newBlock)
                    },
                    onEditBlock: { block in
                        activeBlockWrapper = BlockWrapper(block: block)
                    },
                    onStartBlock: { block in
                        print("Started block: \(block.name)")
                    },
                    blocks: day.blocks,
                    onMoveBlock: { id, newStart, newEnd in
                        if let index = day.blocks.firstIndex(where: { $0.id == id }) {
                            day.blocks[index].startTime = newStart
                            day.blocks[index].endTime = newEnd
                        }
                    }
                )

                Button(action: {
                    let calendar = Calendar.current
                    let now = Date()
                    let start = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: now)!
                    let end = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: now)!
                    let newBlock = Block(
                        name: "",
                        startTime: start,
                        endTime: end,
                        isTimeSensitive: false,
                        isRigid: false,
                        isCompleted: false
                    )
                    activeBlockWrapper = BlockWrapper(block: newBlock)
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(Color.white)
                        .font(.system(size: 20, weight: .bold))
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                .padding()
            }

            .sheet(item: $activeBlockWrapper) { wrapper in
                let block = wrapper.block
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
                        activeBlockWrapper = nil
                    },
                    onDelete: {
                        day.blocks.removeAll { $0.id == block.id }
                        activeBlockWrapper = nil
                    }
                )
            }
        }
    }
}
