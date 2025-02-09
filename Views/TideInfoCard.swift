import SwiftUI

struct TideInfoCard: View {
    let tideType: TideType
    let isSelected: Bool
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                Spacer()
                Text(tideType.rawValue)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.title3)
                }
            }
            
            // Formula
            VStack(spacing: 4) {
                Text("Formula")
                    .font(.subheadline)
                    .foregroundColor(.cyan)
                Text(tideType.formula)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.white)
                
                // Formula explanation
                VStack(alignment: .leading, spacing: 4) {
                    Text("Where:")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    FormulaExplanationRow(symbol: "F", explanation: "Tidal Force")
                    FormulaExplanationRow(symbol: "G", explanation: "Gravitational Constant")
                    FormulaExplanationRow(symbol: "M", explanation: "Moon's Mass")
                    FormulaExplanationRow(symbol: "m", explanation: "Earth's Mass")
                    FormulaExplanationRow(symbol: "r", explanation: "Distance between bodies")
                    if tideType == .spring {
                        FormulaExplanationRow(symbol: "S", explanation: "Sun's Mass")
                    }
                }
                .padding(.vertical, 8)
            }
            .padding(.vertical, 4)
            
            // Explanation
            Text(tideType.explanation)
                .font(.callout)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.vertical, 4)
            
            // Did You Know
            VStack(spacing: 4) {
                Text("Did You Know?")
                    .font(.subheadline)
                    .foregroundColor(.cyan)
                Text(tideType.didYouKnow)
                    .font(.callout)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 4)
            
            // Dismiss Button
            Button(action: onDismiss) {
                Text("OK")
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.cyan)
                    .cornerRadius(8)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.8))
                .shadow(color: isSelected ? .cyan.opacity(0.5) : .clear, radius: 10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isSelected ? Color.cyan : Color.white.opacity(0.3), lineWidth: 1)
        )
        .frame(maxWidth: 350)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct FormulaExplanationRow: View {
    let symbol: String
    let explanation: String
    
    var body: some View {
        HStack(spacing: 8) {
            Text(symbol)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.cyan)
                .frame(width: 20, alignment: .leading)
            Text("=")
                .font(.caption)
                .foregroundColor(.gray)
            Text(explanation)
                .font(.caption)
                .foregroundColor(.white)
            Spacer()
        }
    }
} 