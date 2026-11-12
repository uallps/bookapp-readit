import SwiftUI

/// Detalle de un libro.
struct BookDetailView: View {
    @Binding var book: Book
    @Environment(AppConfig.self) private var config
    
#if Progreso
    @Environment(ProgressViewModel.self) private var progressVM
    @State private var currentPage: Int = 0
    @State private var totalPages: Int = 0
#endif

    var body: some View {
        Form {
            Section(header: Text("Información del libro")) {
                TextField("Título del libro", text: $book.title)
                
                TextField("Autor", text: Binding(
                    get: { book.author ?? "" },
                    set: { book.author = $0.isEmpty ? nil : $0 }
                ))
            }
            
            Section(header: Text("Estado")) {
                Picker("Estado de lectura", selection: $book.state) {
                    ForEach(ReadingState.allCases, id: \.self) { state in
                        Text(state.rawValue).tag(state)
                    }
                }
                .pickerStyle(.segmented)
            }
            
#if Progreso
            if config.enableProgress {
                Section(header: Text("Progreso de lectura")) {
                    VStack(alignment: .leading, spacing: 12) {
                        let percent = totalPages > 0 ? (Double(currentPage) / Double(totalPages)) : 0.0
                        
                        // Barra gráfica sin el modificador .tint()
                        ProgressView(value: percent)
                        
                        HStack {
                            Text("\(Int(percent * 100))%")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                                .bold()
                            Spacer()
                            Text("\(currentPage) de \(totalPages) págs")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Divider()
                            .padding(.vertical, 4)
                        
                        Stepper("Páginas leídas: \(currentPage)", value: $currentPage, in: 0...max(totalPages, 10000))
                            .onChange(of: currentPage) { _, newValue in
                                progressVM.updateProgress(bookId: book.id, current: newValue, total: totalPages)
                            }
                        
                        Stepper("Total de páginas: \(totalPages)", value: $totalPages, in: 0...10000)
                            .onChange(of: totalPages) { _, newValue in
                                progressVM.updateProgress(bookId: book.id, current: currentPage, total: newValue)
                            }
                    }
                    .padding(.vertical, 5)
                }
                .onAppear {
                    if let savedProgress = progressVM.getProgress(bookId: book.id) {
                        currentPage = savedProgress.currentPage
                        totalPages = savedProgress.totalPages
                    }
                }
            }
#endif
        }
        .navigationTitle(book.title.isEmpty ? "Nuevo libro" : book.title)
    }
}