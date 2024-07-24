import fiume_model
import SwiftUI

struct EditDateRangeView: View {
  @Binding var dates: DateRange

  @State var first: DateSpecifier
  @State var last: DateSpecifier

  init(dates: Binding<DateRange>) {
    self._dates = .init(projectedValue: dates)
    self.first = dates.wrappedValue.first
    self.last = dates.wrappedValue.last
  }

  var body: some View {
    VStack {
      DateSpecifierView(label: "Start Month", dateSpec: $first)
      DateSpecifierView(label: "End Month", dateSpec: $last)
    }
    .onChange(of: first) {
      dates = DateRange(first, dates.last)
    }
    .onChange(of: last) {
      dates = DateRange(dates.first, last)
    }
  }
}

#Preview {
  @State var dates = DateRange(.month(2025.jan), .unchanged)

  return EditDateRangeView(dates: $dates)
}
