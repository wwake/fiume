import fiume_model
import SwiftUI

enum DateSpecifierType: String, CaseIterable, Identifiable {
  var id: Self { self }

  case unchanged = "Unspecified",
       monthYear = "Month-Year",
       age = "Age"
}

struct DateSpecifierView: View {
  var label: String

  @Binding var dateSpec: DateSpecifier

  @State private var dateType: DateSpecifierType

  @State var monthYear: MonthYear

  init(label: String, dateSpec: Binding<DateSpecifier>) {
    self.label = label
    self._dateSpec = dateSpec

    switch dateSpec.wrappedValue {
    case .unchanged:
      self.monthYear = 2020.jan
      self.dateType = DateSpecifierType.unchanged

    case let .month(monthYearIn):
      self.dateType = DateSpecifierType.monthYear
      self.monthYear = monthYearIn

    case .age:
      self.monthYear = 2020.jan
      self.dateType = DateSpecifierType.age

    default:
      fatalError("Unknown date spec type \(dateSpec.wrappedValue)")
    }
  }

  func updateDateSpec(_ dateType: DateSpecifierType) {
    switch dateType {
    case .unchanged:
      dateSpec = DateSpecifier.unchanged

    case .monthYear:
      dateSpec = DateSpecifier.month(monthYear)

    case .age:
      break
    }
  }

  var body: some View {
    VStack {
      HStack {
        Text(label)
        Spacer()
      }

      Picker("Add New", selection: $dateType) {
        ForEach(DateSpecifierType.allCases) {
          Text($0.rawValue.capitalized)
        }
      }
      .pickerStyle(.segmented)
      .onChange(of: dateType) { _, newValue in
        updateDateSpec(newValue)
      }

      Group {
        switch dateType {
        case .unchanged:
          Text("Unbounded start or end date.")

        case .monthYear:
          MonthYearView(monthYear: $monthYear)
            .onChange(of: monthYear) {
              updateDateSpec(.monthYear)
            }

        case .age:
          AgeSelector(dateSpec: $dateSpec)
        }
      }.frame(height: 200)
    }
  }
}

#Preview {
  @State var dateSpec = DateSpecifier.month(2020.mar)
  @State var people = People()

  return DateSpecifierView(label: "Choose date", dateSpec: $dateSpec)
    .environment(people)
}
