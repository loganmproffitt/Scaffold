import SwiftUI

struct TimelineView: View {
    var onHourTap: ((Date) -> Void)? = nil
    var onEditBlock: ((Block) -> Void)? = nil
    var onStartBlock: ((Block) -> Void)? = nil
    var blocks: [Block]
    var isSnappingEnabled: Bool = true

    var onMoveBlock: ((UUID, Date, Date) -> Void)? = nil

    let startHour = 6
    let endHour = 22
    let hourHeight: CGFloat = 60
    let blockXOffset: CGFloat = 58

    @State private var draggingBlockID: UUID?
    @State private var dragOffsetY: CGFloat = 0
    @State private var resizingStartTime: Date?
    @State private var resizingEndTime: Date?

    func dateFor(hour: Int, minute: Int) -> Date {
        Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date())!
    }

    func startOfTimelineDate() -> Date {
        Calendar.current.date(bySettingHour: startHour, minute: 0, second: 0, of: Date())!
    }

    func snappedDate(_ date: Date) -> Date {
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.hour, .minute], from: date)
        let totalMinutes = (comps.hour ?? 0) * 60 + (comps.minute ?? 0)
        let snappedMinutes = Int(round(Double(totalMinutes) / 15.0)) * 15
        let snappedHour = snappedMinutes / 60
        let snappedMinute = snappedMinutes % 60
        return calendar.date(bySettingHour: snappedHour, minute: snappedMinute, second: 0, of: date)!
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {

                // MARK: - Hour Grid
                ForEach(startHour..<endHour, id: \.self) { hour in
                    let y = CGFloat(hour - startHour) * hourHeight

                    Rectangle()
                        .fill((hour % 2 == 0) ? Color(.systemGray6) : Color.white)
                        .frame(height: hourHeight)
                        .offset(y: y)
                        .onTapGesture {
                            let tappedDate = dateFor(hour: hour, minute: 0)
                            onHourTap?(tappedDate)
                        }

                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                        .offset(y: y)

                    Text(formattedHour(hour))
                        .font(.caption)
                        .frame(width: 50, alignment: .trailing)
                        .offset(x: 0, y: y - 6)
                }

                // MARK: - Ghost Outline for Resize Snap
                if let start = resizingStartTime, let end = resizingEndTime {
                    let y = yPosition(for: start)
                    let height = heightForDuration(start: start, end: end)
                    let width = geometry.size.width - 70

                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue.opacity(0.5), style: StrokeStyle(lineWidth: 2, dash: [5]))
                        .frame(width: width, height: height)
                        .offset(x: blockXOffset, y: y)
                }

                // MARK: - Real Blocks
                ForEach(blocks.filter { $0.startTime != nil && $0.endTime != nil }) { block in
                    let originalStart = block.startTime!
                    let originalEnd = block.endTime!

                    let isDragging = draggingBlockID == block.id

                    let yOffset = yPosition(for: originalStart)
                    let height = heightForDuration(start: originalStart, end: originalEnd)
                    let width = geometry.size.width - 70

                    BlockView(
                        block: block,
                        onEdit: { _ in onEditBlock?(block) },
                        onTap: { onStartBlock?(block) },
                        onResizeTop: { delta in
                            draggingBlockID = block.id
                            let newY = yPosition(for: originalStart) + delta
                            let minutesFromTop = newY / hourHeight * 60
                            let newStart = Calendar.current.date(byAdding: .minute, value: Int(minutesFromTop), to: startOfTimelineDate())!

                            if newStart < originalEnd {
                                resizingStartTime = snappedDate(newStart)
                                resizingEndTime = originalEnd
                            }
                        },
                        onResizeBottom: { delta in
                            draggingBlockID = block.id
                            let newY = yPosition(for: originalStart) + height + delta
                            let minutesFromTop = newY / hourHeight * 60
                            let newEnd = Calendar.current.date(byAdding: .minute, value: Int(minutesFromTop), to: startOfTimelineDate())!

                            if newEnd > originalStart {
                                resizingStartTime = originalStart
                                resizingEndTime = snappedDate(newEnd)
                            }
                        },
                        onMove: { drag in
                            draggingBlockID = block.id
                            dragOffsetY = drag
                        }
                    )
                    .opacity(isDragging ? 0.9 : 1)
                    .shadow(radius: isDragging ? 4 : 0)
                    .frame(width: width, height: height)
                    .offset(x: blockXOffset, y: yOffset + (isDragging ? dragOffsetY : 0))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                draggingBlockID = block.id
                                dragOffsetY = value.translation.height
                            }
                            .onEnded { value in
                                let newY = yOffset + value.translation.height
                                let minutesFromTop = newY / hourHeight * 60
                                var newStart = Calendar.current.date(byAdding: .minute, value: Int(minutesFromTop), to: startOfTimelineDate())!
                                if isSnappingEnabled {
                                    newStart = snappedDate(newStart)
                                }

                                let duration = Calendar.current.dateComponents([.minute], from: originalStart, to: originalEnd).minute ?? 60
                                let newEnd = Calendar.current.date(byAdding: .minute, value: duration, to: newStart)!

                                onMoveBlock?(block.id, newStart, newEnd)

                                draggingBlockID = nil
                                dragOffsetY = 0
                            }
                    )
                    .simultaneousGesture(
                        DragGesture()
                            .onEnded { _ in
                                if let s = resizingStartTime, let e = resizingEndTime {
                                    onMoveBlock?(block.id, s, e)
                                }

                                resizingStartTime = nil
                                resizingEndTime = nil
                                draggingBlockID = nil
                            }
                    )
                }
            }
            .padding(.top, 5)
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
