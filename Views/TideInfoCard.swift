import SwiftUI

struct TideInfoCard: View {
    let tideType: TideType
    let isSelected: Bool
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
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
            Text(tideType.explanation)
                .font(.callout)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.vertical, 4)
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
