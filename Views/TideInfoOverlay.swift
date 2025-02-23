import SwiftUI

struct TideInfoOverlay: View {
    let moonDistance: Double
    let orbitAngle: Double
    let tideHeight: Double
    let isAnimating: Bool
    let tideType: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("Tide Information")
                .font(.title2)
                .foregroundColor(.white)
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
        .background(Color.black.opacity(0.7))
        .cornerRadius(10)
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
            Spacer()
            Text(value)
                .foregroundColor(.white)
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
