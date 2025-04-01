import SwiftUI

struct DayView: View {
    @ObservedObject var viewModel: DayViewModel
    @State private var activeBlockWrapper: BlockWrapper? = nil

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }

    // Move handler outside of body to avoid @ObservedObject access issues
    private func onMoveBlock(id: UUID, newStart: Date, newEnd: Date) {
        viewModel.updateBlockTime(id: id, newStart: newStart, newEnd: newEnd)
    }

    private func handleSave(for block: Block) -> (Block) -> Void {
        return { updated in
            viewModel.saveBlock(updated)
            activeBlockWrapper = nil
        }
    }

    private func handleDelete(for block: Block) -> () -> Void {
        return {
            viewModel.removeBlock(block)
            activeBlockWrapper = nil
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(formattedDate(viewModel.currentDay.date))
                .font(.title)
                .padding()

            ZStack(alignment: .bottomTrailing) {
                TimelineView(
                    onHourTap: { time in
                        let newBlock = Block(
                            id: UUID(),
                            name: "",
                            descriptionText: nil,
                            isComplete: false,
                            isScheduled: false,
                            startTime: time,
                            completionTime: nil,
                            isRigid: false,
                            duration: 60 * 60  // 1 hour
                        )
                        activeBlockWrapper = BlockWrapper(block: newBlock)
                    },
                    onEditBlock: { block in
                        activeBlockWrapper = BlockWrapper(block: block)
                    },
                    onStartBlock: { block in
                        print("Started block: \(block.name)")
                    },
                    blocks: viewModel.currentDay.blocks,
                    onMoveBlock: onMoveBlock
                )

                Button(action: {
                    let now = Date()
                    let start = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: now)!
                    let newBlock = Block(
                        id: UUID(),
                        name: "",
                        descriptionText: nil,
                        isComplete: false,
                        isScheduled: false,
                        startTime: start,
                        completionTime: nil,
                        isRigid: false,
                        duration: 60 * 60  // 1 hour
                    )
                    activeBlockWrapper = BlockWrapper(block: newBlock)
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                .padding()
            }

            .sheet(item: $activeBlockWrapper) { wrapper in
                let block = wrapper.block
                let isNew = !viewModel.currentDay.blocks.contains(where: { $0.id == block.id })

                BlockCreationView(
                    block: block,
                    isNew: isNew,
                    onSave: handleSave(for: block),
                    onDelete: handleDelete(for: block)
                )
            }
        }
    }
}
