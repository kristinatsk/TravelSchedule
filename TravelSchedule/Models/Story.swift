import Foundation
import SwiftUI

struct Story: Identifiable, Hashable {
    let id: UUID
    let backgroundImage: ImageResource
    var hasSeen: Bool
    let title: String
    let description: String
    
    static let story1 = Story(
            id: UUID(),
            backgroundImage: .story1,
            hasSeen: false,
            title: "Text Text Text Text Text Text Text Text Text Text",
            description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text"
        )
        
    static let story2 = Story(
            id: UUID(),
            backgroundImage: .story2,
            hasSeen: false,
            title: "Text Text Text Text Text Text Text Text Text Text",
            description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text"
        )
        
    static let story3 = Story(
            id: UUID(),
            backgroundImage: .story3,
            hasSeen: false,
            title: "Text Text Text Text Text Text Text Text Text Text",
            description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text"
        )
        
    static let story4 = Story(
            id: UUID(),
            backgroundImage: .story4,
            hasSeen: false,
            title: "Text Text Text Text Text Text Text Text Text Text",
            description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text"
        )
        
    static let story5 = Story(
            id: UUID(),
            backgroundImage: .story5,
            hasSeen: false,
            title: "Text Text Text Text Text Text Text Text Text Text",
            description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text"
        )
    
    static let mockData = [story1, story2, story3, story4, story5]

}

