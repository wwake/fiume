import SwiftData
import SwiftUI

@main
struct FiumeApp: App {
  @State var plan = Possibilities(startDate: MonthYear(date: Date()))
	var spiking = false

  let modelContainer: ModelContainer
  init() {
    do {
      modelContainer = try ModelContainer(for: Person.self)
    } catch {
      fatalError("Could not initialize ModelContainer")
    }
  }

	var body: some Scene {
    WindowGroup {
      ContentView(possibilities: plan)
    }
    .modelContainer(modelContainer)
	}
}
