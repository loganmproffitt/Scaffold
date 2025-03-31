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
        ZStack {
            // Transparent background (with optional dimming)
            Color.black.opacity(0.0)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(isNew ? "Create Block" : "Edit Block")
                        .font(.title)
                        .bold()
                        .padding(.bottom, 10)

                    // Name Input
                    labeledField("Block Name") {
                        TextField("Enter name", text: $editableBlock.name)
                            .textFieldStyle(.roundedBorder)
                    }

                    // Start Time
                    labeledField("Start Time") {
                        DatePicker("", selection: Binding(
                            get: { editableBlock.startTime ?? Date() },
                            set: { editableBlock.startTime = $0 }
                        ), displayedComponents: .hourAndMinute)
                        .labelsHidden()
                    }

                    // End Time
                    labeledField("End Time") {
                        DatePicker("", selection: Binding(
                            get: { editableBlock.endTime ?? Date() },
                            set: { editableBlock.endTime = $0 }
                        ), displayedComponents: .hourAndMinute)
                        .labelsHidden()
                    }

                    Toggle("Time Sensitive", isOn: $editableBlock.isTimeSensitive)
                    Toggle("Rigid", isOn: $editableBlock.isRigid)
                    Toggle("Completed", isOn: $editableBlock.isCompleted)

                    // Action Buttons
                    HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundColor(.red)

                        Spacer()

                        Button("Save") {
                            onSave(editableBlock)
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                    }

                    // Delete
                    if !isNew {
                        Divider().padding(.top, 20)

                        Button(role: .destructive) {
                            onDelete?()
                            dismiss()
                        } label: {
                            Label("Delete Block", systemImage: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                )
                .padding()
            }
            .frame(maxWidth: 500)
        }
        .navigationBarHidden(true)
    }

    @ViewBuilder
    func labeledField<Content: View>(_ label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            content()
        }
    }
}
