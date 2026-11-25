import Foundation
import Observation

/// Feature flags en ejecución: qué características muestra la app.
@Observable
final class AppConfig {
    var showDueDates: Bool {
        didSet { store(showDueDates, forKey: "showDueDates") }
    }

    var showPriorities: Bool {
        didSet { store(showPriorities, forKey: "showPriorities") }
    }

    // F1: Progreso
    var enableProgress: Bool {
        didSet { store(enableProgress, forKey: "enableProgress") }
    }

#if Notas
    // F2: Notas (activado por defecto bajo el flag de compilación #if Notas)
    var enableNotes: Bool {
        didSet { store(enableNotes, forKey: "enableNotes") }
    }
#endif

#if ListaDeseos
    // Feature opcional: Lista de Deseos (activada por defecto bajo #if ListaDeseos)
    var enableWishlist: Bool {
        didSet { store(enableWishlist, forKey: "enableWishlist") }
    }
#endif

#if Categorias
    var enableCategories: Bool {
        didSet { store(enableCategories, forKey: "enableCategories") }
    }
#endif
#if BusquedaOrden
    var enableSearchAndSort: Bool {
        didSet { store(enableSearchAndSort, forKey: "enableSearchAndSort") }
    }
#endif
#if AlertasContenido
    var enableContentAlerts: Bool {
        didSet { store(enableContentAlerts, forKey: "enableContentAlerts") }
    }
#endif

    // F4: Valoraciones
    var enableRatings: Bool {
        didSet { store(enableRatings, forKey: "enableRatings") }
    }

    // F5: Estadísticas
    var enableStats: Bool {
        didSet { store(enableStats, forKey: "enableStats") }
    }

    // O4: Temporizador en vivo (desactivado por defecto)
    var enableTimer: Bool {
        didSet { store(enableTimer, forKey: "enableTimer") }
    }

#if Recordatorios
    // O3: Recordatorios
    var enableReminders: Bool {
        didSet { store(enableReminders, forKey: "enableReminders") }
    }
#endif

    @ObservationIgnored private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        showDueDates = defaults.object(forKey: "showDueDates") as? Bool ?? true
        showPriorities = defaults.object(forKey: "showPriorities") as? Bool ?? true

        // F1-F5 leen de UserDefaults
        enableProgress = defaults.object(forKey: "enableProgress") as? Bool ?? false
        
#if Notas
        // Se inicializa a true por defecto cuando el módulo Notas está compilado
        enableNotes = defaults.object(forKey: "enableNotes") as? Bool ?? true
#endif

#if ListaDeseos
        // Se inicializa a true por defecto cuando el módulo ListaDeseos está compilado
        enableWishlist = defaults.object(forKey: "enableWishlist") as? Bool ?? true
#endif

#if Categorias
        enableCategories = defaults.object(forKey: "enableCategories") as? Bool ?? false
#endif
#if BusquedaOrden
        enableSearchAndSort = defaults.object(forKey: "enableSearchAndSort") as? Bool ?? true
#endif
#if AlertasContenido
        enableContentAlerts = defaults.object(forKey: "enableContentAlerts") as? Bool ?? true
#endif
        enableRatings = defaults.object(forKey: "enableRatings") as? Bool ?? false
        enableStats = defaults.object(forKey: "enableStats") as? Bool ?? false

        // O4: Temporizador en vivo
        enableTimer = defaults.object(forKey: "enableTimer") as? Bool ?? false

#if Recordatorios
        // Se activa por defecto cuando Recordatorios está compilado
        enableReminders = defaults.object(forKey: "enableReminders") as? Bool ?? true
#endif
    }

    private func store(_ value: Bool, forKey key: String) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
}