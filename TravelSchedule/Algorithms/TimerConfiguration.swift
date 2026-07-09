import Foundation

struct TimerConfiguration {
    let storiesCount: Int
    let timerTickInterval: TimeInterval
    let progressPerTick: CGFloat
    
    init(
        storiesCount: Int,
        secondsPerStory: TimeInterval = 5,
        timerTickInterval: TimeInterval = 0.05
    ) {
        self.storiesCount = storiesCount
        self.timerTickInterval = timerTickInterval
        self.progressPerTick = 1.0 / CGFloat(storiesCount) / secondsPerStory * timerTickInterval
    }
}
