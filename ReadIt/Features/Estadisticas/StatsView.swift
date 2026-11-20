#if Estadisticas
import SwiftUI

/// Panel resumen de métricas y estadísticas de la biblioteca (F5).
struct StatsView: View {
    @Environment(AppConfig.self) private var config
    @State private var bookListVM = BookListViewModel()
    @State private var statsVM = StatsViewModel()

#if Progreso
    @Environment(ProgressViewModel.self) private var progressVM
#endif

    private var summary: ReadingStatisticsSummary {
#if Progreso
        statsVM.buildSummary(books: bookListVM.books, progresses: progressVM.progresses)
#else
        statsVM.buildSummary(books: bookListVM.books)
#endif
    }

    var body: some View {
        Form {
            Section(header: Text("Resumen general")) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Total de libros en biblioteca")
                            .font(.headline)
                        Spacer()
                        Text("\(summary.totalBooks)")
                            .font(.title3)
                            .bold()
                    }

                    ProgressView(value: summary.completionPercentage)

                    HStack {
                        Text("Completados: \(Int(summary.completionPercentage * 100))%")
                            .font(.subheadline)
                            .foregroundColor(.green)
                            .bold()
                        Spacer()
                        Text("\(summary.finishedBooks) de \(summary.totalBooks) libros")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }

            Section(header: Text("Recuento por estado de lectura")) {
                stateStatRow(
                    state: .finished,
                    count: summary.finishedBooks,
                    percentage: summary.completionPercentage,
                    color: .green
                )

                stateStatRow(
                    state: .reading,
                    count: summary.readingBooks,
                    percentage: summary.readingPercentage,
                    color: .blue
                )

                stateStatRow(
                    state: .pending,
                    count: summary.pendingBooks,
                    percentage: summary.pendingPercentage,
                    color: .gray
                )
            }

#if Progreso
            Section(header: Text("Progreso de páginas (F1)")) {
                VStack(alignment: .leading, spacing: 12) {
                    ProgressView(value: summary.pagesCompletionPercentage)

                    HStack {
                        Text("\(Int(summary.pagesCompletionPercentage * 100))% leído")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .bold()
                        Spacer()
                        Text("\(summary.totalPagesRead) de \(summary.totalPagesTracked) págs")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Divider()
                        .padding(.vertical, 4)

                    HStack {
                        Text("Libros con progreso registrado")
                            .font(.subheadline)
                        Spacer()
                        Text("\(summary.trackedBooksCount)")
                            .font(.subheadline)
                            .bold()
                    }

                    HStack {
                        Text("Avance medio por libro")
                            .font(.subheadline)
                        Spacer()
                        Text("\(Int(summary.averageBookProgress * 100))%")
                            .font(.subheadline)
                            .bold()
                    }
                }
                .padding(.vertical, 4)
            }
#endif

            let categories = statsVM.categoryBreakdown(from: bookListVM.books)
            if !categories.isEmpty {
                Section(header: Text("Libros por categoría")) {
                    ForEach(categories, id: \.category) { item in
                        HStack {
                            Text(item.category)
                            Spacer()
                            Text("\(item.count)")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Estadísticas")
        .onAppear {
            bookListVM = BookListViewModel()
        }
    }

    private func stateStatRow(
        state: ReadingState,
        count: Int,
        percentage: Double,
        color: Color
    ) -> some View {
        HStack(spacing: 12) {
            Text(state.rawValue)
                .font(.caption)
                .bold()
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(color)
                )
                .foregroundColor(.white)

            Spacer()

            Text("\(count) libros")
                .font(.subheadline)
                .bold()

            Text("(\(Int(percentage * 100))%)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 2)
    }
}
#endif
