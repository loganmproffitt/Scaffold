import SwiftUI

struct BlockCreationView: View {
    var block: Block
    var isNew: Bool = false
    var onCreate: (Block) -> Void
    var onSave: (Block) -> Void
    var onDelete: (() -> Void)? = nil

    @Environment(\.dismiss) var dismiss
    @State private var editableBlock: Block
    @State private var durationMinutes: Double

    init(block: Block, isNew: Bool = false, onCreate: @escaping (Block) -> Void,onSave: @escaping (Block) -> Void, onDelete: (() -> Void)? = nil) {
        self.block = block
        self.isNew = isNew
        self.onCreate = onCreate
        self.onSave = onSave
        self.onDelete = onDelete
        _editableBlock = State(initialValue: block)
        _durationMinutes = State(initialValue: (block.duration ?? 3600) / 60)
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.0)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(isNew ? "Create Block" : "Edit Block")
                        .font(.title)
                        .bold()
                        .padding(.bottom, 10)

                    labeledField("Block Name") {
                        TextField("Enter name", text: $editableBlock.name)
                            .textFieldStyle(.roundedBorder)
                    }

                    labeledField("Start Time") {
                        DatePicker("", selection: Binding(
                            get: { editableBlock.startTime ?? Date() },
                            set: { editableBlock.startTime = $0 }
                        ), displayedComponents: .hourAndMinute)
                        .labelsHidden()
                    }

                    labeledField("Duration (minutes)") {
                        Stepper(value: $durationMinutes, in: 5...180, step: 5) {
                            Text("\(Int(durationMinutes)) min")
                        }
                    }

                    if let computedEnd = editableBlock.startTime?.addingTimeInterval(durationMinutes * 60) {
                        labeledField("End Time (calculated)") {
                            Text(DateFormatter.localizedString(from: computedEnd, dateStyle: .none, timeStyle: .short))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }

                    Toggle("Time Sensitive", isOn: $editableBlock.isScheduled)
                    Toggle("Rigid", isOn: $editableBlock.isRigid)
                    Toggle("Completed", isOn: $editableBlock.isComplete)

                    HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundColor(.red)

                        Spacer()

                        Button("Save") {
                            editableBlock.duration = durationMinutes * 60
                            if isNew {
                                onCreate(editableBlock)
                            }
                            onSave(editableBlock)
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                    }

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
