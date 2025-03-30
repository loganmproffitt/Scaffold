import SwiftUI

struct DayView: View {
    @ObservedObject var day: Day
    @State var selectedTime: Date? = nil
    @State var showBlockCreator = false
    
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
                        selectedTime = time
                        showBlockCreator = true
                    },
                    blocks: day.blocks
                )
                
                Button(action: {
                    selectedTime = nil
                    showBlockCreator = true
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
            .sheet(isPresented: $showBlockCreator) {
                BlockCreationView(start: selectedTime) { newBlock in
                    print("🧱 New block created: \(newBlock.name), from \(newBlock.startTime!) to \(newBlock.endTime!)")
                    day.blocks.append(newBlock)
                }
            }
        }
    }
}

