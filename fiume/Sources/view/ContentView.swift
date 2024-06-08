import Charts
import SwiftUI

struct ContentView: View {
  let numberOfMonths = 360

  @Bindable var people: People
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

        Spacer()
      }
      PlanListView(plan: possibilities)
    }
    .sheet(isPresented: $isShowingPeople) {
      PeopleView(people: people)
    }
    .environment(people)
  }
}

#Preview {
  let people = People()
  let possibilities = Possibilities(startDate: MonthYear(date: Date()))
  possibilities.add(Stream("Salary", 1_000, first: .month(2024.jan), last: .month(2029.jan)))
  possibilities.add(Stream("Expenses", -800, first: .month(2024.jan), last: .unchanged))
  return ContentView(people: people, possibilities: possibilities)
}
