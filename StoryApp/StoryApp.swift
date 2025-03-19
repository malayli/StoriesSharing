import SwiftUI

@main
struct StoryApp: App {
    private let storiesRepository = StoriesRepository(fileManager: FileManager.default)
    private let storiesViewModel: StoriesViewModel

    init() {
        self.storiesViewModel = StoriesViewModel(repository: storiesRepository)
    }

    var body: some Scene {
        WindowGroup {
            StoryListView()
                .environmentObject(storiesRepository)
                .environmentObject(storiesViewModel)
        }
    }
}
