import SwiftUI

struct MonthYearView: View {
  @Binding var monthYear: MonthYear?

  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }
}

#Preview {
  @State var monthYear: MonthYear? = MonthYear(month: 2, year: 2025)
  return MonthYearView(monthYear: $monthYear)
}
