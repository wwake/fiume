import Charts
import fiume_model
import SwiftUI

public struct NetWorthView: View {
  private var numberOfMonths: Int
  private var data: PossibilitiesSummary

  public init(numberOfMonths: Int, data: PossibilitiesSummary) {
    self.numberOfMonths = numberOfMonths
    self.data = data
  }

  public var body: some View {
    Chart(data) { dataSeries in
      ForEach(dataSeries.netWorthByMonth) {
        LineMark(
          x: .value("Month", $0.month),
          y: .value("Net Worth", $0.netWorth)
        )
      }
      .foregroundStyle(by: .value("Scenario Name", dataSeries.name))
    }
  }
}
