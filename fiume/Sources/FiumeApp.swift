import fiume_model
import SwiftUI

@main
enum MainEntryPoint {
  static func main() {
      FiumeApp.main()
  }
}

struct FiumeApp: App {
  @State var startDate = MonthYear.start

  @State var people = People.shared
  @State var plans = Plans()
  @State var assumptions = Assumptions.shared

  init() {
    print("Document path: \(URL.documentsDirectory)")

    do {
      let newPeople = try open(Persistence.peopleFilename, People.self)
      people.load(newPeople.people)
    } catch {
      // Fail => no file => first open => everything starts empty
    }

    do {
      let newPlans = try open(Persistence.plansFilename, Plans.self)
      plans.load(newPlans)
    } catch {
      // Fail => no file => first open => everything starts empty
    }

    do {
      let newAssumptions = try open(
        Persistence.assumptionsFilename,
        Assumptions.self
      )
      assumptions.load(newAssumptions)
    } catch {
      // Fail => no file => first open => everything starts empty
    }
  }

  var body: some Scene {
    WindowGroup {
      ContentView(startDate: startDate, people: people, plans: plans, assumptions: assumptions)
        .keyboardType(.alphabet)
        .autocorrectionDisabled(true)
    }
    .environment(people)
    .environment(plans)
    .environment(assumptions)
  }
}
