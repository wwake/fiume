import SwiftUI

@main
struct FiumeApp: App {
	@State var plan = MultiScenarioPlan()
	var spiking = false

	var body: some Scene {
		WindowGroup {
			if spiking {
				SpikeView()
			} else {
				ContentView(plan: plan)
			}
		}
	}
}
