import SwiftUI
import Combine

final class StoriesViewModel: ObservableObject {
    @Published var stories: [Story] = []
    private let repository: StoriesRepository
    private var cancellables = Set<AnyCancellable>()
    private var allPages: [[Story]] = []
    private(set) var storyViewModels: [StoryViewModel] = []
    private var viewModelsCache: [Int: StoryViewModel] = [:]
    private var currentPageIndex = 0

    init(repository: StoriesRepository) {
        self.repository = repository
        loadStoriesFromJSON()
        loadSavedStoryStates()
    }
}

// MARK: - Internal API

extension StoriesViewModel {
    /// Last story identifier.
    var lastId: Int? {
        stories.last?.id
    }

    func index(for storyId: Int) -> Int? {
        stories.firstIndex(where: { $0.id == storyId })
    }

    func loadNextPage() {
        guard currentPageIndex < allPages.count else {
            CustomLogger.warning("⚠️ No more pages to load!")
            return
        }

        stories.append(contentsOf: allPages[currentPageIndex])
        loadSavedStoryStates()
        CustomLogger.debug("📌 Loaded page \(currentPageIndex + 1), total stories: \(stories.count)")
        currentPageIndex += 1
        updateStoryViewModels()
    }
}

// MARK: - Private API

extension StoriesViewModel {
    func loadStoriesFromJSON() {
        guard let url = Bundle.main.url(forResource: "stories", withExtension: "json") else {
            CustomLogger.error("❌ JSON file not found!")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let response = try JSONDecoder().decode(PaginatedResponse.self, from: data)
            allPages = response.pages.map { $0.stories }

            if allPages.isEmpty {
                CustomLogger.warning("⚠️ JSON loaded but pages array is empty!")
            } else {
                CustomLogger.debug("✅ JSON loaded successfully! Total pages: \(allPages.count)")
                loadNextPage()  // Load the first page immediately
            }
        } catch {
            CustomLogger.error("❌ Error decoding JSON: \(error)")
        }
    }

    func loadSavedStoryStates() {
        guard let savedStates = try? repository.storyStates() else {
            CustomLogger.warning("Could not load story states.")
            return
        }

        for index in stories.indices {
            if let state = savedStates[stories[index].id] {
                stories[index].seen = state.seen
                stories[index].liked = state.liked
            }
        }
    }

    func updateStoryViewModels() {
        let storiesPublisher = $stories.eraseToAnyPublisher()

        storyViewModels = stories.map { story in
            if let existingVM = viewModelsCache[story.id] {
                return existingVM
            } else {
                let vm = StoryViewModel(
                    storyId: story.id,
                    storiesPublisher: storiesPublisher,
                    repository: repository
                )
                vm.publisher
                    .sink { [weak self] updatedStory in
                        if let index = self?.stories.firstIndex(where: { $0.id == updatedStory.id }) {
                            self?.stories[index] = updatedStory
                        }
                    }
                    .store(in: &cancellables)
                viewModelsCache[story.id] = vm
                return vm
            }
        }
    }
}
