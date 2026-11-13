import SwiftUI

/// Detalle de un libro. Recibe un enlace (@Binding) al libro de la lista:
/// lo que se edita aquí cambia el libro del ViewModel, sin copias.
struct BookDetailView: View {
    @Binding var book: Book
    let availableCategories: [String]
    @State private var newCategory = ""

    var body: some View {
        Form {
            Section(header: Text("Información del libro")) {
                TextField("Título del libro", text: $book.title)
                
                // Como el autor es opcional (String?), creamos un Binding manual
                // para que si el TextField se queda vacío, se guarde como nil.
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
                .pickerStyle(.segmented) // O el estilo que más os guste
            }

            Section(header: Text("Categorías asignadas")) {
                if book.categories.isEmpty {
                    Text("Sin categorías")
                        .foregroundColor(.secondary)
                }

                ForEach(book.categories, id: \.self) { category in
                    HStack {
                        Text(category)
                        Spacer()
                        Button("Quitar") {
                            book.removeCategory(category)
                        }
                    }
                }
            }

            Section(header: Text("Añadir categoría existente")) {
                if availableCategories.isEmpty {
                    Text("Todavía no hay categorías en la biblioteca")
                        .foregroundColor(.secondary)
                } else if availableCategoriesToAdd.isEmpty {
                    Text("Este libro ya tiene todas las categorías existentes")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(availableCategoriesToAdd, id: \.self) { category in
                        Button(category) {
                            book.addCategory(category)
                        }
                    }
                }
            }

            Section(header: Text("Crear categoría")) {
                TextField("Nombre de la categoría", text: $newCategory)
                Button("Añadir categoría") {
                    book.addCategory(newCategory)
                    newCategory = ""
                }
                .disabled(newCategory.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .navigationTitle(book.title.isEmpty ? "Nuevo libro" : book.title)
    }

    private var availableCategoriesToAdd: [String] {
        availableCategories.filter { category in
            !book.categories.contains {
                $0.caseInsensitiveCompare(category) == .orderedSame
            }
        }
    }
}