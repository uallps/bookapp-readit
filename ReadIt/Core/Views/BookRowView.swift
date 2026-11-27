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
#if Categorias
    @Environment(CategoriesViewModel.self) private var categoriesVM
#endif

#if Prioridades
    @Environment(PriorityViewModel.self) private var priorityVM
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
                    if showPriorities, let priority = priorityVM.getPriority(bookId: book.id) {
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
                let bookCategories = categoriesVM.categories(for: book.id)
                if config.enableCategories, !bookCategories.isEmpty {
                    Text("Categorías: \(bookCategories.joined(separator: ", "))")
                        .bookCaption()
                }
#endif

#if FechaObjetivo
                // Fecha objetivo (O2)
                if showDueDates, let dueDate = book.dueDate {
                    Text("Vence: \(dueDate.formatted(date: .abbreviated, time: .omitted))")
                        .bookCaption()
                }
#endif

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

            // Columna derecha: estado de lectura y aviso +18, centrados verticalmente.
            HStack(spacing: 8) {
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

#if AlertasContenido
                ContentAlertBadge(isSensitive: book.hasSensitiveContent)
#endif
            }
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