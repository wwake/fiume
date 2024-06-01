import SwiftUI

@main
struct FiumeApp: App {
  @State var people = People()
	@State var plan = Possibilities()
	var spiking = false

	var body: some Scene {
		WindowGroup {
			if spiking {
				SpikeView()
			} else {
        ContentView(people: people, possibilities: plan)
			}
		}
	}
}
