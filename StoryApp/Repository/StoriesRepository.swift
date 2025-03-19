import Foundation

final class StoriesRepository: ObservableObject {
    private let storageFileName: String
    private let fileManager: FileManager
    private let jsonEncoder = JSONEncoder()

    init(storageFileName: String = StorageKeys.storageFileName,
         fileManager: FileManager) {
        self.storageFileName = storageFileName
        self.fileManager = fileManager
    }

    /// Load Story States (seen & liked) from JSON file
    func storyStates() throws -> [Int: StoryState] {
        let fileURL = fileManager.url(for: storageFileName)
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return [:]
        }

        return try JSONDecoder().decode([Int: StoryState].self,
                                        from: Data(contentsOf: fileURL))
    }

    /// Save Story States (seen & liked) to JSON file
    func save(story: Story) throws {
        var storedStates: [Int: StoryState] = try storyStates()

        storedStates[story.id] = StoryState(seen: story.seen, liked: story.liked)

        try jsonEncoder
            .encode(storedStates)
            .write(to: fileManager.url(for: StorageKeys.storageFileName))
    }
}
