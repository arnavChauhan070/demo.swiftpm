import SwiftUI

struct TideInfoOverlay: View {
    let moonDistance: Double
    let orbitAngle: Double
    let tideHeight: Double
    let isAnimating: Bool
    let tideType: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            HStack {
                Image(systemName: "wave.3.right")
                    .foregroundColor(.cyan)
                Text("Tide Information")
                    .font(.title2)
                    .foregroundColor(.white)
                Image(systemName: "wave.3.left")
                    .foregroundColor(.cyan)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            InfoRow(
                label: "Moon Position:",
                value: String(format: "%.1f units", moonDistance)
            )
            
            InfoRow(
                label: "Orbit Position:",
                value: String(format: "%.1f°", orbitAngle)
            )
            
            InfoRow(
                label: "Tide Type:",
                value: tideType
            )
            
            InfoRow(
                label: "Status:",
                value: isAnimating ? "Rotating" : "Paused"
            )
        }
        .font(.system(.body, design: .monospaced))
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.8))
                .shadow(color: .cyan.opacity(0.3), radius: 10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.cyan.opacity(0.5), lineWidth: 1)
                .shadow(color: .cyan.opacity(0.5), radius: 5)
        )
        .frame(maxWidth: 300)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.cyan)
                .shadow(color: .cyan.opacity(0.5), radius: 3)
            Spacer()
            Text(value)
                .foregroundColor(.white)
                .shadow(color: .white.opacity(0.5), radius: 2)
        }
        .font(.system(.body, design: .monospaced))
    }
}

#Preview {
    TideInfoOverlay(
        moonDistance: 3.0,
        orbitAngle: 45.0,
        tideHeight: 0.15,
        isAnimating: true,
        tideType: "Spring Tide"
    )
    .background(Color.blue)
} 
