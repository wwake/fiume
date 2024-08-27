import fiume_model
import SwiftUI

public struct MultiNetIncomeView: View {
  private var numberOfMonths: Int
  private var data: PossibilitiesSummary

  @State private var showDetail = false
  @State private var name = ""
  @State private var detail: ScenarioSummary?

  public init(numberOfMonths: Int, data: PossibilitiesSummary) {
    self.numberOfMonths = numberOfMonths
    self.data = data
  }

  private let sizes = [
    GridItem(.adaptive(minimum: 200, maximum: 200), spacing: 40),
  ]

  public var body: some View {
    NavigationStack {
      ScrollView {
        LazyVGrid(columns: sizes, spacing: 25) {
          ForEach(data) { scenario in
            NavigationLink(value: scenario) {
              VStack {
                Text(scenario.name)
                  .font(.caption)
                NetIncomeView(numberOfMonths: numberOfMonths, scenario: scenario)
              }
            }
            .frame(maxWidth: 200)
          }
        }
        .padding()
      }
    }
    .navigationDestination(for: ScenarioSummary.self) { summary in
      VStack {
        Text("Net Income By Month")
          .font(.title)
        Text(summary.name)
        NetIncomeView(numberOfMonths: numberOfMonths, scenario: summary)
      }.padding(12)
    }
  }
}
