import SwiftUI

struct StoriesTabView: View {
    let stories: [Story]
    @Binding var currentStoryIndex: Int
    var body: some View {
        TabView(selection: $currentStoryIndex) {
            ForEach(0..<stories.count, id: \.self) { index in
                StoryView(story: stories[index])
                    .tag(index)
                    .onTapGesture {
                        didTapStory()
                    }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .ignoresSafeArea()
    }
    
    func didTapStory() {
        currentStoryIndex = min(currentStoryIndex + 1, stories.count - 1)
    }

}

#Preview {
    StoriesTabView(stories: Story.mockData, currentStoryIndex: .constant(0))
}
