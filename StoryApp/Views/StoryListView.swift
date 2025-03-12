import SwiftUI

struct StoryListView: View {
    @EnvironmentObject private var storiesRepository: StoriesRepository
    @EnvironmentObject private var viewModel: StoriesViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        ForEach($viewModel.stories) { $story in
                            NavigationLink(destination: StoryView(viewModel: StoryViewModel(story: $story, repository: storiesRepository))) {
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
        }
    }
}
