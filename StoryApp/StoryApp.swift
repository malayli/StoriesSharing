import SwiftUI

@main
struct StoryApp: App {
    private let storiesRepository = StoriesRepository()
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
