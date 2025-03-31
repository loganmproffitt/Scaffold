import SwiftUI

struct BlockView: View {
    var block: Block
    var overrideStartTime: Date? = nil
    var overrideEndTime: Date? = nil
    var onEdit: ((Block) -> Void)? = nil
    var onTap: (() -> Void)? = nil
    var onResizeTop: ((CGFloat) -> Void)? = nil
    var onResizeBottom: ((CGFloat) -> Void)? = nil
    var onMove: ((CGFloat) -> Void)? = nil

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                // Main Block Content (draggable)
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        if let start = overrideStartTime ?? block.startTime,
                           let end = overrideEndTime ?? block.endTime {
                            Text("\(formattedTime(start)) – \(formattedTime(end))")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.8))
                        }

                        Text(block.name)
                            .font(.caption)
                            .bold()
                            .foregroundColor(.white)

                        if block.isCompleted {
                            Text("✔ Completed")
                                .font(.caption2)
                                .foregroundColor(.green)
                        }
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .highPriorityGesture(
                    DragGesture()
                        .onChanged { value in
                            onMove?(value.translation.height)
                        }
                )
            }

            // Resize arrows on right side
            VStack {
                Image(systemName: "chevron.up")
                    .resizable()
                    .frame(width: 10, height: 6)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(10)
                    .contentShape(Rectangle())
                    .background(Color.clear)
                    .highPriorityGesture(
                        DragGesture()
                            .onChanged { value in
                                onResizeTop?(value.translation.height)
                            }
                    )

                Spacer()

                Image(systemName: "chevron.down")
                    .resizable()
                    .frame(width: 10, height: 6)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(10)
                    .contentShape(Rectangle())
                    .background(Color.clear)
                    .highPriorityGesture(
                        DragGesture()
                            .onChanged { value in
                                onResizeBottom?(value.translation.height)
                            }
                    )
            }
        }
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.blue))
        .onTapGesture {
            onEdit?(block)
        }
    }

    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}
