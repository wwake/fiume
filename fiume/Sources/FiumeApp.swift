import SwiftData
import SwiftUI

@main
struct FiumeApp: App {
  @State var startDate = MonthYear(date: Date())

  @State var people = People()
  @State var plans = Plans()

  init() {
    print("Document path: \(URL.documentsDirectory)")

    do {
      let newPeople = try open("people.saved", People.self)
      people.load(newPeople.people)
    } catch {
      // Fail => no file => first open => everything starts empty
    }

    do {
      let newPlans = try open("plans.saved", Array<Plan>.self)
      plans.load(newPlans)
    } catch {
      // Fail => no file => first open => everything starts empty
    }
  }

	var body: some Scene {
    WindowGroup {
      ContentView(startDate: startDate, people: people, plans: plans)
    }
    .environment(people)
    .environment(plans)
	}
}
