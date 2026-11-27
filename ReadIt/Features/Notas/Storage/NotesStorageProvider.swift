#if Notas
import Foundation

struct BookNotes: Codable, Equatable {
    let bookId: UUID
    var notes: [Note]
}

protocol NotesStorageProvider {
    func loadNotes() async throws -> [BookNotes]
    func saveNotes(_ items: [BookNotes]) async throws
}

final class JSONNotesStorageProvider: NotesStorageProvider {
    private let fileURL: URL

    init(fileName: String = "book-notes.json") {
        let baseDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? FileManager.default.temporaryDirectory
        let appDir = baseDir.appendingPathComponent("ReadIt", isDirectory: true)
        try? FileManager.default.createDirectory(at: appDir, withIntermediateDirectories: true)
        self.fileURL = appDir.appendingPathComponent(fileName)
    }

    func loadNotes() async throws -> [BookNotes] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return [] }
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([BookNotes].self, from: data)
    }

    func saveNotes(_ items: [BookNotes]) async throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(items)
        try data.write(to: fileURL, options: .atomic)
    }
}
#endif