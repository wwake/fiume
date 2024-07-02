import Charts
import SwiftUI

struct ContentView: View {
  let numberOfMonths = 360

  var startDate: MonthYear
  @Bindable var people: People

  @Bindable var plans: Plans

  @State var isShowingPeople = false

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
          plans: plans.plans
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
        .padding(12)
        .background(Color("ThemeDark"))
        .foregroundStyle(Color.white)
        .bold()
        .clipShape(Capsule())
        .padding(.leading, 20)

        Button("Save") {
          do {
            try save("people.saved", people)
            try save("plans.saved", plans)
          } catch {
            saveError = error
            showSaveAlert = true
          }
        }
        .padding(12)
        .background(Color.red)
        .foregroundStyle(Color.white)
        .bold()
        .clipShape(Capsule())
        .padding(.leading, 20)

        Spacer()
      }

      PlanListView(possibilities: Possibilities(startDate: startDate, plans: plans.plans))
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
    .onChange(of: people.wasChanged) {
      if !people.wasChanged { return }
      do {
        people.wasChanged = false
        try save("people.saved", people)
      } catch {
        saveError = error
        showSaveAlert = true
      }
    }
    .onChange(of: plans.wasChanged) {
      if !plans.wasChanged { return }
      do {
        plans.wasChanged = false
        try save("plans.saved", plans)
      } catch {
        saveError = error
        showSaveAlert = true
      }
    }
  }
}

#Preview {
  let people = People()
  let plans = Plans()
  return ContentView(startDate: MonthYear(date: Date()), people: people, plans: plans)
}
