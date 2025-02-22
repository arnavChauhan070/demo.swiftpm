import SwiftUI

class StoryController: ObservableObject {
    @Published var currentStoryIndex = 0
    @Published var showStoryDialog = true
    @Published var userName: String = ""
    
    var storySequence: [StoryScene] {
        [
            StoryScene(
                title: "The Dark Side Welcomes You 🌌",
                content: "Ah, \(userName)... I have been expecting you. I am Lord Vader, and together we shall explore the most powerful forces in our galaxy... *mechanical breathing* Are you ready to begin your training?",
                action: .introduction
            ),
            StoryScene(
                title: "Feel the Pull of the Force ⚡",
                content: "Pay attention, \(userName). Just as the Force flows between all things, the Moon's gravity pulls on Earth's oceans. Watch closely as I demonstrate... *waves hand* See how the water rises?",
                action: .demonstrateBulge
            ),
            StoryScene(
                title: "High Tide: The Power of Unity 🌊",
                content: "*mechanical breathing* When the Sun and Moon combine their power, they create the highest tides. Press the Spring Tide button to witness their strength!",
                action: .springTide
            ),
            StoryScene(
                title: "Low Tide: The Force Retreats 🏖️",
                content: "Now observe, young one. When the Moon moves farther away, its power weakens. The water retreats, revealing the ocean floor. This is what we call a Low Tide.",
                action: .lowTide
            ),
            StoryScene(
                title: "Your First Test 🎯",
                content: "The time has come for you to take control. Move the Moon yourself using the Experiment controls. Feel how its position affects the tides... Yes, good!",
                action: .experimentStart
            ),
            StoryScene(
                title: "The Dance of the Tides 💫",
                content: "*mechanical breathing* Impressive. Watch how the water follows the Moon, creating two bulges - one facing the Moon, and one on the opposite side. The Force is strong with this phenomenon.",
                action: .experimentObserve
            ),
            StoryScene(
                title: "Neap Tide: A Balance ⚖️",
                content: "When the Moon stands at a right angle to the Sun, their forces reach equilibrium. Like the balance between the light and dark sides of the Force...",
                action: .neapTide
            ),
            StoryScene(
                title: "The Knowledge is Yours 🎓",
                content: "You have learned well, \(userName). You now understand that: \n\n• Spring tides occur when forces align\n• Low tides show the ocean floor\n• Neap tides demonstrate balance\n\nThe Force will be with you, always...",
                action: .conclusion
            )
        ]
    }
    
    func nextScene() {
        if currentStoryIndex < storySequence.count - 1 {
            currentStoryIndex += 1
        }
    }
    
    func previousScene() {
        if currentStoryIndex > 0 {
            currentStoryIndex -= 1
        }
    }
}

struct StoryScene {
    let title: String
    let content: String
    let action: StoryAction
}

enum StoryAction {
    case introduction
    case demonstrateBulge
    case springTide
    case lowTide
    case experimentStart
    case experimentObserve
    case neapTide
    case conclusion
    // Add more actions as needed
} 