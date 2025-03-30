import SwiftUI

struct BlockView: View {
    var block: Block

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(block.name)
                .font(.caption)
                .bold()
                .foregroundColor(.white)
        }
        .padding(6)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue)
        )
    }
}
