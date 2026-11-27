#if AlertasContenido
import Foundation

struct BookContentAlert: Codable {
    let bookId: UUID
    var hasSensitiveContent: Bool
}

protocol AlertStorageProvider {
    func loadAlerts() async throws -> [BookContentAlert]
    func saveAlerts(_ alerts: [BookContentAlert]) async throws
}

final class JSONAlertStorageProvider: AlertStorageProvider {
    private let fileURL: URL

    init(filename: String = "book-alerts.json") {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL = documents.appendingPathComponent(filename)
    }

    func loadAlerts() async throws -> [BookContentAlert] {
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([BookContentAlert].self, from: data)
    }

    func saveAlerts(_ alerts: [BookContentAlert]) async throws {
        let data = try JSONEncoder().encode(alerts)
        try FileManager.default.createDirectory(
            at: fileURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try data.write(to: fileURL)
    }
}
#endif
