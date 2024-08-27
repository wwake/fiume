import fiume_model
import SwiftUI

public struct MultiNetIncomeView: View {
  private var numberOfMonths: Int
  private var data: PossibilitiesSummary

  public init(numberOfMonths: Int, data: PossibilitiesSummary) {
    self.numberOfMonths = numberOfMonths
    self.data = data
  }

  private let sizes = [
    GridItem(.adaptive(minimum: 200), spacing: 40),
  ]

  public var body: some View {
    ScrollView {
      LazyVGrid(columns: sizes, spacing: 25) {
        ForEach(data) { scenario in
          VStack {
            Text(scenario.name)
              .font(.caption)
            NetIncomeView(numberOfMonths: numberOfMonths, scenario: scenario)
          }
        }
      }
      .padding()
    }
  }
}
