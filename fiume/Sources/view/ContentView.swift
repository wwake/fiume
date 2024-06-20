import Charts
import SwiftUI

struct ContentView: View {
  let numberOfMonths = 360

  var startDate: MonthYear

  @State var plans = [Plan.makeAnd("My Finances")]

  @State var isShowingPeople = false

  init(startDate: MonthYear) {
    self.startDate = startDate
  }

  var body: some View {
    NavigationStack {
      Text("Net Worth")
        .font(.title)
      Chart(Possibilities(startDate: startDate, plans: plans).netWorth(Possibilities(startDate: startDate, plans: plans).range(numberOfMonths))) { dataSeries in
        ForEach(dataSeries.netWorthByMonth) {
          LineMark(
            x: .value("Month", $0.month),
            y: .value("Net Worth", $0.amount)
          )
        }
        .foregroundStyle(by: .value("Scenario Name", dataSeries.name))
      }
      .chartXScale(domain: Possibilities(startDate: startDate, plans: plans).range(numberOfMonths))
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

        Button("Clear All Data", role: .destructive) {
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
//    .onAppear {
//      if plans.isEmpty {
//        plans.append(Plan.makeAnd("My Finances"))
//      }
//    }
    .sheet(isPresented: $isShowingPeople) {
      PeopleView()
    }
  }
}

#Preview {
  //  let possibilities = Possibilities(startDate: MonthYear(date: Date()), plans: plans)
  //  possibilities.add(Stream("Salary", 1_000, first: .month(2024.jan), last: .month(2029.jan)))
  //  possibilities.add(Stream("Expenses", -800, first: .month(2024.jan), last: .unchanged))
  return ContentView(startDate: MonthYear(date: Date()))
}
