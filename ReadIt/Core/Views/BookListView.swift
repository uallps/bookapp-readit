import SwiftUI

struct BookListView: View {
    @State private var viewModel = BookListViewModel()
    @State private var selectedBookID: UUID?
#if Categorias
    @State private var categoriesViewModel = CategoriesViewModel()
    @State private var selectedCategory: String?
#endif
#if ListaDeseos
    @State private var showingWishlist = false
#endif
#if BusquedaOrden
    @State private var searchSortViewModel = BookSearchSortViewModel()
#endif
    /// La configuración la crea la app y llega por el entorno: es la misma que edita Ajustes.
    @Environment(AppConfig.self) private var config

    var body: some View {
        NavigationStack {
            if let book = selectedBook {
                detailView(for: book)
                    .toolbar {
#if os(macOS)
                        ToolbarItem(placement: .navigation) {
                            backButton
                        }
#elseif os(iOS)
                        ToolbarItem(placement: .navigationBarLeading) {
                            backButton
                        }
#else
                        ToolbarItem(placement: .leading) {
                            backButton
                        }
#endif
                    }
            } else {
                List {
#if BusquedaOrden
                    if config.enableSearchAndSort {
                        Section {
                            BookSearchSortControls(viewModel: searchSortViewModel)
                        }
                    }
#endif
                    if shouldShowFilterSection {
                        Section {
#if Categorias
                            CategoryFilterView(
                                categories: categories,
                                selectedCategory: $selectedCategory,
                                isAllSelected: isAllCategorySelected
                            ) {
#if ListaDeseos
                                showingWishlist = false
#endif
                            }
#endif
#if ListaDeseos
                            if config.enableWishlist {
                                filterButton("Wishlist", isSelected: showingWishlist) {
                                    showingWishlist = true
#if Categorias
                                    selectedCategory = nil
#endif
                                }
                            }
#endif
                        }
                    }

                    ForEach(filteredBooks) { book in
                        bookRow(book: book)
                    }
                }
                .toolbar {
                    Button("Añadir libro") {
                        viewModel.addBook()
                    }
                }
                .navigationTitle("Libros")
            }
        }
    }

    private var selectedBook: Book? {
        guard let selectedBookID else { return nil }
        return viewModel.book(id: selectedBookID)
    }

    private func detailView(for book: Book) -> some View {
#if Categorias
        BookDetailView(book: binding(for: book), availableCategories: categories)
#else
        BookDetailView(book: binding(for: book))
#endif
    }

#if Categorias
    private var categories: [String] {
        categoriesViewModel.categories(in: viewModel.books)
    }

    private var isAllCategorySelected: Bool {
#if ListaDeseos
        selectedCategory == nil && !showingWishlist
#else
        selectedCategory == nil
#endif
    }
#endif

    private var filteredBooks: [Book] {
        var books = viewModel.books
#if ListaDeseos
        if showingWishlist {
            books = books.filter { $0.isWishlist }
        }
#endif
#if Categorias
        if config.enableCategories, selectedCategory != nil {
            books = categoriesViewModel.filteredBooks(books, by: selectedCategory)
        }
#endif
#if BusquedaOrden
        if config.enableSearchAndSort {
            books = searchSortViewModel.filteredAndSortedBooks(books)
        }
#endif
        return books
    }

#if ListaDeseos
    private func filterButton(_ title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(isSelected ? Color.bookAccent : Color.secondary.opacity(0.15))
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
#endif

    private var shouldShowFilterSection: Bool {
#if Categorias
        if config.enableCategories { return true }
#endif
#if ListaDeseos
        if config.enableWishlist { return true }
#endif
        return false
    }

    /// Fila con control de estado, acceso al detalle y menú contextual.
    private func bookRow(book: Book) -> some View {
        HStack(spacing: 8) {
            Button {
                let newState: ReadingState = book.state == .finished ? .pending : .finished
                viewModel.updateState(id: book.id, to: newState)
            } label: {
                Image(systemName: book.state == .finished ? "checkmark.circle.fill" : "circle")
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(book.state == .finished ? "Marcar como pendiente" : "Marcar como terminado")

            Button(action: { selectedBookID = book.id }) {
                BookRowView(
                    book: book,
                    showDueDates: config.showDueDates,
                    showPriorities: config.showPriorities
                )
                .contextMenu {
                    Button("Eliminar libro") {
                        viewModel.removeBook(id: book.id)
                    }
                }
            }
            .buttonStyle(.plain)
        }
    }

    private var backButton: some View {
        Button("<- Back") {
            selectedBookID = nil
        }
        .frame(height: 48)
    }

    /// Binding para que el detalle edite el libro a través del ViewModel.
    private func binding(for book: Book) -> Binding<Book> {
        Binding(
            get: { viewModel.book(id: book.id) ?? book },
            set: { viewModel.updateBook($0) }
        )
    }

}