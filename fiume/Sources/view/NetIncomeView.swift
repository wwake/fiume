import Charts
import fiume_model
import SwiftUI

public struct NetIncomeView: View {
  private var numberOfMonths: Int
  private var data: PossibilitiesSummary

  public init(numberOfMonths: Int, data: PossibilitiesSummary) {
    self.numberOfMonths = numberOfMonths
    self.data = data
  }

  public var body: some View {
    Chart(data) { dataSeries in
      ForEach(dataSeries.netWorthByMonth) {
        AreaMark(
          x: .value("Month", $0.month.date, unit: .month),
          y: .value("Income", $0.moneyByType[.income])
        )
        .foregroundStyle(by: .value("Color", LeiaType.income.name))

        AreaMark(
          x: .value("Month", $0.month.date, unit: .month),
          y: .value("Expense", $0.moneyByType[.expense])
        )
        .foregroundStyle(by: .value("Color", LeiaType.expense.name))

        RuleMark(
            xStart: .value("Month", $0.month),
            xEnd: .value("Month", $0.month.advanced(by: 1)),
            y: .value("Net", $0.moneyByType.netIncome)
        )
      }
    }
    .chartForegroundStyleScale([
        "Income": Color("Income"), "Expense": Color("Expense")
    ])
  }
}
