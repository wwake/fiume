import Charts
import SwiftData
import SwiftUI

struct ContentView: View {
  @Environment(\.modelContext)
  var modelContext

  let numberOfMonths = 360

  var startDate: MonthYear

  @Query(filter: #Predicate<Plan>{
    $0.parent == nil
  })
  var plans: [Plan]

  @State var isShowingPeople = false

  init(startDate: MonthYear) {
    self.startDate = startDate
  }

  var body: some View {
    NavigationStack {
      Text("Net Worth")
        .font(.title)
      //      Chart(possibilities.netWorth(possibilities.range(numberOfMonths))) { dataSeries in
      //        ForEach(dataSeries.netWorthByMonth) {
      //          LineMark(
      //            x: .value("Month", $0.month),
      //            y: .value("Net Worth", $0.amount)
      //          )
      //        }
      //        .foregroundStyle(by: .value("Scenario Name", dataSeries.name))
      //      }
      //      .chartXScale(domain: possibilities.range(numberOfMonths))
      //      .padding()

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
          do {
            try modelContext.delete(model: Person.self)

            try modelContext.delete(model: Plan.self)

            modelContext.insert(Plan.makeAnd("My Finances"))

            try modelContext.save()
          } catch {
            print(error.localizedDescription)
            fatalError("Couldn't delete all - \(#file)")
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
    .onAppear {
      //      if plans.isEmpty {
      //        modelContext.insert(Plan.makeAnd("My Finances"))
      //        try? modelContext.save()
      //      }
    }
    .sheet(isPresented: $isShowingPeople) {
      PeopleView()
    }
  }
}

#Preview {
  let container = demoContainer(for: Plan.self)

  //  let possibilities = Possibilities(startDate: MonthYear(date: Date()), plans: plans)
  //  possibilities.add(Stream("Salary", 1_000, first: .month(2024.jan), last: .month(2029.jan)))
  //  possibilities.add(Stream("Expenses", -800, first: .month(2024.jan), last: .unchanged))
  return ContentView(startDate: MonthYear(date: Date()))
    .modelContainer(container)
}
