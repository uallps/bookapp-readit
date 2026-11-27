#if AlertasContenido
import SwiftUI

struct ContentAlertDetailsView: View {
    let bookId: UUID
    @Environment(AppConfig.self) private var config
    @Environment(ContentAlertsViewModel.self) private var alertsVM

    var body: some View {
        if config.enableContentAlerts {
            Section(header: Text("Avisos de contenido")) {
                Toggle("Contenido sensible", isOn: Binding(
                    get: { alertsVM.hasSensitiveContent(for: bookId) },
                    set: { alertsVM.setSensitiveContent($0, for: bookId) }
                ))
            }
        }
    }
}
#endif
