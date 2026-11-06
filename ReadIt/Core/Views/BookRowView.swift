import SwiftUI

/// Fila de un libro. No conoce el ViewModel: recibe los flags y la acción.
struct BookRowView: View {
    let book: Book
    let showDueDates: Bool
    let showPriorities: Bool
    let toggleCompletion: () -> Void

    var body: some View {
        HStack {
            Button(action: toggleCompletion) {
                Image(systemName: book.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.bookAccent)
            }
            .buttonStyle(.plain)
            VStack(alignment: .leading) {
                Text(book.title)
                    .strikethrough(book.isCompleted)
                if showDueDates, let dueDate = book.dueDate {
                    Text("Vence: \(dueDate.formatted(date: .abbreviated, time: .shortened))")
                        .bookCaption()
                }
#if Prioridades
                if showPriorities, let priority = book.priority {
                    Text("Prioridad: \(priority.rawValue)")
                        .bookCaption(color: priority.color)
                }
#endif
            }
        }
    }
}
