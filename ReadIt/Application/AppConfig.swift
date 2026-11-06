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

    @ObservationIgnored private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        showDueDates = defaults.object(forKey: "showDueDates") as? Bool ?? true
        showPriorities = defaults.object(forKey: "showPriorities") as? Bool ?? true
    }

    private func store(_ value: Bool, forKey key: String) {
        defaults.set(value, forKey: key)
        // En Linux y Windows, UserDefaults escribe en disco más tarde: lo forzamos ya.
        defaults.synchronize()
    }
}
