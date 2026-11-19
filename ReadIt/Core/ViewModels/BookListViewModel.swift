import SwiftUI

/// Vista principal que lista los libros de la biblioteca.
struct BookListView: View {
    @Environment(BookListViewModel.self) private var viewModel
    @Environment(AppConfig.self) private var config

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.books) { book in
#if Prioridades
                    BookRowView(
                        book: book,
                        showDueDates: config.showDueDates,
                        showPriorities: config.showPriorities
                    )
#else
                    BookRowView(
                        book: book,
                        showDueDates: config.showDueDates
                    )
#endif
                    .contextMenu {
                        Button(role: .destructive) {
                            viewModel.removeBook(id: book.id)
                        } label: {
                            Label("Eliminar", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Libros")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        viewModel.addBook()
                    }) {
                        Label("Añadir libro", systemImage: "plus")
                    }
                }
            }
        }
    }
}