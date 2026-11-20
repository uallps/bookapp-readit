import SwiftUI

@main
struct ReadItApp: App {
    /// Una sola configuración para toda la app: la comparten Libros y Ajustes.
    @State private var config = AppConfig()
    @State private var selection: String? = "libros"

#if Progreso
    /// ViewModel independiente para F1, solo existe si se compila el producto con Progreso.
    @State private var progressVM = ProgressViewModel()
#endif

#if Temporizador
    /// ViewModel independiente para O4, solo existe si se compila el producto con Temporizador.
    @State private var timerVM = ReadingTimerViewModel()
#endif

    var body: some Scene {
        WindowGroup {
#if os(iOS)
            TabView {
                BookListView()
                    .tabItem { Label("Libros", systemImage: "books.vertical") }
#if Temporizador
                if config.enableTimer {
                    ReadingTimerView()
                        .tabItem { Label("Temporizador", systemImage: "timer") }
                }
#endif
#if Estadisticas
                if config.enableStats {
                    StatsView()
                        .tabItem { Label("Estadísticas", systemImage: "chart.bar") }
                }
#endif
                SettingsView()
                    .tabItem { Label("Ajustes", systemImage: "gearshape") }
            }
            .environment(config)
#if Progreso
            .environment(progressVM)
#endif
#if Temporizador
            .environment(timerVM)
#endif

#else
            NavigationSplitView {
                List(selection: $selection) {
                    NavigationLink(value: "libros") {
                        Label("Libros", systemImage: "books.vertical")
                    }
#if Temporizador
                    if config.enableTimer {
                        NavigationLink(value: "temporizador") {
                            Label("Temporizador", systemImage: "timer")
                        }
                    }
#endif
#if Estadisticas
                    if config.enableStats {
                        NavigationLink(value: "estadisticas") {
                            Label("Estadísticas", systemImage: "chart.bar")
                        }
                    }
#endif
                    NavigationLink(value: "ajustes") {
                        Label("Ajustes", systemImage: "gearshape")
                    }
                }
            } detail: {
                switch selection {
                case "libros":
                    BookListView()
#if Temporizador
                case "temporizador":
                    if config.enableTimer {
                        ReadingTimerView()
                    } else {
                        Text("Activa el temporizador en Ajustes")
                    }
#endif
#if Estadisticas
                case "estadisticas":
                    if config.enableStats {
                        StatsView()
                    } else {
                        Text("Activa las estadísticas en Ajustes")
                    }
#endif
                case "ajustes":
                    SettingsView()
                default:
                    Text("Elige una opción")
                }
            }
            .environment(config)
#if Progreso
            .environment(progressVM)
#endif
#if Temporizador
            .environment(timerVM)
#endif

#endif
        }
    }
}