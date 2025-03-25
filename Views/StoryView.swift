import SwiftUI

struct StoryView: View {
    @ObservedObject var storyController: StoryController
    @ObservedObject var sceneController: SceneController
    
    var body: some View {
        VStack {
            if storyController.showStoryDialog {
                DialogBox(
                    title: storyController.storySequence[storyController.currentStoryIndex].title,
                    content: storyController.storySequence[storyController.currentStoryIndex].content
                )
                .transition(.slide)
                .animation(.easeInOut, value: storyController.currentStoryIndex)
                
                HStack {
                    if storyController.currentStoryIndex > 0 {
                        Button(action: {
                            storyController.previousScene()
                            Task {
                                await updateScene()
                            }
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Previous")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                        }
                    }
                    
                    Spacer()
                    if storyController.currentStoryIndex == storyController.storySequence.count - 1 {
                        Button(action: {
                            withAnimation {
                                storyController.showStoryDialog = false
                            }
                        }) {
                            
                            HStack{
                                Text("Start Exploring")
                                Image(systemName: "star.fill")
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.green.opacity(0.6))
                            .cornerRadius(8)
                        }
                    }
                    else {
                        Button(action: {
                            storyController.nextScene()
                            Task {
                                await updateScene()
                            }
                        }) {
                            HStack {
                                Text("Next")
                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            }
        }
    }
    
    private func updateScene() {
        Task { @MainActor in
            let action = storyController.storySequence[storyController.currentStoryIndex].action
            
            await action.execute(controller: storyController, sceneController: sceneController)
            
            switch action {
            case .introduction:
                sceneController.positionForTideType(.normal)
                sceneController.stopAnimation()
            case .demonstrateBulge:
                sceneController.startAnimation()
            case .springTide:
                sceneController.stopAnimation()
                sceneController.positionForTideType(.spring)
            case .lowTide:
                sceneController.stopAnimation()
                sceneController.positionForTideType(.low)
            case .experimentStart:
                break
            case .experimentObserve:
                break
            case .neapTide:
                sceneController.stopAnimation()
                sceneController.positionForTideType(.neap)
            case .conclusion:
                //sceneController.positionForTideType(.normal)
                sceneController.stopAnimation()
            }
        }
    }
}

struct DialogBox: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image("darth_vader")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.red.opacity(0.6), lineWidth: 2)
                    )
                    .shadow(color: .red.opacity(0.5), radius: 5)
                
                Text(title)
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
            }
            
            Text(content)
                .font(.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.8))
                .shadow(radius: 5)
        )
        .padding(.horizontal, 40)
    }
} 
