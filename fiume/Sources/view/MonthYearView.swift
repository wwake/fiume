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
  @Binding var monthYear: MonthYear?

  @State private var isKnown: Bool
  @State private var monthNumber: Int
  @State private var yearNumber: Int

  private var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
  private var years = 1920..<2101

  init(monthYear: Binding<MonthYear?>) {
    self._monthYear = monthYear
    let wrapped = monthYear.wrappedValue
    let alreadyKnown = wrapped != nil
    isKnown = alreadyKnown
    monthNumber = alreadyKnown ? wrapped!.month : 0
    yearNumber = alreadyKnown ? wrapped!.year : 2000
  }

  func updateValues() {
    if isKnown {
      monthYear = MonthYear(month: monthNumber, year: yearNumber)
    } else {
      monthYear = nil
    }
  }

  var body: some View {
    HStack {
      VStack {
        Text("Known?")
      Toggle("Known?", isOn: $isKnown)
        .labelsHidden()
      }
      .padding(16)
      .onChange(of: isKnown) {
        updateValues()
      }

      GeometryReader { geometry in
        HStack {
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

          Picker("Month", selection: self.$monthNumber) {
            ForEach(0..<months.count, id: \.self) { monthIndex in
              Text(verbatim: "\(months[monthIndex])")
                .tag(monthIndex)
            }
          }
          .halfSize(geometry.size)
          .onChange(of: monthNumber) {
            updateValues()
          }
        }
      }
      .disabled(!isKnown)
      .opacity(isKnown ? 1.0 : 0.25)
    }
  }
}

#Preview {
  @State var myMonthYear: MonthYear? = MonthYear(month: 2, year: 2025)
  return MonthYearView(monthYear: $myMonthYear)
}
