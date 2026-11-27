#if ListaDeseos
import Foundation
import Observation

@Observable
final class WishlistViewModel: DataPlugin {
    let name = "Lista de deseos"

    private(set) var items: [WishlistEntry] = [] {
        didSet { save() }
    }

    @ObservationIgnored private let storageProvider: WishlistStorageProvider
    @ObservationIgnored private var loaded = false

    init(storageProvider: WishlistStorageProvider = JSONWishlistStorageProvider()) {
        self.storageProvider = storageProvider
        _Concurrency.Task { await load() }
    }

    func load() async {
        guard !loaded else { return }
        loaded = true
        do {
            items = try await storageProvider.loadWishlist()
        } catch {
            print("No se ha cargado la lista de deseos: \(error)")
        }
    }

    func isInWishlist(bookId: UUID) -> Bool {
        items.contains { $0.bookId == bookId }
    }

    func setWishlist(_ inWishlist: Bool, for bookId: UUID) {
        var updated = items.filter { $0.bookId != bookId }
        if inWishlist {
            updated.append(WishlistEntry(bookId: bookId))
        }
        items = updated
    }

    // MARK: - DataPlugin

    func willDeleteBook(_ book: Book) {
        guard isInWishlist(bookId: book.id) else { return }
        setWishlist(false, for: book.id)
        print("\(name): eliminado de la lista de deseos «\(book.title)»")
    }

    func didDeleteBook(id: UUID) {
        print("\(name): el libro \(id) ya no existe")
    }

    private func save() {
        let snapshot = items
        _Concurrency.Task {
            do {
                try await storageProvider.saveWishlist(snapshot)
            } catch {
                print("No se ha guardado la lista de deseos: \(error)")
            }
        }
    }
}
#endif