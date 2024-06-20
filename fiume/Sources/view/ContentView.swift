import Charts
import SwiftUI

struct ContentView: View {
  let numberOfMonths = 360

  var startDate: MonthYear
  @Bindable var people: People

  @State var plans = [Plan.makeAnd("My Finances")]

  @State var isShowingPeople = false

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

        Button("Save") {
          let encoder = JSONEncoder()
          do {
            print(URL.documentsDirectory)
            let jsonData = try encoder.encode(people)
            let data = Data(jsonData)
            let url = URL.documentsDirectory.appending(path: "people.saved")

            try data.write(to: url, options: [.atomic, .completeFileProtection])
          } catch {
            print(error.localizedDescription)
          }
        }
        .padding(12)
        .background(Color.red)
        .foregroundStyle(Color.white)
        .bold()
        .clipShape(Capsule())
        .padding(.leading, 20)

        Spacer()

        Button("Open") {
          print(URL.documentsDirectory)
          let url = URL.documentsDirectory.appending(path: "people.saved")

          guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(url).")
          }

          let decoder = JSONDecoder()

          guard let loaded = try? decoder.decode(People.self, from: data) else {
            fatalError("Failed to decode from \(url).")
          }

          loaded.people.forEach {
            people.add($0)
          }
        }
        .padding(12)
        .background(Color.red)
        .foregroundStyle(Color.white)
        .bold()
        .clipShape(Capsule())
        .padding(.leading, 20)
      }
      PlanListView(possibilities: Possibilities(startDate: startDate, plans: plans))
    }
    .sheet(isPresented: $isShowingPeople) {
      PeopleView()
    }
  }
}

//#Preview {
  //  let possibilities = Possibilities(startDate: MonthYear(date: Date()), plans: plans)
  //  possibilities.add(Stream("Salary", 1_000, first: .month(2024.jan), last: .month(2029.jan)))
  //  possibilities.add(Stream("Expenses", -800, first: .month(2024.jan), last: .unchanged))
//  return ContentView(startDate: MonthYear(date: Date()))
//}
