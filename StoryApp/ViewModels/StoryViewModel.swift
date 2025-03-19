import Foundation
import SwiftUI

final class StoryViewModel: ObservableObject {
    @Binding private var story: Story
    private let repository: StoriesRepository

    init(story: Binding<Story>, repository: StoriesRepository) {
        self._story = story
        self.repository = repository

        if let state = try? repository.storyStates()[self.story.id] {
            Task {
                await MainActor.run {
                    self.story.seen = state.seen
                    self.story.liked = state.liked
                }
            }
        }
    }

    var name: String {
        story.name
    }

    var profilePictureURL: String {
        story.profilePictureURL
    }

    var seen: Bool {
        story.seen
    }

    var isLiked: Bool {
        story.liked
    }

    func markAsSeen() throws {
        story.seen = true
        try repository.save(story: story)
    }

    func toggleLike() throws {
        story.liked.toggle()
        try repository.save(story: story)
    }
}
