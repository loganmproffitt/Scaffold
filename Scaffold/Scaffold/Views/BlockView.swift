import SwiftUI

struct BlockView: View {
    var block: Block
    var onEdit: ((Block) -> Void)? = nil
    var onTap: (() -> Void)? = nil
    var onResizeTop: ((CGFloat) -> Void)? = nil
    var onResizeBottom: ((CGFloat) -> Void)? = nil
    var onMove: ((CGFloat) -> Void)? = nil

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                // Main Block Content (tappable, movable)
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        if let start = block.startTime, let end = block.endTime {
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
                .padding(6)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            onMove?(value.translation.height)
                        }
                )
                .onTapGesture {
                    onTap?()
                }
            }

            // Top and Bottom Resize Arrows (right side)
            VStack {
                Image(systemName: "chevron.up")
                    .resizable()
                    .frame(width: 10, height: 6)
                    .foregroundColor(.white.opacity(0.9))
                    .padding([.leading, .trailing], 10)
                    .padding([.top, .bottom], 2)
                    .contentShape(Rectangle())
                    .background(Color.clear)
                    .gesture(
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
                    .padding([.leading, .trailing], 15)
                    .padding([.top, .bottom], 2)
                    .contentShape(Rectangle())
                    .background(Color.clear)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                onResizeBottom?(value.translation.height)
                            }
                    )
            }
            .padding(.vertical, 4)
        }
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.blue))
    }

    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}
