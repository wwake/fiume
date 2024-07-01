import Charts
import SwiftUI

struct ContentView: View {
  let numberOfMonths = 360

  var startDate: MonthYear
  @Bindable var people: People

  @State var plans = [Plan.makeAnd("My Finances")]

  @State var isShowingPeople = false

  @State private var showSaveAlert = false
  @State private var saveError: Error?

  init(startDate: MonthYear, people: People) {
    self.startDate = startDate
    self.people = people
  }

  var body: some View {
    NavigationStack {
      Text("Net Worth")
        .font(.title)
      Chart(
        Possibilities(
          startDate: startDate,
          plans: plans
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

        Button("Open") {
          let newPeople = open("people.saved", People.self)
          newPeople.people.forEach {
            people.add($0)
          }

          let newPlans = open("plans.saved", Array<Plan>.self)
          plans.removeAll()
          plans.append(newPlans[0])
        }
        .padding(12)
        .background(Color.red)
        .foregroundStyle(Color.white)
        .bold()
        .clipShape(Capsule())
        .padding(.leading, 20)

        Button("Save") {
          do {
            try save("people.saved", people)
            try save("plans.saved", plans)
          } catch {
            showSaveAlert = true
            saveError = error
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

        PlanListView(possibilities: Possibilities(startDate: startDate, plans: plans))
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
  }
}

#Preview {
  let people = People()
  return ContentView(startDate: MonthYear(date: Date()), people: people)
}
