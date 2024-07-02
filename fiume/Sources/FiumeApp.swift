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
      newPeople.people.forEach {
        people.add($0)
      }
      people.wasChanged = false
    } catch {
      // Fail => no file => first open => everything starts empty
    }

    do {
      let newPlans = try open("plans.saved", Array<Plan>.self)
      plans.removeAll()
      plans.append(newPlans[0])
    } catch {
      // Fail => no file => first open => everything starts empty
    }
  }

	var body: some Scene {
    WindowGroup {
      ContentView(startDate: startDate, people: people, plans: plans)
    }
    .environment(people)
	}
}
