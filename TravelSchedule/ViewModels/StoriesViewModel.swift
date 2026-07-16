import SwiftUI

@Observable
final class StoriesViewModel {
    var currentStoryIndex: Int
    var currentProgress: CGFloat
    var storiesCount: Int
    var timerConfiguration: TimerConfiguration { .init(storiesCount: storiesCount)}
    
    init(currentStoryIndex: Int, currentProgress: CGFloat, storiesCount: Int) {
        self.currentStoryIndex = currentStoryIndex
        self.currentProgress = currentProgress
        self.storiesCount = storiesCount
    }
    
    func didChangeCurrentIndex(oldIndex: Int, newIndex: Int) {
        guard oldIndex != newIndex else { return }
        let progress = timerConfiguration.progress(for: newIndex)
        guard abs(progress - currentProgress) >= 0.01 else { return }
        withAnimation {
            currentProgress = progress
        }
    }
    
    func didChangeCurrentProgress(newProgress: CGFloat) {
        let index = timerConfiguration.index(for: newProgress)
        guard index != currentStoryIndex else { return }
        withAnimation {
            currentStoryIndex = index
        }
    }
}

