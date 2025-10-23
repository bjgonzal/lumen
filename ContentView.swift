import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("🌕 Lūmen")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("The self is superficial. The spirit is thorough.")
                .font(.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()

            Button("Shine Again") {
                print("Lūmen awakens.")
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
