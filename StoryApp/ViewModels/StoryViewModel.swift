import Foundation
import Combine

final class StoryViewModel: ObservableObject, Identifiable {
    @Published private(set) var story: Story
    private var cancellables = Set<AnyCancellable>()
    private let repository: StoriesRepository
    private let storyId: Int
    private let storyUpdateSubject = PassthroughSubject<Story, Never>()

    init(storyId: Int,
         storiesPublisher: AnyPublisher<[Story], Never>,
         repository: StoriesRepository) {
        self.storyId = storyId
        self.repository = repository
        self.story = Story(id: storyId, name: "", profilePictureURL: "", seen: false, liked: false)

        storiesPublisher
            .compactMap { $0.first(where: { $0.id == storyId }) }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.story = $0 }
            .store(in: &cancellables)
    }

    var publisher: AnyPublisher<Story, Never> {
        storyUpdateSubject.eraseToAnyPublisher()
    }

    func toggleLike() {
        story.liked.toggle()
        storyUpdateSubject.send(story)
        try? repository.save(story: story)
    }

    func markAsSeen() throws {
        story.seen = true
        storyUpdateSubject.send(story)
        try repository.save(story: story)
    }

    var id: Int { story.id }
    var name: String { story.name }
    var profilePictureURL: String { story.profilePictureURL }
    var seen: Bool { story.seen }
    var isLiked: Bool { story.liked }
}

extension StoryViewModel: Hashable {
    static func == (lhs: StoryViewModel, rhs: StoryViewModel) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
