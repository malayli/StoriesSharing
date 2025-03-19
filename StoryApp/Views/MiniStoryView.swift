import SwiftUI

struct MiniStoryView: View {
    @ObservedObject var viewModel: StoryViewModel

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: viewModel.profilePictureURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .saturation(viewModel.seen ? 0.2 : 1.0)
            } placeholder: {
                Color.gray
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(viewModel.seen ? Color.gray : Color.blue, lineWidth: 2)
            )

            Text(viewModel.name)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
}
