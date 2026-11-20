#if AlertasContenido
import SwiftUI

struct ContentAlertDetailsView: View {
    @Binding var book: Book
    @Environment(AppConfig.self) private var config

    var body: some View {
        if config.enableContentAlerts {
            Section(header: Text("Avisos de contenido")) {
                Toggle("Contenido sensible", isOn: $book.hasSensitiveContent)
            }
        }
    }
}
#endif
