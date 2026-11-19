import SwiftUI

#if Notas
/// Vista para listar y añadir notas o citas vinculadas a un libro.
struct NotesListView: View {
    @Binding var notes: [Note]
    @State private var newNoteText: String = ""
    @State private var newNotePage: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notas y Citas")
                .font(.headline)

            HStack {
                TextField("Escribe una nota o cita...", text: $newNoteText)
                    .textFieldStyle(.roundedBorder)

                TextField("Pág.", text: $newNotePage)
                    .frame(width: 60)
                    .textFieldStyle(.roundedBorder)

                Button("Añadir") {
                    addNote()
                }
                .disabled(newNoteText.trimmingCharacters(in: .whitespaces).isEmpty)
            }

            if notes.isEmpty {
                Text("No hay notas guardadas para este libro.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                ForEach(notes) { note in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(note.text)
                                .font(.body)
                            if let page = note.page {
                                Text("Pág. \(page)")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                    }
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
        .padding(.vertical, 8)
    }

    private func addNote() {
        let pageNum = Int(newNotePage)
        let note = Note(text: newNoteText, page: pageNum)
        notes.append(note)
        newNoteText = ""
        newNotePage = ""
    }
}
#endif