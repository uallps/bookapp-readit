import SwiftUI

struct SettingsView: View {
    @Environment(AppConfig.self) private var config

    var body: some View {
        @Bindable var config = config
        Form {
            Section(header: Text("Características")) {
                Toggle("Mostrar fecha objetivo", isOn: $config.showDueDates)
#if Prioridades
                Toggle("Mostrar prioridades", isOn: $config.showPriorities)
#endif
#if Progreso
                // Solo compila si el trait Progreso está activo
                Toggle("Activar progreso de lectura", isOn: $config.enableProgress)
#endif
#if Categorias
                Toggle("Activar categorías", isOn: $config.enableCategories)
#endif
#if Temporizador
                Toggle("Activar temporizador de lectura", isOn: $config.enableTimer)
#endif
            }

            Section(header: Text("Persistencia (O5)")) {
                Text("Motor activo: \(StorageFactory.activeEngineName)")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Ajustes")
    }
}