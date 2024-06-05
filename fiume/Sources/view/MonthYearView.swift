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
  @State private var month: Int
  @State private var yearNumber: Int

  private var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
  private var years = 1920..<2101

  init(monthYear: Binding<MonthYear?>) {
    self._monthYear = monthYear
    let wrapped = monthYear.wrappedValue
    let alreadyKnown = wrapped != nil
    isKnown = alreadyKnown
    month = alreadyKnown ? wrapped!.month.rawValue : 0
    yearNumber = alreadyKnown ? wrapped!.year : 2000
  }

  func updateValues() {
    if isKnown {
      monthYear = MonthYear(Month(rawValue: month) ?? .jan, yearNumber)
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
      .disabled(!isKnown)
      .opacity(isKnown ? 1.0 : 0.25)
    }
  }
}

#Preview {
  @State var myMonthYear: MonthYear? = 2025.mar
  return MonthYearView(monthYear: $myMonthYear)
}
