import SwiftUI

@main
struct ReadItApp: App {
    /// Una sola configuración para toda la app: la comparten Libros y Ajustes.
    @State private var config = AppConfig()
    @State private var selection: String? = "libros"

#if Progreso
    @State private var progressVM: ProgressViewModel
#endif

#if Temporizador
    /// ViewModel independiente para O4, solo existe si se compila el producto con Temporizador.
    @State private var timerVM: ReadingTimerViewModel
#endif

#if Notas
    @State private var notesVM: NotesViewModel
#endif

#if Prioridades
    @State private var priorityVM: PriorityViewModel
#endif

    init() {
#if Progreso
        let progress = ProgressViewModel()
        PluginRegistry.shared.register(progress)
        _progressVM = State(wrappedValue: progress)
#endif
#if Temporizador
        let timer = ReadingTimerViewModel()
        PluginRegistry.shared.register(timer)
        _timerVM = State(wrappedValue: timer)
#endif
#if Notas
        let notes = NotesViewModel()
        PluginRegistry.shared.register(notes)
        _notesVM = State(wrappedValue: notes)
#endif
#if Prioridades
        let priorities = PriorityViewModel()
        PluginRegistry.shared.register(priorities)
        _priorityVM = State(wrappedValue: priorities)
#endif
    }

    var body: some Scene {
        WindowGroup {
#if os(iOS)
            TabView {
                BookListView(storageProvider: config.storageType.makeProvider())
                    .id(config.storageType)
                    .tabItem { Label("Libros", systemImage: "books.vertical") }
#if Temporizador
                if config.enableTimer {
                    ReadingTimerView()
                        .tabItem { Label("Temporizador", systemImage: "timer") }
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
#if Notas
            .environment(notesVM)
#endif
#if Prioridades
            .environment(priorityVM)
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
                    NavigationLink(value: "ajustes") {
                        Label("Ajustes", systemImage: "gearshape")
                    }
                }
            } detail: {
                switch selection {
                case "libros":
                    BookListView(storageProvider: config.storageType.makeProvider())
#if Temporizador
                case "temporizador":
                    if config.enableTimer {
                        ReadingTimerView()
                    } else {
                        Text("Activa el temporizador en Ajustes")
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
#if Notas
            .environment(notesVM)
#endif
#if Prioridades
            .environment(priorityVM)
#endif

#endif
        }
    }
}