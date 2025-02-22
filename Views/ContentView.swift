import SwiftUI
import SceneKit

struct ContentView: View {
    // MARK: - State Properties
    @StateObject private var sceneController = SceneController()
    @StateObject private var storyController = StoryController()
    @State private var showMoonControls = false
    @State private var showTideInfo = false
    @State private var showWelcome = true
    @State private var userName = ""
    
    var body: some View {
        ZStack {
            if showWelcome {
                WelcomeView(userName: $userName, showWelcome: $showWelcome)
                    .onDisappear {
                        storyController.userName = userName
                    }
            } else {
                // Background
                Color.black.edgesIgnoringSafeArea(.all)
                
                // Main 3D Scene
                SceneView(
                    scene: sceneController.scene,
                    options: [.allowsCameraControl]
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    // Story View
                    StoryView(
                        storyController: storyController,
                        sceneController: sceneController
                    )
                    
                    // Controls at bottom
                    VStack(spacing: 12) {
                        TideSelector(selectedTide: $sceneController.tideType)
                            .onChange(of: sceneController.tideType) { _ in
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    sceneController.positionForTideType(sceneController.tideType)
                                    showTideInfo = true
                                }
                            }
                            .padding(.horizontal)
                        
                        HStack(spacing: 12) {
                            ControlButton(
                                icon: "info.circle.fill",
                                text: showTideInfo ? "Hide Info" : "Show Info"
                            ) {
                                withAnimation {
                                    showTideInfo.toggle()
                                }
                            }
                            
                            ControlButton(
                                icon: "slider.horizontal.3",
                                text: "Experiment"
                            ) {
                                withAnimation {
                                    showMoonControls.toggle()
                                }
                            }
                        }
                    }
                    .padding(.bottom)
                }
                
                // Modal overlays
                if showTideInfo {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                showTideInfo = false
                            }
                        }
                    
                    TideInfoCard(
                        tideType: sceneController.tideType,
                        isSelected: true,
                        onDismiss: {
                            withAnimation {
                                showTideInfo = false
                            }
                        }
                    )
                    .transition(.scale.combined(with: .opacity))
                }
                
                if showMoonControls {
                    MoonControlsView(
                        isAnimating: $sceneController.isAnimating,
                        moonDistance: $sceneController.moonDistance,
                        moonOrbitAngle: $sceneController.moonOrbitAngle,
                        tideHeight: sceneController.tideHeight,
                        onStartAnimation: {
                            sceneController.startAnimation()
                        },
                        onStopAnimation: {
                            sceneController.stopAnimation()
                        },
                        onUpdatePosition: {
                            Task {
                                await sceneController.updateMoonPosition()
                            }
                        },
                        onClose: {
                            withAnimation {
                                showMoonControls = false
                            }
                        }
                    )
                    .transition(.move(edge: .bottom))
                }
            }
        }
    }
}

struct ControlButton: View {
    let icon: String
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(text)
            }
            .foregroundColor(.cyan)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(Color.white.opacity(0.1))
            .cornerRadius(8)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
} 
