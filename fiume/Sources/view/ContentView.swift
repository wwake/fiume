import Charts
import SwiftUI

struct ContentView: View {
  @Environment(\.modelContext)
  var modelContext

  let numberOfMonths = 360

  @Bindable var possibilities: Possibilities

  @State var isShowingPeople = false

  var body: some View {
    NavigationStack {
      Text("Net Worth")
        .font(.title)
      Chart(possibilities.netWorth(possibilities.range(numberOfMonths))) { dataSeries in
        ForEach(dataSeries.netWorthByMonth) {
          LineMark(
            x: .value("Month", $0.month),
            y: .value("Net Worth", $0.amount)
          )
        }
        .foregroundStyle(by: .value("Scenario Name", dataSeries.name))
      }
      .chartXScale(domain: possibilities.range(numberOfMonths))
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

        Button("Clear All People", role: .destructive) {
          // swiftlint:disable:next force_try
          try! modelContext.delete(model: Person.self)
        }
        .padding(12)
        .background(Color.red)
        .foregroundStyle(Color.white)
        .bold()
        .clipShape(Capsule())
        .padding(.leading, 20)

        Spacer()
      }
      PlanListView(plan: possibilities)
    }
    .sheet(isPresented: $isShowingPeople) {
      PeopleView()
    }
  }
}

#Preview {
  let possibilities = Possibilities(startDate: MonthYear(date: Date()))
  possibilities.add(Stream("Salary", 1_000, first: .month(2024.jan), last: .month(2029.jan)))
  possibilities.add(Stream("Expenses", -800, first: .month(2024.jan), last: .unchanged))
  return ContentView(possibilities: possibilities)
}
