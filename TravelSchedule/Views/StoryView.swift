import SwiftUI

struct StoryView: View {
    let story: Story
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(story.backgroundImage)
                .resizable()
                .scaledToFill()
            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 16) {
                    Text(story.title)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    Text(story.description)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.white)
                }
                .padding(.init(top: 0, leading: 16, bottom: 40, trailing: 16))
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    StoryView(story: .story1)
}
