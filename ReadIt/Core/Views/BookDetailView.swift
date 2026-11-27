import SwiftUI

/// Detalle de un libro.
struct BookDetailView: View {
    @Binding var book: Book
#if Categorias
    let availableCategories: [String]
#endif
    @Environment(AppConfig.self) private var config

#if Progreso
    @Environment(ProgressViewModel.self) private var progressVM
    @State private var currentPage: Int = 0
    @State private var totalPages: Int = 0
#endif

#if Notas
    @Environment(NotesViewModel.self) private var notesVM
#endif

#if Prioridades
    @Environment(PriorityViewModel.self) private var priorityVM
#endif

#if ListaDeseos
    @Environment(WishlistViewModel.self) private var wishlistVM
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

#if Prioridades
            if config.showPriorities {
                let vm = priorityVM
                let bookId = book.id
                Section(header: Text("Prioridad de lectura")) {
                    Picker("Prioridad", selection: Binding(
                        get: { vm.getPriority(bookId: bookId) },
                        set: { vm.setPriority($0, for: bookId) }
                    )) {
                        Text("Sin prioridad").tag(Priority?.none)
                        ForEach(Priority.allCases, id: \.self) { priority in
                            Text(priority.rawValue).tag(Priority?.some(priority))
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
#endif

#if ListaDeseos
            if config.enableWishlist {
                let vm = wishlistVM
                let bookId = book.id
                Section(header: Text("Lista de Deseos")) {
                    Toggle("En lista de deseos / Por comprar", isOn: Binding(
                        get: { vm.isInWishlist(bookId: bookId) },
                        set: { vm.setWishlist($0, for: bookId) }
                    ))
                }
            }
#endif

#if AlertasContenido
            ContentAlertDetailsView(book: $book)
#endif

#if Categorias
            CategoryManagementView(book: $book, availableCategories: availableCategories)
#endif

#if Progreso
            if config.enableProgress {
                Section(header: Text("Progreso de lectura")) {
                    VStack(alignment: .leading, spacing: 12) {
                        let percent = totalPages > 0 ? (Double(currentPage) / Double(totalPages)) : 0.0

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

                        Stepper("Total de páginas: \(totalPages)", value: $totalPages, in: 0...max(totalPages, 10000))
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

#if Notas
            if config.enableNotes {
                let vm = notesVM
                let bookId = book.id
                Section {
                    NotesListView(notes: Binding(
                        get: { vm.getNotes(bookId: bookId) },
                        set: { vm.setNotes($0, for: bookId) }
                    ))
                }
            }
#endif

#if Valoraciones
            if config.enableRatings {
                Section(header: Text("Valoración y reseña")) {
                    RatingView(rating: $book.rating)
                }
            }
#endif

#if FechaObjetivo
            // Fecha objetivo (O2)
            if config.showDueDates {
                Section(header: Text("Fecha objetivo")) {
                    DueDateView(dueDate: $book.dueDate)
                }
            }
#endif
        }
        .navigationTitle(book.title.isEmpty ? "Nuevo libro" : book.title)
    }

}