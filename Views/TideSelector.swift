import SwiftUI

struct TideSelector: View {
    @Binding var selectedTide: TideType
    @Namespace private var animation
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(TideType.allCases) { type in
                    VStack(spacing: 8) {
                        Text(type.rawValue)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(selectedTide == type ? .cyan : .white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                        
                        if selectedTide == type {
                            Rectangle()
                                .fill(Color.cyan)
                                .frame(height: 2)
                                .matchedGeometryEffect(id: "underline", in: animation)
                        } else {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 2)
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(selectedTide == type ? Color.white.opacity(0.2) : Color.clear)
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTide = type
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .background(Color.black.opacity(0.6))
        .cornerRadius(12)
    }
} 