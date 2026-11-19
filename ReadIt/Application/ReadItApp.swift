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

    var body: some Scene {
        WindowGroup {
#if os(iOS)
            TabView {
                BookListView()
                    .tabItem { Label("Libros", systemImage: "books.vertical") }
                SettingsView()
                    .tabItem { Label("Ajustes", systemImage: "gearshape") }
            }
            .environment(config)
#if Progreso
            .environment(progressVM)
#endif

#else
            NavigationSplitView {
                List(selection: $selection) {
                    NavigationLink(value: "libros") {
                        Label("Libros", systemImage: "books.vertical")
                    }
                    NavigationLink(value: "ajustes") {
                        Label("Ajustes", systemImage: "gearshape")
                    }
                }
            } detail: {
                switch selection {
                case "libros":
                    BookListView()
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

#endif
        }
    }
}