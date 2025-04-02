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
    let blockXOffset: CGFloat = 70

    @State private var draggingBlockID: UUID?
    @State private var dragOffsetY: CGFloat = 0
    @State private var resizingStartTime: Date?
    @State private var resizingEndTime: Date?
    @State private var currentTime: Date = Date()

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                // MARK: - Hour Grid
                ForEach(startHour..<endHour, id: \.self) { hour in
                    let y = CGFloat(hour - startHour) * hourHeight

                    Rectangle()
                        .fill((hour % 2 == 0) ? Color(.systemGray6) : Color.black)
                        .frame(height: hourHeight)
                        .offset(y: y)
                        .onTapGesture {
                            let tappedDate = TimelineMath.dateFrom(hour: hour)
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

                // MARK: - Current Time Indicator
                let nowY = TimelineMath.yFrom(date: currentTime, startHour: startHour, hourHeight: hourHeight)
                let fullHeight = CGFloat(endHour - startHour) * hourHeight

                if nowY >= 0 && nowY <= fullHeight {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(height: 2)
                        .offset(y: nowY - 1)

                    Circle()
                        .fill(Color.blue)
                        .frame(width: 8, height: 8)
                        .offset(x: blockXOffset - 12, y: nowY - 4)

                    Text(formattedTime(currentTime))
                        .font(.caption2)
                        .foregroundColor(.blue)
                        .offset(x: blockXOffset + 5, y: nowY - 15)
                }

                // MARK: - Ghost Outline
                if let start = resizingStartTime, let end = resizingEndTime {
                    let y = TimelineMath.yFrom(date: start, startHour: startHour, hourHeight: hourHeight)
                    let height = TimelineMath.heightForDuration(start: start, end: end, hourHeight: hourHeight)
                    let width = geometry.size.width - blockXOffset

                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue.opacity(0.5), style: StrokeStyle(lineWidth: 2, dash: [5]))
                        .frame(width: width, height: height)
                        .offset(x: blockXOffset, y: y)
                }

                // MARK: - Blocks
                ForEach(blocks) { block in
                    if let originalStart = block.startTime,
                       let originalEnd = block.endTime {

                        let duration = TimelineMath.durationInMinutes(start: originalStart, end: originalEnd)
                        let yOffset = TimelineMath.yFrom(date: originalStart, startHour: startHour, hourHeight: hourHeight)
                        let height = TimelineMath.heightForDuration(start: originalStart, end: originalEnd, hourHeight: hourHeight)
                        let width = geometry.size.width - blockXOffset
                        let isDragging = draggingBlockID == block.id

                        BlockView(
                            block: block,
                            overrideStartTime: overrideStartTime(for: block, yOffset: yOffset, duration: duration),
                            overrideEndTime: overrideEndTime(for: block, yOffset: yOffset, duration: duration),
                            onEdit: { _ in onEditBlock?(block) },
                            onTap: { onStartBlock?(block) },
                            onResizeTop: { delta in
                                draggingBlockID = block.id
                                let newStart = TimelineMath.dateFrom(
                                    y: yOffset + delta,
                                    startHour: startHour,
                                    hourHeight: hourHeight
                                )
                                if newStart < originalEnd {
                                    resizingStartTime = isSnappingEnabled ? TimelineMath.snapped(newStart) : newStart
                                    resizingEndTime = originalEnd
                                }
                            },
                            onResizeBottom: { delta in
                                draggingBlockID = block.id
                                let newEnd = TimelineMath.dateFrom(
                                    y: yOffset + height + delta,
                                    startHour: startHour,
                                    hourHeight: hourHeight
                                )
                                if newEnd > originalStart {
                                    resizingStartTime = originalStart
                                    resizingEndTime = isSnappingEnabled ? TimelineMath.snapped(newEnd) : newEnd
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
                                    var newStart = TimelineMath.dateFrom(
                                        y: newY,
                                        startHour: startHour,
                                        hourHeight: hourHeight
                                    )
                                    if isSnappingEnabled {
                                        newStart = TimelineMath.snapped(newStart)
                                    }
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

                // Spacer to allow scrolling beyond last block
                Color.clear.frame(height: CGFloat(endHour - startHour) * hourHeight)
            }
            .padding(.top, 5)
            .onAppear {
                // Start updating the current time every minute
                Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                    currentTime = Date()
                }
            }
        }
    }

    // MARK: - Helpers

    func formattedHour(_ hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        return formatter.string(from: TimelineMath.dateFrom(hour: hour))
    }

    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }

    func overrideStartTime(for block: Block, yOffset: CGFloat, duration: Int) -> Date? {
        guard draggingBlockID == block.id else { return nil }
        if let s = resizingStartTime { return s }
        let newStart = TimelineMath.dateFrom(y: yOffset + dragOffsetY, startHour: startHour, hourHeight: hourHeight)
        return isSnappingEnabled ? TimelineMath.snapped(newStart) : newStart
    }

    func overrideEndTime(for block: Block, yOffset: CGFloat, duration: Int) -> Date? {
        guard draggingBlockID == block.id else { return nil }
        if let e = resizingEndTime { return e }
        let newStart = TimelineMath.dateFrom(y: yOffset + dragOffsetY, startHour: startHour, hourHeight: hourHeight)
        let snappedStart = isSnappingEnabled ? TimelineMath.snapped(newStart) : newStart
        return Calendar.current.date(byAdding: .minute, value: duration, to: snappedStart)
    }
}
