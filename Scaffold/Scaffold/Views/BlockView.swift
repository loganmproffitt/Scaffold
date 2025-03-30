import SwiftUI

struct BlockView: View {
    var block: Block
    var onEdit: ((Block) -> Void)? = nil
    var onTap: (() -> Void)? = nil
    var onResizeTop: ((CGFloat) -> Void)? = nil
    var onResizeBottom: ((CGFloat) -> Void)? = nil
    var onMove: ((CGFloat) -> Void)? = nil

    var body: some View {
        ZStack(alignment: .top) {
            // Top Resize Handle
            Rectangle()
                .fill(Color.clear)
                .frame(height: 10)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            onResizeTop?(value.translation.height)
                        }
                )

            VStack(spacing: 0) {
                // Main Content (Move Gesture Here)
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
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

                    Button(action: {
                        onEdit?(block)
                    }) {
                        Image(systemName: "pencil")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(6)
                    }
                    .clipShape(Circle())
                }
                .padding(6)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            onMove?(value.translation.height)
                        }
                )

                // Bottom Resize Handle
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 10)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                onResizeBottom?(value.translation.height)
                            }
                    )
            }
        }
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.blue))
        .onTapGesture {
            onTap?()
        }
    }
}
