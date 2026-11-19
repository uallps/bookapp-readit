import SwiftUI

/// Fila de un libro con insignias en formato pastilla (pill)
struct BookRowView: View {
    let book: Book
    let showDueDates: Bool
#if Prioridades
    let showPriorities: Bool
#endif

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            // Columna izquierda: Título, prioridad y autor
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(book.title)
                        .font(.headline)
                    
#if Prioridades
                    // Píldora de prioridad (Alta / Media / Baja)
                    if showPriorities, let priority = book.priority {
                        Text(priorityText(for: priority))
                            .font(.caption2)
                            .bold()
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(
                                Capsule()
                                    .fill(priorityBackgroundColor(for: priority))
                            )
                            .foregroundColor(priorityTextColor(for: priority))
                    }
#endif
                }
                
                if let author = book.author {
                    Text(author)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if showDueDates, let dueDate = book.dueDate {
                    Text("Vence: \(dueDate.formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Columna derecha: Píldora de estado de lectura (Leyendo / Pendiente / Terminado)
            Text(book.state.rawValue)
                .font(.caption)
                .bold()
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(colorForState(book.state))
                )
                .foregroundColor(.white)
        }
        .padding(.vertical, 4)
    }
    
    private func colorForState(_ state: ReadingState) -> Color {
        switch state {
        case .pending: return .gray
        case .reading: return .blue
        case .finished: return .green
        }
    }

#if Prioridades
    private func priorityText(for priority: Priority) -> String {
        switch priority {
        case .high, .alta: return "Alta"
        case .medium, .media: return "Media"
        case .low, .baja: return "Baja"
        }
    }

    private func priorityBackgroundColor(for priority: Priority) -> Color {
        switch priority {
        case .high, .alta:
            return Color.red.opacity(0.18)
        case .medium, .media:
            return Color.orange.opacity(0.18)
        case .low, .baja:
            return Color.gray.opacity(0.18)
        }
    }

    private func priorityTextColor(for priority: Priority) -> Color {
        switch priority {
        case .high, .alta:
            return .red
        case .medium, .media:
            return .orange
        case .low, .baja:
            return .secondary
        }
    }
#endif
}