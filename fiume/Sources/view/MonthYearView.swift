import SwiftUI

struct MonthYearView: View {
  @Binding var monthYear: MonthYear?

  @State private var monthNumber = 0
  @State private var yearNumber = 2000

  private var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
  private var years = 1920..<2101

  init(monthYear: Binding<MonthYear?>) {
    self._monthYear = monthYear
  }

  var body: some View {
    GeometryReader { geometry in
      HStack {
        Picker("Year", selection: self.$yearNumber) {
          ForEach(years, id: \.self) { year in
            Text(verbatim: "\(year)")
              .tag(year)
          }
        }
        .pickerStyle(WheelPickerStyle())
        .frame(width: geometry.size.width / 2, height: geometry.size.height)
        .clipped()

        Picker("Month", selection: self.$monthNumber) {
          ForEach(0..<months.count, id: \.self) { monthIndex in
            Text(verbatim: "\(months[monthIndex])")
              .tag(monthIndex)
          }
        }
        .pickerStyle(WheelPickerStyle())
        .frame(width: geometry.size.width / 2, height: geometry.size.height)
        .clipped()
      }
    }
  }
}

#Preview {
  @State var myMonthYear: MonthYear? = MonthYear(month: 2, year: 2025)
  return MonthYearView(monthYear: $myMonthYear)
}
