import fiume_model
import SwiftUI

struct EditDateRangeView: View {
  @Binding var dates: DateRange

  var body: some View {
    VStack {
      DateSpecifierView(label: "Start Month", dateSpec: $dates.first)
      DateSpecifierView(label: "End Month", dateSpec: $dates.last)
    }
  }
}

#Preview {
  @State var dates = DateRange(.month(2025.jan), .unchanged)

  return EditDateRangeView(dates: $dates)
}
