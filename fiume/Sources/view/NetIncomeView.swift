import Charts
import fiume_model
import SwiftUI

public struct NetIncomeView: View {
  private var numberOfMonths: Int
  private var startDate: MonthYear
  private var plans: Plans

  public init(numberOfMonths: Int, startDate: MonthYear, plans: Plans) {
    self.numberOfMonths = numberOfMonths
    self.startDate = startDate
    self.plans = plans
  }

  public var body: some View {
    Text("TBD Net Income View")
  }
}
