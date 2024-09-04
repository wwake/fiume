import fiume_model
import SwiftUI

public struct MonthYearDateView: View {
  @Binding var dateSpec: DateSpecifier

  @State var monthYear: MonthYear

  init(dateSpec: Binding<DateSpecifier>) {
    self._dateSpec = dateSpec
    self.monthYear = dateSpec.wrappedValue.monthYear ?? 2020.jan
  }

  func updateValues() {
    dateSpec = DateSpecifier.month(monthYear)
  }

  public var body: some View {
    MonthYearView(monthYear: $monthYear)
      .onChange(of: monthYear, initial: true) {
        updateValues()
      }
  }
}
