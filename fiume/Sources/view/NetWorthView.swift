import Charts
import fiume_model
import SwiftUI

public struct NetWorthView: View {
  private var numberOfMonths: Int
  private var startDate: MonthYear
  private var plans: Plans

  public init(numberOfMonths: Int, startDate: MonthYear, plans: Plans) {
    self.numberOfMonths = numberOfMonths
    self.startDate = startDate
    self.plans = plans
  }

  public var body: some View {
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
          y: .value("Net Worth", $0.netWorth)
        )
      }
      .foregroundStyle(by: .value("Scenario Name", dataSeries.name))
    }
    .chartXScale(domain: startDate.range(numberOfMonths))
  }
}
