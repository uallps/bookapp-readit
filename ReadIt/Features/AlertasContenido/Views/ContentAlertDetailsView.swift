#if AlertasContenido
import SwiftUI

struct ContentAlertDetailsView: View {
    let bookId: UUID
    @Environment(AppConfig.self) private var config
    @Environment(ContentAlertsViewModel.self) private var alertsVM

    var body: some View {
        if config.enableContentAlerts {
            let vm = alertsVM
            let id = bookId
            Section(header: Text("Avisos de contenido")) {
                Toggle("Contenido sensible", isOn: Binding(
                    get: { vm.hasSensitiveContent(for: id) },
                    set: { vm.setSensitiveContent($0, for: id) }
                ))
            }
        }
    }
}
#endif
