#if Prioridades
import Foundation

struct BookPriority: Codable, Equatable {
    let bookId: UUID
    var priority: Priority
}

protocol PriorityStorageProvider {
    func loadPriorities() async throws -> [BookPriority]
    func savePriorities(_ items: [BookPriority]) async throws
}

final class JSONPriorityStorageProvider: PriorityStorageProvider {
    private let fileURL: URL

    init(fileName: String = "book-priorities.json") {
        let baseDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? FileManager.default.temporaryDirectory
        let appDir = baseDir.appendingPathComponent("ReadIt", isDirectory: true)
        try? FileManager.default.createDirectory(at: appDir, withIntermediateDirectories: true)
        self.fileURL = appDir.appendingPathComponent(fileName)
    }

    func loadPriorities() async throws -> [BookPriority] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return [] }
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([BookPriority].self, from: data)
    }

    func savePriorities(_ items: [BookPriority]) async throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(items)
        try data.write(to: fileURL, options: .atomic)
    }
}
#endif