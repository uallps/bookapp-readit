import Foundation
import Observation

/// Feature flags en ejecución: qué características muestra la app.
@Observable
final class AppConfig {
    var showDueDates: Bool {
        didSet { store(showDueDates, forKey: "showDueDates") }
    }
    
#if Prioridades
    var showPriorities: Bool {
        didSet { store(showPriorities, forKey: "showPriorities") }
    }
#endif

    @ObservationIgnored private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        showDueDates = defaults.object(forKey: "showDueDates") as? Bool ?? true
        
#if Prioridades
        showPriorities = defaults.object(forKey: "showPriorities") as? Bool ?? true
#endif
    }

    private func store(_ value: Bool, forKey key: String) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
}