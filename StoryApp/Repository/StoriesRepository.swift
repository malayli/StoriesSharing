import Foundation

final class StoriesRepository: ObservableObject {
    private let storageFileName: String
    private let fileManager: FileManager = FileManager.default

    init(storageFileName: String = StorageKeys.storageFileName) {
        self.storageFileName = storageFileName
    }

    /// Save Story States (seen & liked) to JSON file
    func saveStoryStates(_ stories: [Story]) {
        var storedStates: [Int: StoryState] = [:]

        for story in stories {
            storedStates[story.id] = StoryState(seen: story.seen, liked: story.liked)
        }

        if let newData = try? JSONEncoder().encode(storedStates) {
            try? newData.write(to: fileManager.url(for: storageFileName))
        }
    }

    /// Load Story States (seen & liked) from JSON file
    func loadStoryStates() -> [Int: StoryState] {
        let fileURL = FileManager.default.url(for: storageFileName)
        guard fileManager.fileExists(atPath: fileURL.path) else { return [:] }

        if let data = try? Data(contentsOf: fileURL),
           let storedStates = try? JSONDecoder().decode([Int: StoryState].self, from: data) {
            return storedStates
        }

        return [:]
    }

    /// Save Story States (seen & liked) to JSON file
    func save(story: Story) {
        var storedStates: [Int: StoryState] = loadStoryStates()

        storedStates[story.id] = StoryState(seen: story.seen, liked: story.liked)

        if let newData = try? JSONEncoder().encode(storedStates) {
            try? newData.write(to: FileManager.default.url(for: StorageKeys.storageFileName))
        }
    }
}
