import SwiftData
import SwiftUI

@main
struct FiumeApp: App {
  @State var startDate = MonthYear(date: Date())

  init() {
    print(URL.applicationSupportDirectory.path(percentEncoded: false))
  }

	var body: some Scene {
    WindowGroup {
      ContentView(startDate: startDate)
    }
	}
}
