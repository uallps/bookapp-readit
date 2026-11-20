#if BusquedaOrden
import SwiftUI

struct BookSearchSortControls: View {
    @Bindable var viewModel: BookSearchSortViewModel

    var body: some View {
        TextField("Buscar por título o autor", text: $viewModel.searchText)
        Picker("Ordenar por", selection: $viewModel.sortOrder) {
            ForEach(BookSortOrder.allCases) { order in
                Text(order.title).tag(order)
            }
        }
    }
}
#endif
