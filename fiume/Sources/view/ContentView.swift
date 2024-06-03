import Charts
import SwiftUI

struct ContentView: View {
  @Bindable var people: People
  @Bindable var possibilities: Possibilities

  @State var isShowingPeople = false

  var body: some View {
    NavigationStack {
      Chart(possibilities.project(360)) { dataSeries in
        ForEach(dataSeries.netWorthByMonth) {
          LineMark(
            x: .value("Month", $0.month),
            y: .value("Net Worth", $0.amount)
          )
        }
        .foregroundStyle(by: .value("Scenario Name", dataSeries.name))
      }
      .chartXScale(domain: 1...360)
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
  }
}

#Preview {
  let people = People()
  let possibilities = Possibilities()
  possibilities.add(Stream("Salary", 1_000, first: .month(1), last: .month(60)))
  possibilities.add(Stream("Expenses", -800, first: .month(1), last: .unchanged))
  return ContentView(people: people, possibilities: possibilities)
}
