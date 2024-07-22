import fiume_model
import SwiftUI

struct HalfSized: ViewModifier {
  var size: CGSize

  func body(content: Content) -> some View {
    content
      .pickerStyle(WheelPickerStyle())
      .frame(width: size.width / 2, height: size.height)
      .clipped()
  }
}

extension View {
  func halfSize(_ size: CGSize) -> some View {
    modifier(HalfSized(size: size))
  }
}

struct MonthYearView: View {
  @Binding var monthYear: MonthYear

  @State private var month: Int
  @State private var yearNumber: Int

  private var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
  private var years = 1920..<2101

  init(monthYear: Binding<MonthYear>) {
    self._monthYear = monthYear
    let wrapped = monthYear.wrappedValue
    month = wrapped.month.rawValue
    yearNumber = wrapped.year
  }

  func updateValues() {
    monthYear = MonthYear(Month(rawValue: month) ?? .jan, yearNumber)
  }

  var body: some View {
    HStack {
      GeometryReader { geometry in
        HStack {
          Picker("Month", selection: self.$month) {
            ForEach(0..<months.count, id: \.self) { monthIndex in
              Text(verbatim: "\(months[monthIndex])")
                .tag(monthIndex)
            }
          }
          .halfSize(geometry.size)
          .onChange(of: month) {
            updateValues()
          }

          Picker("Year", selection: self.$yearNumber) {
            ForEach(years, id: \.self) { year in
              Text(verbatim: "\(year)")
                .tag(year)
            }
          }
          .halfSize(geometry.size)
          .onChange(of: yearNumber) {
            updateValues()
          }
        }
      }
    }
  }
}

#Preview {
  @State var myMonthYear: MonthYear = 2025.mar
  return MonthYearView(monthYear: $myMonthYear)
}
