import SwiftData
import SwiftUI

@main
struct FiumeApp: App {
  @State var startDate = MonthYear(date: Date())
	var spiking = false

  init() {
    print(URL.applicationSupportDirectory.path(percentEncoded: false))
  }

	var body: some Scene {
    WindowGroup {
      ContentView(startDate: startDate)
    }
    .modelContainer(for: [Person.self])
//    .modelContainer(for: [Person.self, Plan.self])
	}
}
