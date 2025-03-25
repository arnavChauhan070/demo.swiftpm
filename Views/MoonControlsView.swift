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
            HStack {
                Image(systemName: "moon.stars.fill")
                    .foregroundColor(.cyan)
                Text("Moon Control Panel")
                    .font(.title2)
                    .foregroundColor(.white)
                    .shadow(color: .cyan.opacity(0.5), radius: 5)
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.cyan)
                        .font(.title2)
                }
            }
            Divider()
                .background(Color.cyan.opacity(0.3))
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Moon Distance: \(String(format: "%.1f", moonDistance)) units")
                    .foregroundColor(.cyan)
                    .shadow(color: .cyan.opacity(0.5), radius: 3)
                Slider(value: $moonDistance, in: 1...4) { _ in
                    onUpdatePosition()
                }
                .tint(.cyan)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Orbit Position: \(String(format: "%.1f°", moonOrbitAngle))")
                    .foregroundColor(.cyan)
                    .shadow(color: .cyan.opacity(0.5), radius: 3)
                Slider(value: $moonOrbitAngle, in: 0...360) { _ in
                    onUpdatePosition()
                }
                .tint(.cyan)
            }
            
            HStack {
                Button(action: onStartAnimation) {
                    Text("Start Rotating")
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue.opacity(0.6))
                                .shadow(color: .blue.opacity(0.5), radius: 5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.cyan.opacity(0.5), lineWidth: 1)
                        )
                }
                
                Button(action: onStopAnimation) {
                    Text("Stop")
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.red.opacity(0.6))
                                .shadow(color: .red.opacity(0.5), radius: 5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.red.opacity(0.3), lineWidth: 1)
                        )
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
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.95))
                .shadow(color: .cyan.opacity(0.3), radius: 10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.cyan.opacity(0.5), lineWidth: 1)
                .shadow(color: .cyan.opacity(0.5), radius: 5)
        )
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
                .shadow(color: .cyan.opacity(0.5), radius: 3)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.3))
                .shadow(color: .cyan.opacity(0.2), radius: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
        )
    }
} 
