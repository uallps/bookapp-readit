import SwiftUI

/// Detalle de un libro. Recibe un enlace (@Binding) al libro de la lista:
/// lo que se edita aquí cambia el libro del ViewModel, sin copias.
struct BookDetailView: View {
    @Binding var book: Book

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
        }
        .navigationTitle(book.title.isEmpty ? "Nuevo libro" : book.title)
    }
}