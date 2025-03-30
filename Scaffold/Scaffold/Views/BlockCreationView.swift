import SwiftUI

struct BlockCreationView: View {
    var block: Block
    var isNew: Bool = false
    var onSave: (Block) -> Void
    var onDelete: (() -> Void)? = nil

    @Environment(\.dismiss) var dismiss
    @State private var editableBlock: Block

    init(block: Block, isNew: Bool = false, onSave: @escaping (Block) -> Void, onDelete: (() -> Void)? = nil) {
        self.block = block
        self.isNew = isNew
        self.onSave = onSave
        self.onDelete = onDelete
        _editableBlock = State(initialValue: block)
    }


    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Block Details")) {
                    TextField("Block name", text: $editableBlock.name)

                    DatePicker("Start Time", selection: Binding<Date>(
                        get: { editableBlock.startTime ?? Date() },
                        set: { editableBlock.startTime = $0 }
                    ), displayedComponents: .hourAndMinute)

                    DatePicker("End Time", selection: Binding<Date>(
                        get: { editableBlock.endTime ?? Date() },
                        set: { editableBlock.endTime = $0 }
                    ), displayedComponents: .hourAndMinute)

                    Toggle("Time Sensitive", isOn: $editableBlock.isTimeSensitive)
                    Toggle("Rigid", isOn: $editableBlock.isRigid)
                    Toggle("Completed", isOn: $editableBlock.isCompleted)
                }

                if !isNew {
                    Section {
                        Button(role: .destructive) {
                            onDelete?()
                            dismiss()
                        } label: {
                            Label("Delete Block", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle(isNew ? "New Block" : "Edit Block")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    onSave(editableBlock)
                    dismiss()
                }
            )
        }
    }
}
