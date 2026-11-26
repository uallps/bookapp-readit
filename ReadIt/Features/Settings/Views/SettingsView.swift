import SwiftUI

struct SettingsView: View {
    @Environment(AppConfig.self) private var config

    var body: some View {
        @Bindable var config = config
        Form {
            Section(header: Text("Características")) {
#if FechaObjetivo
                // Fecha objetivo (O2)
                Toggle("Mostrar fecha objetivo", isOn: $config.showDueDates)
#endif
#if Recordatorios
                // Recordatorios (O3)
                Toggle("Activar recordatorios", isOn: $config.enableReminders)
#endif
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
#if BusquedaOrden
                Toggle("Activar búsqueda y ordenación", isOn: $config.enableSearchAndSort)
#endif
#if AlertasContenido
                Toggle("Mostrar alertas de contenido sensible", isOn: $config.enableContentAlerts)
#endif
#if Temporizador
                Toggle("Activar temporizador de lectura", isOn: $config.enableTimer)
#endif
#if Valoraciones
                Toggle("Activar valoraciones y reseñas", isOn: $config.enableRatings)
#endif
            }

#if canImport(SwiftData)
            Section(header: Text("Almacenamiento")) {
                Picker("Guardar los libros en", selection: $config.storageType) {
                    ForEach(StorageType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
            }
#endif
        }
        .navigationTitle("Ajustes")
    }
}