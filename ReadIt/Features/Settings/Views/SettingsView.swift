import SwiftUI

/// Pantalla de Ajustes: activa o desactiva las características en ejecución.
struct SettingsView: View {
    @Environment(AppConfig.self) private var config

    var body: some View {
        @Bindable var config = config
        Form {
            Section(header: Text("Características")) {
                Toggle("Mostrar fechas de vencimiento", isOn: $config.showDueDates)
#if Prioridades
                Toggle("Mostrar prioridades", isOn: $config.showPriorities)
#endif
            }
        }
        .navigationTitle("Ajustes")
    }
}
