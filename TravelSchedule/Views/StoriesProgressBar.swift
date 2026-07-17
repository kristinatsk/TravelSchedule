import SwiftUI
import Combine

struct StoriesProgressBar: View {
    @Binding var currentProgress: CGFloat
    let storiesCount: Int
 
    
    var body: some View {
        ProgressBar(numberOfSections: storiesCount, progress: currentProgress)
            .padding(.init(top: 7, leading: 12, bottom: 12, trailing: 12))
    }
}


