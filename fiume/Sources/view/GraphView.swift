import fiume_model
import SwiftUI

enum GraphType: String, CaseIterable, Identifiable {
  var id: Self { self }

  case netWorth = "Net Worth",
       netIncome = "Net Income by Month"
}

public struct GraphView: View {
  private var numberOfMonths: Int
  private var startDate: MonthYear
  private var plans: Plans

  @State private var graphType: GraphType = .netWorth

  public init(numberOfMonths: Int, startDate: MonthYear, plans: Plans) {
    self.numberOfMonths = numberOfMonths
    self.startDate = startDate
    self.plans = plans
  }

  public var body: some View {
    Picker("Graph", selection: $graphType) {
      ForEach(GraphType.allCases) {
        Text($0.rawValue.capitalized)
      }
    }
    .pickerStyle(.segmented)

    Group {
      switch graphType {
      case .netWorth:
        NetWorthView(numberOfMonths: numberOfMonths, startDate: startDate, plans: plans)

      case .netIncome:
        NetIncomeView(numberOfMonths: numberOfMonths, startDate: startDate, plans: plans)
      }
    }
  }
}
