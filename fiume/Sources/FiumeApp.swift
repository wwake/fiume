import SwiftUI

@main
struct FiumeApp: App {
  @State var family = Family()
	@State var plan = Possibilities()
	var spiking = false

	var body: some Scene {
		WindowGroup {
			if spiking {
				SpikeView()
			} else {
        ContentView(family: family, possibilities: plan)
			}
		}
	}
}
