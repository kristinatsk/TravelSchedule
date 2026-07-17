import SwiftUI
import Combine

@Observable
final class StoriesViewModel {
    var currentStoryIndex: Int
    var currentProgress: CGFloat
    var storiesCount: Int
    var timerConfiguration: TimerConfiguration { .init(storiesCount: storiesCount)}
    var timer: Timer.TimerPublisher
    var cancellable: Cancellable?
    
    init(currentStoryIndex: Int, currentProgress: CGFloat, storiesCount: Int) {
        self.currentStoryIndex = currentStoryIndex
        self.currentProgress = currentProgress
        self.storiesCount = storiesCount
        self.timer = Self.makeTimer(configuration: self.timerConfiguration)
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
    
    static func makeTimer(configuration: TimerConfiguration) -> Timer.TimerPublisher {
        Timer.publish(every: configuration.timerTickInterval, on: .main, in: .common)
    }
    
    
    func timerTick() {
        withAnimation {
            currentProgress = timerConfiguration.nextProgress(progress: currentProgress)
        }
    }
    
    func startTimer() {
        cancellable = timer.connect()
    }
    
    func stopTimer() {
        cancellable?.cancel()
    }
    
}

