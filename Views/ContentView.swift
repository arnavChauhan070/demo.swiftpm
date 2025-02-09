import SwiftUI
import SceneKit

struct ContentView: View {
    // MARK: - State Properties
    @StateObject private var sceneController = SceneController()
    @State private var showMoonControls = false
    @State private var showTideInfo = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 1. Background
                Color.black.edgesIgnoringSafeArea(.all)
                
                // 2. Main Content
                VStack {
                    // Title
                    Text("Earth Tides Visualization")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.top)
                    
                    // 3. 3D Scene View
                    ZStack {
                        SceneView(
                            scene: sceneController.scene,
                            options: [.allowsCameraControl]
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        // Stats Overlay
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Tide Height: \(String(format: "%.1f", sceneController.tideHeight * 10)) meters")
                            Text("Animation: \(sceneController.isAnimating ? "Running" : "Stopped")")
                            Text("Orbit Position: \(Int(sceneController.moonOrbitAngle))°")
                            Text("Moon Distance: \(String(format: "%.1f", sceneController.moonDistance))×")
                        }
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.cyan)
                        .padding(8)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(8)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    }
                    
                    // 4. Bottom Controls
                    VStack(spacing: 12) {
                        // Tide Type Selector
                        TideSelector(selectedTide: $sceneController.tideType)
                            .onChange(of: sceneController.tideType) { _ in
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    sceneController.positionForTideType(sceneController.tideType)
                                    showTideInfo = true
                                }
                            }
                            .padding(.horizontal)
                        
                        // Control Buttons
                        HStack(spacing: 12) {
                            // Info Button
                            ControlButton(
                                icon: "info.circle.fill",
                                text: showTideInfo ? "Hide Info" : "Show Info"
                            ) {
                                withAnimation {
                                    showTideInfo.toggle()
                                }
                            }
                            
                            // Experiment Button
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
                
                // 5. Overlays
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

// MARK: - Helper Views
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

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
} 
