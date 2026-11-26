#if Progreso
import Foundation

protocol ProgressStorageProvider {
    func loadProgresses() async throws -> [BookProgress]
    func saveProgresses(_ progresses: [BookProgress]) async throws
}

final class JSONProgressStorageProvider: ProgressStorageProvider {
    private let fileURL: URL

    init(filename: String = "book-progress.json") {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL = documents.appendingPathComponent(filename)
    }

    func loadProgresses() async throws -> [BookProgress] {
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([BookProgress].self, from: data)
    }

    func saveProgresses(_ progresses: [BookProgress]) async throws {
        let data = try JSONEncoder().encode(progresses)
        try FileManager.default.createDirectory(
            at: fileURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try data.write(to: fileURL)
    }
}
#endif