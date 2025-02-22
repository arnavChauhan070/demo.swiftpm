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
    
    // Real-world tide comparisons
    private let tideComparisons: [(height: Double, name: String, description: String)] = [
        (16.3, "Bay of Fundy, Canada", "World's highest tides, reaching up to 16.3m (53.5ft) - equivalent to a 4-story building"),
        (14.7, "Severn Estuary, UK", "Europe's highest tidal range at 14.7m (48ft) - height of 3 London buses stacked"),
        (11.7, "Cook Inlet, Alaska", "North America's second-highest tides at 11.7m (38.4ft) - as tall as a telephone pole"),
        (8.4, "Mont Saint-Michel, France", "Famous tidal island with 8.4m (27.6ft) range - height of 2 giraffes"),
        (2.0, "Mediterranean Sea", "Very small tidal range of about 2m (6.6ft) - height of a door")
    ]
    
   
    private var realWorldTideHeight: Double {
        return tideHeight * 20
    }
    
    private var currentComparison: (height: Double, name: String, description: String)? {
        let height = realWorldTideHeight
        return tideComparisons.first { $0.height <= height } ?? tideComparisons.last
    }
    
    var body: some View {
        VStack(spacing: 16) {
           
            HStack {
                Text("Tide Experiment Lab")
                    .font(.headline)
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
            
           
            VStack(alignment: .leading, spacing: 8) {
                Text("Current Tide Height")
                    .font(.subheadline)
                    .foregroundColor(.cyan)
                
                Text(String(format: "%.1f meters", realWorldTideHeight))
                    .font(.title2)
                    .foregroundColor(.white)
                
                
                if let comparison = currentComparison {
                    HStack(spacing: 12) {
                       
                        Rectangle()
                            .fill(Color.cyan.opacity(0.3))
                            .frame(width: 40, height: 100 * (realWorldTideHeight / comparison.height))
                            .overlay(
                                Rectangle()
                                    .stroke(Color.cyan, lineWidth: 1)
                            )
                            .animation(.spring(), value: realWorldTideHeight)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Comparable to:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(comparison.name)
                                .font(.subheadline)
                                .foregroundColor(.white)
                            Text(comparison.description)
                                .font(.caption)
                                .foregroundColor(.cyan)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .padding()
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)
            
            // Moon Controls
            VStack(spacing: 12) {
                // Moon Distance Control
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text("Moon Distance")
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(String(format: "%.1f", moonDistance))×")
                            .foregroundColor(.cyan)
                    }
                    Slider(value: $moonDistance, in: 1.0...4.0) { _ in
                        onUpdatePosition()
                    }
                    .accentColor(.cyan)
                }
                
                // Moon Orbit Control
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text("Orbit Position")
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(Int(moonOrbitAngle))°")
                            .foregroundColor(.cyan)
                    }
                    Slider(value: $moonOrbitAngle, in: 0...360) { _ in
                        onUpdatePosition()
                    }
                    .accentColor(.cyan)
                }
            }
            
            // Animation Control
            Button(action: {
                if isAnimating {
                    onStopAnimation()
                } else {
                    onStartAnimation()
                }
            }) {
                HStack {
                    Image(systemName: isAnimating ? "stop.fill" : "play.fill")
                    Text(isAnimating ? "Stop Animation" : "Start Orbit Animation")
                }
                .foregroundColor(.black)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(Color.cyan)
                .cornerRadius(8)
            }
            
            // Did You Know section
            VStack(alignment: .leading, spacing: 8) {
                Text("Did You Know?")
                    .font(.subheadline)
                    .foregroundColor(.cyan)
                
                Text(getTideFactBasedOnHeight(realWorldTideHeight))
                    .font(.caption)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
            }
            .padding()
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)
        }
        .padding()
        .background(Color.black.opacity(0.95))
        .cornerRadius(15)
        .shadow(radius: 10)
        .frame(width: 350)
    }
    
    private func getTideFactBasedOnHeight(_ height: Double) -> String {
        if height > 15 {
            return "The extreme tidal range you're seeing is similar to the Bay of Fundy, where the unique funnel-shaped bay and resonance effect amplify the tidal forces dramatically!"
        } else if height > 10 {
            return "At this height, tides can create powerful tidal bores - waves that travel upstream against river currents, popular among surfers in places like the Amazon River!"
        } else if height > 5 {
            return "This moderate tidal range is perfect for tidal energy generation. Places with such tides often use tidal turbines to generate clean electricity!"
        } else {
            return "Even these smaller tides play a crucial role in marine ecosystems, creating intertidal zones where unique species thrive in the daily rhythm of high and low tides."
        }
    }
} 
