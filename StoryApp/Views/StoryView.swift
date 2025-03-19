import SwiftUI

struct StoryView: View {
    @ObservedObject var viewModel: StoryViewModel

    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: viewModel.profilePictureURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray
            }
            .ignoresSafeArea()

            VStack {
                HStack {
                    Text(viewModel.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()

                Spacer()

                HStack {
                    Spacer()

                    Button(action: {
                        do {
                            try viewModel.toggleLike()
                        } catch {
                            CustomLogger.error("Error while liking story: \(error)")
                        }
                    }) {
                        Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                            .foregroundColor(viewModel.isLiked ? .red : .white)
                            .font(.largeTitle)
                    }

                    Spacer()
                }
                .frame(height: 60)
                .background(Color.black.opacity(0.6))
            }
        }
        .onAppear {
            do {
                try viewModel.markAsSeen()
            } catch {
                CustomLogger.error("Error while marking as seen story: \(error)")
            }
        }
    }
}
