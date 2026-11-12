import SwiftUI

/// Fila de un libro. No conoce el ViewModel: recibe los flags y los datos.
struct BookRowView: View {
    let book: Book
    let showDueDates: Bool
    let showPriorities: Bool

    var body: some View {
        HStack {
            // Columna izquierda: Información del libro
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.headline)
                
                // Mostrar el autor si existe (obligatorio del Core)
                if let author = book.author {
                    Text(author)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Feature opcional: Fechas (si la mantenéis de TaskApp)
                if showDueDates, let dueDate = book.dueDate {
                    Text("Vence: \(dueDate.formatted(date: .abbreviated, time: .shortened))")
                        .bookCaption()
                }
                
#if Prioridades
                // Feature opcional: Prioridades (variabilidad en compilación)
                if showPriorities, let priority = book.priority {
                    Text("Prioridad: \(priority.rawValue)")
                        .bookCaption(color: priority.color) 
                }
#endif
            }
            
            Spacer()
            
            // Columna derecha: Píldora de estado de lectura (Prototipo ReadIT)
            Text(book.state.rawValue)
                .font(.caption)
                .bold()
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(colorForState(book.state))
                .foregroundColor(.white)
                .clipShape(Capsule())
        }
        .padding(.vertical, 2)
    }
    
    /// Asigna colores representativos a cada estado, como en vuestro PDF.
    private func colorForState(_ state: ReadingState) -> Color {
        switch state {
        case .pending: return .gray
        case .reading: return .blue
        case .finished: return .green
        }
    }
}