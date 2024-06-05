import SwiftUI

struct DateSpecifierView: View {
  var label: String
  @Binding var dateSpec: DateSpecifier

  @State var month: Int?
  @State var monthYear: MonthYear?

  var body: some View {
    Text(label)
    MonthYearView(monthYear: $monthYear)
      .onChange(of: monthYear) { _, new in
        if new == nil {
          dateSpec = DateSpecifier.unchanged
        } else {
          dateSpec = DateSpecifier.month(new!)
        }
      }
  }
}

#Preview {
  @State var dateSpec = DateSpecifier.month(MonthYear(.mar, 2020))
  return DateSpecifierView(label: "Choose date", dateSpec: $dateSpec)
}
