import SwiftUI

struct BlockCreationView: View {
    @Environment(\.dismiss) var dismiss

    var onSave: (Block) -> Void

    @State private var block: Block

    init(start: Date? = nil, onSave: @escaping (Block) -> Void) {
        let now = Date()
        let calendar = Calendar.current
        let defaultStart = start ?? calendar.date(
                bySettingHour: 12,
                minute: 0,
                second: 0,
                of: now
            ) ?? now
        let defaultEnd = Calendar.current.date(byAdding: .minute, value: 60, to: defaultStart) ?? now.addingTimeInterval(3600)

        let initialBlock = Block(
            name: "",
            startTime: defaultStart,
            endTime: defaultEnd,
            isTimeSensitive: false,
            isRigid: false,
            isCompleted: false
        )

        _block = State(initialValue: initialBlock)
        self.onSave = onSave
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Block Details")) {
                    TextField("Block name", text: $block.name)

                    DatePicker("Start Time", selection: Binding(
                        get: { block.startTime ?? Date() },
                        set: { block.startTime = $0 }
                    ), displayedComponents: .hourAndMinute)

                    DatePicker("End Time", selection: Binding(
                        get: { block.endTime ?? Date() },
                        set: { block.endTime = $0 }
                    ), displayedComponents: .hourAndMinute)

                    Toggle("Time Sensitive", isOn: $block.isTimeSensitive)
                    Toggle("Rigid", isOn: $block.isRigid)
                    Toggle("Completed", isOn: $block.isCompleted)
                }
            }
            .navigationTitle("New Block")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    onSave(block)
                    dismiss()
                }
                .disabled((block.startTime ?? Date()) >= (block.endTime ?? Date()))
            )
        }
    }
}
