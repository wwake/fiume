import SwiftUI

@main
struct FiumeApp: App {
	@State var plan = Plan()

    var body: some Scene {
        WindowGroup {
			ContentView(plan: plan)
        }
    }
}
