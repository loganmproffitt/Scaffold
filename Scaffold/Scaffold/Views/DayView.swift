import SwiftUI

struct DayView: View {
    var day: Day

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(formattedDate(day.date))
                .font(.title)
                .padding()

            TimelineView(blocks: day.blocks)
                .padding(.top, 5)

            Spacer()
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}
