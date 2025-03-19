import SwiftUI

struct StoryListView: View {
    @EnvironmentObject private var storiesRepository: StoriesRepository
    @EnvironmentObject private var viewModel: StoriesViewModel
    @State private var path = NavigationPath()
    @State private var selectedStoryId: Int?

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        ForEach($viewModel.stories) { $story in
                            Button(action: {
                                selectedStoryId = story.id
                                path.append(story.id)
                            }) {
                                MiniStoryView(viewModel: StoryViewModel(story: $story, repository: storiesRepository))
                            }
                            .onAppear {
                                if story.id == viewModel.lastId {
                                    viewModel.loadNextPage()
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                .frame(maxHeight: 200)

                Spacer()
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationTitle("Stories")
            .navigationDestination(isPresented: Binding(
                get: {
                    selectedStoryId != nil
                },
                set: {
                    if !$0 {
                        selectedStoryId = nil
                    }
                }
            )) {
                if let storyId = selectedStoryId,
                   let storyIndex = viewModel.index(for: storyId) {
                    StoryView(viewModel: StoryViewModel(story: $viewModel.stories[storyIndex], repository: storiesRepository))
                }
            }
        }
    }
}
