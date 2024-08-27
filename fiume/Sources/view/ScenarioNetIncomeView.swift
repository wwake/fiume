import fiume_model
import SwiftUI

public struct ScenarioNetIncomeView: View {
  private var numberOfMonths: Int
  private var data: PossibilitiesSummary

  @State private var selectedScenario: Int = 0

  public init(numberOfMonths: Int, data: PossibilitiesSummary) {
    self.numberOfMonths = numberOfMonths
    self.data = data
  }

  public var body: some View {
    VStack {
      Picker(selection: $selectedScenario, label: Text("Scenario:")) {
        ForEach(data.indices, id: \.self) { index in
          Text(data[index].name)
            .tag(index)
        }
      }

      NetIncomeView(numberOfMonths: numberOfMonths, data: data, scenario: data[selectedScenario])
    }
  }
}
