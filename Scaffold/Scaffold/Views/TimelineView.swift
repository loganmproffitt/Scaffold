import SwiftUI

struct TimelineView: View {
    var onHourTap: ((Date) -> Void)? = nil
    var onEditBlock: ((Block) -> Void)? = nil
    var onStartBlock: ((Block) -> Void)? = nil
    var blocks: [Block]

    let startHour = 6
    let endHour = 22
    let hourHeight: CGFloat = 60
    let blockXOffset: CGFloat = 58;
    
    func dateFor(hour: Int, minute: Int) -> Date {
        Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date())!
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ZStack(alignment: .topLeading) {
                    
                    // MARK: - Hour Grid
                    ForEach(startHour..<endHour, id: \.self) { hour in
                        let y = CGFloat(hour - startHour) * hourHeight
                        
                        // Box
                        Rectangle()
                            .fill((hour % 2 == 0) ? Color(.systemGray6) : Color.white)
                            .frame(height: hourHeight)
                            .offset(y: y)
                            .onTapGesture {
                                let tappedDate = dateFor(hour: hour, minute: 0)
                                onHourTap?(tappedDate)
                            }
                        
                        // Hour line
                        Rectangle()
                           .fill(Color.gray.opacity(0.3))
                           .frame(height: 1)
                           .offset(y: y)
                        
                        // Hour label
                        Text(formattedHour(hour))
                            .font(.caption)
                            .frame(width: 50, alignment: .trailing)
                            .offset(x: 0, y: y - 6) // tweak this to taste
                    }
                
                
                    // MARK: - Block Overlays
                    ForEach(blocks) { block in
                        if let start = block.startTime, let end = block.endTime {
                            let yOffset = yPosition(for: start)
                            let height = heightForDuration(start: start, end: end)
                            let width = geometry.size.width - 70
                            
                            
                            BlockView(
                                block: block,
                                onEdit: {
                                   onEditBlock?(block)
                                },
                                onTap: {
                                    onStartBlock?(block)
                                }
                            )
                                .frame(width: width, height: height)
                                .offset(x: blockXOffset, y: yOffset)
                        }
                    }
                     
                }
                .padding(.top, 5)
            }
        }
    }

    func formattedHour(_ hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        let date = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: Date())!
        return formatter.string(from: date)
    }

    func yPosition(for date: Date) -> CGFloat {
        let comps = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = comps.hour ?? 0
        let minute = comps.minute ?? 0
        let totalMinutes = (hour - startHour) * 60 + minute
        return CGFloat(totalMinutes) / 60 * hourHeight
    }

    func heightForDuration(start: Date, end: Date) -> CGFloat {
        let minutes = Calendar.current.dateComponents([.minute], from: start, to: end).minute ?? 0
        return CGFloat(minutes) / 60 * hourHeight
    }
}
