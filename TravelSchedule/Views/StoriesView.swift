import SwiftUI

struct StoriesView: View {
    let stories: [Story]
    private var timerConfiguration: TimerConfiguration { .init(storiesCount: stories.count)}
    @Environment(\.dismiss) var dismiss
    @State private var currentStoryIndex: Int
    @State private var currentProgress: CGFloat = 0
    
    init(stories: [Story], initialIndex: Int) {
        self.stories = stories
        self._currentStoryIndex = State(initialValue: initialIndex)
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            StoriesTabView(stories: stories, currentStoryIndex: $currentStoryIndex)
                .onChange(of: currentStoryIndex) { oldValue, newValue in
                    didChangeCurrentIndex(oldIndex: oldValue, newIndex: newValue)
                }
            CloseButton(action: { dismiss() })
                .padding(.top, 57)
                .padding(.trailing, 12)
            StoriesProgressBar(
                storiesCount: stories.count,
                timerConfiguration: timerConfiguration,
                currentProgress: $currentProgress
            )
            .padding(.init(top: 28, leading: 12, bottom: 12, trailing: 12))
            .onChange(of: currentProgress) { _, newValue in
                didChangeCurrentProgress(newProgress: newValue)
            }
        }
    }
    
    private func didChangeCurrentIndex(oldIndex: Int, newIndex: Int) {
        guard oldIndex != newIndex else { return }
        let progress = timerConfiguration.progress(for: newIndex)
        guard abs(progress - currentProgress) >= 0.01 else { return }
        withAnimation {
            currentProgress = progress
        }
    }
    
    private func didChangeCurrentProgress(newProgress: CGFloat) {
        let index = timerConfiguration.index(for: newProgress)
        guard index != currentStoryIndex else { return }
        withAnimation {
            currentStoryIndex = index
        }
    }
}

#Preview {
    StoriesView(stories: Story.mockData, initialIndex: 0)
}
