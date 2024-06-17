import SwiftData
import SwiftUI

@main
struct FiumeApp: App {
  @State var plan = Possibilities(startDate: MonthYear(date: Date()))
	var spiking = false

	var body: some Scene {
    WindowGroup {
      ContentView(possibilities: plan)
    }
    .modelContainer(for: [Person.self])
//    .modelContainer(for: [Person.self, Plan.self])
	}
}
