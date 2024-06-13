import SwiftData
import SwiftUI

@main
struct FiumeApp: App {
  @State var people = People()
  @State var plan = Possibilities(startDate: MonthYear(date: Date()))
	var spiking = false

	var body: some Scene {
    WindowGroup {
      ContentView(people: people, possibilities: plan)
    }
   // .modelContainer(for: Possibilities.self)
	}
}
