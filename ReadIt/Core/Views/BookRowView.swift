import SwiftUI

/// Fila de un libro. No conoce el ViewModel principal.
struct BookRowView: View {
    let book: Book
    let showDueDates: Bool
    let showPriorities: Bool
    
    @Environment(AppConfig.self) private var config
    
#if Progreso
    @Environment(ProgressViewModel.self) private var progressVM
#endif

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.headline)
                
                if let author = book.author {
                    Text(author)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if showDueDates, let dueDate = book.dueDate {
                    Text("Vence: \(dueDate.formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption)
                }
                
#if Prioridades
                if showPriorities, let priority = book.priority {
                    Text("Prioridad: \(priority.rawValue)")
                        .font(.caption)
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
    
    private func colorForState(_ state: ReadingState) -> Color {
        switch state {
        case .pending: return .gray
        case .reading: return .blue
        case .finished: return .green
        }
    }
}