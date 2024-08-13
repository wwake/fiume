import Charts
import fiume_model
import SwiftUI

struct ContentView: View {
  let numberOfMonths = 360

  var startDate: MonthYear
  @Bindable var people: People

  @Bindable var plans: Plans

  @State var isShowingPeople = false
  @State var isShowingAssumptions = false

  @State private var saveError: Error?
  @State private var showSaveAlert = false

  init(startDate: MonthYear, people: People, plans: Plans) {
    self.startDate = startDate
    self.people = people
    self.plans = plans
  }

  var body: some View {
    NavigationStack {
      Text("Net Worth")
        .font(.title)
      Chart(
        Possibilities(
          startDate: startDate,
          plans: plans,
          people: people
        )
        .netWorth(
          startDate.range(numberOfMonths)
        )
      ) { dataSeries in
        ForEach(dataSeries.netWorthByMonth) {
          LineMark(
            x: .value("Month", $0.month),
            y: .value("Net Worth", $0.amount)
          )
        }
        .foregroundStyle(by: .value("Scenario Name", dataSeries.name))
      }
      .chartXScale(domain: startDate.range(numberOfMonths))
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

      PlanListView(possibilities: Possibilities(startDate: startDate, plans: plans, people: people))
    }
    .alert("Error saving", isPresented: $showSaveAlert) {
      if let saveError {
        Text(saveError.localizedDescription)
      }
      Button("OK", role: .cancel) { }
    }
    .sheet(isPresented: $isShowingPeople) {
      PeopleView()
    }
    .sheet(isPresented: $isShowingAssumptions) {
      AssumptionsView()
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
  }
}

#Preview {
  @State var people = People()
  @State var plans = Plans()
  return ContentView(startDate: MonthYear(date: Date()), people: people, plans: plans)
    .environment(people)
    .environment(plans)
}
