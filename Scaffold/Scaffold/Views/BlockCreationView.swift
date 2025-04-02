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

    init(block: Block, isNew: Bool = false, onCreate: @escaping (Block) -> Void, onSave: @escaping (Block) -> Void, onDelete: (() -> Void)? = nil) {
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

                    labeledField("Name") {
                        TextField("Enter name", text: $editableBlock.name)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    labeledField("Description") {
                        TextEditor(text: Binding(
                            get: { editableBlock.descriptionText ?? "" },
                            set: { editableBlock.descriptionText = $0 }
                        ))
                        .frame(minHeight: 80)
                        .padding(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.4))
                        )
                    }

                    HStack(spacing: 20) {
                        labeledField("Start") {
                            DatePicker(
                                "",
                                selection: Binding(
                                    get: { editableBlock.startTime ?? Date() },
                                    set: {
                                        editableBlock.startTime = $0
                                        editableBlock.duration = durationMinutes * 60
                                    }
                                ),
                                displayedComponents: .hourAndMinute
                            )
                            .labelsHidden()
                        }

                        labeledField("End") {
                            DatePicker(
                                "",
                                selection: Binding(
                                    get: {
                                        guard let start = editableBlock.startTime else { return Date() }
                                        return start.addingTimeInterval(durationMinutes * 60)
                                    },
                                    set: {
                                        guard let start = editableBlock.startTime else { return }
                                        let newDuration = $0.timeIntervalSince(start)
                                        durationMinutes = newDuration / 60
                                        editableBlock.duration = newDuration
                                    }
                                ),
                                displayedComponents: .hourAndMinute
                            )
                            .labelsHidden()
                        }
                    }

                    labeledField("Duration") {
                        let hoursBinding = Binding<Int>(
                            get: { Int(durationMinutes) / 60 },
                            set: { durationMinutes = Double($0 * 60 + Int(durationMinutes) % 60) }
                        )

                        let minutesBinding = Binding<Int>(
                            get: { Int(durationMinutes) % 60 },
                            set: { durationMinutes = Double((Int(durationMinutes) / 60) * 60 + $0) }
                        )

                        HStack(spacing: 0) {
                            Picker("Hours", selection: hoursBinding) {
                                ForEach(0..<10) { hour in
                                    Text("\(hour) h").tag(hour)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(maxWidth: .infinity)

                            Picker("Minutes", selection: minutesBinding) {
                                ForEach([0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55], id: \.self) { minute in
                                    Text("\(minute) min").tag(minute)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(maxWidth: .infinity)
                        }
                        .frame(height: 100)
                    }

                    Toggle("Time Sensitive", isOn: $editableBlock.isScheduled)
                    Toggle("Rigid", isOn: $editableBlock.isRigid)
                    Toggle("Completed", isOn: $editableBlock.isComplete)

                    labeledField("Block Color") {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(AppStyling.Colors.presetHexColors, id: \.self) { hex in
                                    let color = Color(hex: hex)

                                    Circle()
                                        .fill(color)
                                        .frame(width: 30, height: 30)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.primary, lineWidth: editableBlock.colorHex == hex ? 3 : 0)
                                        )
                                        .onTapGesture {
                                            editableBlock.colorHex = hex
                                        }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }

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
