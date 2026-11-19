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

    // F3: Categorías
    var enableCategories: Bool {
        didSet { store(enableCategories, forKey: "enableCategories") }
    }

    // F4: Valoraciones
    var enableRatings: Bool {
        didSet { store(enableRatings, forKey: "enableRatings") }
    }

    // F5: Estadísticas
    var enableStats: Bool {
        didSet { store(enableStats, forKey: "enableStats") }
    }

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

        enableCategories = defaults.object(forKey: "enableCategories") as? Bool ?? false
        enableRatings = defaults.object(forKey: "enableRatings") as? Bool ?? false
        enableStats = defaults.object(forKey: "enableStats") as? Bool ?? false
    }

    private func store(_ value: Bool, forKey key: String) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
}