#if AlertasContenido
import Foundation
import Observation

/// Plugin de datos para gestionar las alertas de contenido sensible (O8).
@Observable
final class ContentAlertsViewModel: DataPlugin {
    let name = "Alertas de contenido"

    /// Cada cambio en las alertas se guarda automáticamente en book-alerts.json.
    var alerts: [UUID: BookContentAlert] = [:] {
        didSet { save() }
    }

    @ObservationIgnored private let storageProvider: AlertStorageProvider
    @ObservationIgnored private var loaded = false

    init(storageProvider: AlertStorageProvider = JSONAlertStorageProvider()) {
        self.storageProvider = storageProvider
        _Concurrency.Task { await loadAlerts() }
    }

    func loadAlerts() async {
        guard !loaded else { return }
        loaded = true
        do {
            let list = try await storageProvider.loadAlerts()
            alerts = Dictionary(uniqueKeysWithValues: list.map { ($0.bookId, $0) })
        } catch {
            print("No se han cargado alertas de contenido: \(error)")
        }
    }

    func hasSensitiveContent(for bookId: UUID) -> Bool {
        alerts[bookId]?.hasSensitiveContent ?? false
    }

    func setSensitiveContent(_ hasSensitiveContent: Bool, for bookId: UUID) {
        if hasSensitiveContent {
            alerts[bookId] = BookContentAlert(bookId: bookId, hasSensitiveContent: true)
        } else {
            alerts.removeValue(forKey: bookId)
        }
    }

    // MARK: - DataPlugin

    func willDeleteBook(_ book: Book) {
        guard alerts[book.id] != nil else { return }
        alerts.removeValue(forKey: book.id)
        print("\(name): borrada la alerta de contenido de «\(book.title)»")
    }

    func didDeleteBook(id: UUID) {
        print("\(name): el libro \(id) ya no existe")
    }

    private func save() {
        let items = Array(alerts.values)
        _Concurrency.Task {
            do {
                try await storageProvider.saveAlerts(items)
            } catch {
                print("No se han guardado las alertas de contenido: \(error)")
            }
        }
    }
}
#endif
