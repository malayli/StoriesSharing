import SwiftUI

struct StoryListView: View {
    @EnvironmentObject var storiesRepository: StoriesRepository
    @EnvironmentObject var viewModel: StoriesViewModel
    @State private var selectedStoryViewModel: StoryViewModel?

    var body: some View {
        NavigationStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(viewModel.storyViewModels) { storyViewModel in
                        MiniStoryView(viewModel: storyViewModel)
                        .onTapGesture {
                            selectedStoryViewModel = storyViewModel
                        }
                        .onAppear {
                            if storyViewModel.id == viewModel.lastId {
                                viewModel.loadNextPage()
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationDestination(item: $selectedStoryViewModel) { selectedStoryViewModel in
                StoryView(viewModel: selectedStoryViewModel)
            }
        }
    }
}
