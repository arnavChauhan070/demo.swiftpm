import SwiftUI

struct WelcomeView: View {
    @Binding var userName: String
    @Binding var showWelcome: Bool
    
    var body: some View {
        ZStack {
            // Star field background
            Color.black.edgesIgnoringSafeArea(.all)
            
            // Stars effect
            ForEach(0..<50) { _ in
                Circle()
                    .fill(Color.white)
                    .frame(width: 2, height: 2)
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
            }
            
            VStack(spacing: 30) {
                // Vader image with fallback
                Group {
                    if let _ = UIImage(named: "tide_logo") {
                        Image("tide_logo")
                            .resizable()
                            .scaledToFit()
                    } else {
                        // Fallback if image is missing
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                    }
                }
                .frame(height: 200)
                .shadow(color: .red.opacity(0.5), radius: 20)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red.opacity(0.3), lineWidth: 2)
                )
                
                Text("Welcome to the Tide Simulator")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .red.opacity(0.5), radius: 10)
                
                VStack(spacing: 20) {
                    TextField("Enter your name, young one", text: $userName)
                        .textFieldStyle(DarkSideTextFieldStyle())
                        .padding(.horizontal, 40)
                    
                    Button(action: {
                        if !userName.isEmpty {
                            withAnimation(.easeInOut) {
                                showWelcome = false
                            }
                        }
                    }) {
                        Text("Begin Your Training")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.red.opacity(0.6))
                                    .shadow(color: .red.opacity(0.5), radius: 10)
                            )
                            .padding(.horizontal, 40)
                    }
                    .disabled(userName.isEmpty)
                }
            }
        }
    }
}

struct DarkSideTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
            )
            .foregroundColor(.white)
            .font(.system(size: 18))
            .autocapitalization(.words)
    }
} 
