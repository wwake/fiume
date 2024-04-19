import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
				.accessibilityLabel("globe")
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
