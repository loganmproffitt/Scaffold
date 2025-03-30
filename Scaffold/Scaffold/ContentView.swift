import SwiftUI

struct ContentView: View {
    @State private var today = Day(
        date: Date(),
        blocks: [
            Block(
                name: "Morning Focus",
                description: "Read, journal, plan",
                startTime: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date()),
                endTime: Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()),
                isTimeSensitive: false,
                isRigid: false,
                isCompleted: false
            ),
            Block(
                name: "Guitar",
                description: "Practice session",
                startTime: Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date()),
                endTime: Calendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: Date()),
                isTimeSensitive: false,
                isRigid: false,
                isCompleted: false
            )
        ]
    )

    var body: some View {
        NavigationView {
            DayView(day: today)
        }
    }
}


#Preview {
    ContentView()
}
