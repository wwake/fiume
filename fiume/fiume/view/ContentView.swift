import Charts
import SwiftUI

struct ContentView: View {
  @Bindable var possibilities: Possibilities

  var body: some View {
    NavigationStack {
      Chart(possibilities.project(360), id: \.name) { dataSeries in
        ForEach(dataSeries.data) {
          LineMark(
            x: .value("Month", $0.month),
            y: .value("Net Worth", $0.amount)
          )
        }
        .foregroundStyle(by: .value("Scenario Name", dataSeries.name))
      //  .symbol(by: .value("Scenario Name", dataSeries.name))
      }
      .chartXScale(domain: 1...360)
      .padding()

      PlanListView(plan: possibilities)
    }
  }
}

#Preview {
  let possibilities = Possibilities()
  possibilities.add(Stream("Salary", 1_000, last: 60))
  possibilities.add(Stream("Expenses", -800))
  return ContentView(possibilities: possibilities)
}
