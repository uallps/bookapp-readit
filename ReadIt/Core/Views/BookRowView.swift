import SwiftUI

/// Fila de un libro con insignias en formato pastilla (pill).
struct BookRowView: View {
    let book: Book
    let showDueDates: Bool
    let showPriorities: Bool

    @Environment(AppConfig.self) private var config

#if Progreso
    @Environment(ProgressViewModel.self) private var progressVM
#endif

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            // Columna izquierda: Título, prioridad, autor, fecha y progreso
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

#if Categorias
                if config.enableCategories, !book.categories.isEmpty {
                    Text("Categorías: \(book.categories.joined(separator: ", "))")
                        .bookCaption()
                }
#endif
                
                // Feature opcional: Fechas (si la mantenéis de TaskApp)
                if showDueDates, let dueDate = book.dueDate {
                    Text("Vence: \(dueDate.formatted(date: .abbreviated, time: .shortened))")
                        .bookCaption()
                }

#if Progreso
                if config.enableProgress {
                    if let progress = progressVM.getProgress(bookId: book.id), progress.totalPages > 0 {
                        let percent = Int(progress.percentage * 100)
                        Text("Leído: \(percent)% (\(progress.currentPage)/\(progress.totalPages))")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .bold()
                    }
                }
#endif
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
        case .high: return "Alta"
        case .medium: return "Media"
        case .low: return "Baja"
        }
    }

    private func priorityBackgroundColor(for priority: Priority) -> Color {
        switch priority {
        case .high:
            return Color.red.opacity(0.18)
        case .medium:
            return Color.orange.opacity(0.18)
        case .low:
            return Color.gray.opacity(0.18)
        }
    }

    private func priorityTextColor(for priority: Priority) -> Color {
        switch priority {
        case .high:
            return .red
        case .medium:
            return .orange
        case .low:
            return .secondary
        }
    }
#endif
}