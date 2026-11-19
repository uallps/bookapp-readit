import Foundation
import Observation

/// Feature flags en ejecución: qué características muestra la app.
/// Es configuración de la aplicación, no datos de los libros. Cada flag se guarda en
/// UserDefaults al cambiar, así que se conserva al cerrar y volver a abrir la app.
@Observable
final class AppConfig {
    var showDueDates: Bool {
        didSet { store(showDueDates, forKey: "showDueDates") }
    }
    var showPriorities: Bool {
        didSet { store(showPriorities, forKey: "showPriorities") }
    }
    
    // F1: Progreso (desactivado por defecto)
    var enableProgress: Bool {
        didSet { store(enableProgress, forKey: "enableProgress") }
    }
    
    // F2: Notas (desactivado por defecto)
    var enableNotes: Bool {
        didSet { store(enableNotes, forKey: "enableNotes") }
    }
    
    // F3: Categorías (desactivado por defecto)
    var enableCategories: Bool {
        didSet { store(enableCategories, forKey: "enableCategories") }
    }
    
    // F4: Valoraciones (desactivado por defecto)
    var enableRatings: Bool {
        didSet { store(enableRatings, forKey: "enableRatings") }
    }
    
    // F5: Estadísticas (desactivado por defecto)
    var enableStats: Bool {
        didSet { store(enableStats, forKey: "enableStats") }
    }

    @ObservationIgnored private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        showDueDates = defaults.object(forKey: "showDueDates") as? Bool ?? true
        showPriorities = defaults.object(forKey: "showPriorities") as? Bool ?? true
        
        // F1-F5 leen de UserDefaults o empiezan en false[cite: 47]
        enableProgress = defaults.object(forKey: "enableProgress") as? Bool ?? false
        enableNotes = defaults.object(forKey: "enableNotes") as? Bool ?? false
        enableCategories = defaults.object(forKey: "enableCategories") as? Bool ?? false
        enableRatings = defaults.object(forKey: "enableRatings") as? Bool ?? false
        enableStats = defaults.object(forKey: "enableStats") as? Bool ?? false
    }

    private func store(_ value: Bool, forKey key: String) {
        defaults.set(value, forKey: key)
        // En Linux y Windows, UserDefaults escribe en disco más tarde: lo forzamos ya.
        defaults.synchronize()
    }
}