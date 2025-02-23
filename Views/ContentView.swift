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
        ZStack(alignment: .topLeading) {
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
                
                // Tide Info Overlay - Moved here to show on main screen
                TideInfoOverlay(
                    moonDistance: sceneController.moonDistance,
                    orbitAngle: sceneController.moonOrbitAngle,
                    tideHeight: sceneController.tideHeight,
                    isAnimating: sceneController.isAnimating,
                    tideType: getTideType(angle: sceneController.moonOrbitAngle)
                )
                .padding(.top, 20)
                .padding(.leading, 20)
                
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
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                showMoonControls = false
                            }
                        }
                    
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }
    
    private func getTideType(angle: Double) -> String {
        let normalizedAngle = angle.truncatingRemainder(dividingBy: 360)
        if normalizedAngle.isClose(to: 0) || normalizedAngle.isClose(to: 180) {
            return "Spring Tide"
        } else if normalizedAngle.isClose(to: 90) || normalizedAngle.isClose(to: 270) {
            return "Neap Tide"
        } else {
            return "Normal Tide"
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
