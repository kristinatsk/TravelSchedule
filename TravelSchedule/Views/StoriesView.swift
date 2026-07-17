import SwiftUI

struct StoriesView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel: StoriesViewModel
    @Binding var stories: [Story]
    
    init(
        stories: Binding<[Story]>,
        initialIndex: Int
    ) {
        self._stories = stories
        self._viewModel = State(initialValue: StoriesViewModel(currentStoryIndex: initialIndex, currentProgress: 0, storiesCount: stories.wrappedValue.count))
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            StoriesTabView(stories: stories, currentStoryIndex: $viewModel.currentStoryIndex)
                .onChange(of: viewModel.currentStoryIndex) { oldValue, newValue in
                    viewModel.didChangeCurrentIndex(oldIndex: oldValue, newIndex: newValue)
                    markStoryAsSeen(at: viewModel.currentStoryIndex)
                }
            CloseButton(action: { dismiss() })
                .padding(.top, 57)
                .padding(.trailing, 12)
            StoriesProgressBar(
                currentProgress: $viewModel.currentProgress,
                storiesCount: stories.count
            )
            .padding(.init(top: 28, leading: 12, bottom: 12, trailing: 12))
            .onChange(of: viewModel.currentProgress) { _, newValue in
                viewModel.didChangeCurrentProgress(newProgress: newValue)
            }
        }
        .onAppear {
            viewModel.startTimer()
        }
        .onDisappear {
            viewModel.stopTimer()
        }
        .onReceive(viewModel.timer) { _ in
            viewModel.timerTick()
        }
    }
    
    private func markStoryAsSeen(at index: Int) {
        guard stories.indices.contains(index) else { return }
        stories[index].hasSeen = true
    }
}

#Preview {
    StoriesView(stories: .constant(Story.mockData), initialIndex: 0)
}
