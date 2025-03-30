import SwiftUI

struct BlockView: View {
    var block: Block
    var onEdit: ((Block) -> Void)? = nil
    var onTap: (() -> Void)? = nil

    var body: some View {
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
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.blue))
        .opacity(1)
        .onTapGesture {
            onTap?()
        }
    }
}
