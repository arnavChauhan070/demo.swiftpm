import SwiftUI

struct MoonControlsView: View {
    @Binding var isAnimating: Bool
    @Binding var moonDistance: Double
    @Binding var moonOrbitAngle: Double
    let tideHeight: Double
    let onStartAnimation: () -> Void
    let onStopAnimation: () -> Void
    let onUpdatePosition: () -> Void
    let onClose: () -> Void
    
    @State private var showGuidance = true
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("Moon Control Panel")
                    .font(.title2)
                    .foregroundColor(.white)
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.title2)
                }
            }
            
            Divider()
                .background(Color.white.opacity(0.3))
            
            // Moon Distance Slider
            VStack(alignment: .leading, spacing: 8) {
                Text("Moon Distance: \(String(format: "%.1f", moonDistance)) units")
                    .foregroundColor(.cyan)
                Slider(value: $moonDistance, in: 1...4) { _ in
                    onUpdatePosition()
                }
            }
            
            // Orbit Position Slider
            VStack(alignment: .leading, spacing: 8) {
                Text("Orbit Position: \(String(format: "%.1f°", moonOrbitAngle))")
                    .foregroundColor(.cyan)
                Slider(value: $moonOrbitAngle, in: 0...360) { _ in
                    onUpdatePosition()
                }
            }
            
            // Animation Controls
            HStack(spacing: 20) {
                Button(action: {
                    if !isAnimating {
                        onStartAnimation()
                    }
                }) {
                    Text("Start Rotating")
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue.opacity(0.6))
                        .cornerRadius(8)
                }
                
                Button(action: {
                    if isAnimating {
                        onStopAnimation()
                    }
                }) {
                    Text("Stop")
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.red.opacity(0.6))
                        .cornerRadius(8)
                }
            }
            
            if showGuidance {
                GuidanceBox(message: "Try these experiments:\n" +
                           "1. Move Moon closer/farther\n" +
                           "2. Change orbit angle to 0° for Spring tide\n" +
                           "3. Change to 90° for Neap tide")
                    .padding(.top)
            }
        }
        .padding()
        .background(Color.black.opacity(0.95))
        .cornerRadius(15)
        .shadow(radius: 10)
        .frame(width: 350)
    }
}

struct GuidanceBox: View {
    let message: String
    
    var body: some View {
        VStack {
            Text(message)
                .font(.callout)
                .foregroundColor(.cyan)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(8)
    }
} 
