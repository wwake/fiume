import fiume_model
import SwiftUI

struct ContentView: View {
  let numberOfMonths = 360

  var startDate: MonthYear

  @Bindable var people: People

  @Bindable var plans: Plans

  @Bindable var assumptions: PercentAssumptions

  @State var isShowingPeople = false
  @State var isShowingAssumptions = false

  @State private var saveError: Error?
  @State private var showSaveAlert = false

  init(startDate: MonthYear, people: People, plans: Plans, assumptions: PercentAssumptions) {
    self.startDate = startDate
    self.people = people
    self.plans = plans
    self.assumptions = assumptions
  }

  var body: some View {
    NavigationStack {
      Text("Net Worth")
        .font(.title)

      GraphView(numberOfMonths: numberOfMonths, startDate: startDate, plans: plans)
        .padding()

      HStack {
        Button("People") {
          isShowingPeople.toggle()
        }
        .buttonStyle(CapsuleButtonStyle())

        Button("Assumptions") {
          isShowingAssumptions.toggle()
        }
        .buttonStyle(CapsuleButtonStyle())

        Spacer()
      }
      Divider()

      if isShowingPeople {
        PeopleView()
          .frame(maxHeight: 150)
        Divider()
      }

      if isShowingAssumptions {
        AssumptionsView()
          .frame(maxHeight: 250)
          .scrollContentBackground(.hidden)

        Divider()
      }

      PlanListView(possibilities: Possibilities(startDate: startDate, plans: plans))
    }
    .alert("Error saving", isPresented: $showSaveAlert) {
      if let saveError {
        Text(saveError.localizedDescription)
      }
      Button("OK", role: .cancel) { }
    }
    .onChange(of: people.wasChanged) {
      if !people.wasChanged { return }
      do {
        people.wasChanged = false
        try save(Persistence.peopleFilename, people)
      } catch {
        saveError = error
        showSaveAlert = true
      }
    }
    .onChange(of: plans.wasChanged) {
      if !plans.wasChanged { return }
      do {
        plans.wasChanged = false
        try save(Persistence.plansFilename, plans)
      } catch {
        saveError = error
        showSaveAlert = true
      }
    }
    .onChange(of: assumptions.wasChanged) {
     if !assumptions.wasChanged { return }
      do {
        assumptions.wasChanged = false
        try save(Persistence.assumptionsFilename, assumptions)
      } catch {
        saveError = error
        showSaveAlert = true
      }
    }
  }
}

#Preview {
  @State var people = People()
  @State var plans = Plans()
  @State var assumptions = PercentAssumptions()

  return ContentView(startDate: MonthYear(date: Date()), people: people, plans: plans, assumptions: assumptions)
    .environment(people)
    .environment(plans)
    .environment(assumptions)
}
