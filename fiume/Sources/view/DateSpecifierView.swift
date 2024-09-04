import fiume_model
import SwiftUI

enum DateSpecifierType: String, CaseIterable, Identifiable {
  var id: Self { self }

  case unchanged = "Unspecified",
       monthYear = "Month-Year",
       age = "Age",
       assumption = "Assumed Date"
}

struct DateSpecifierView: View {
  var label: String

  @Binding var dateSpec: DateSpecifier

  @State private var dateType: DateSpecifierType

  @State var monthYear: MonthYear = 2020.jan

  init(label: String, dateSpec: Binding<DateSpecifier>) {
    self.label = label
    self._dateSpec = dateSpec

    switch dateSpec.wrappedValue {
    case .unchanged:
      self.dateType = DateSpecifierType.unchanged

    case let .month(monthYearIn):
      self.monthYear = monthYearIn
      self.dateType = DateSpecifierType.monthYear

    case .age:
      self.dateType = DateSpecifierType.age

    case .assumption:
      self.dateType = DateSpecifierType.assumption

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

    case .assumption:
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

        case .assumption:
          AssumedDateView(dateSpec: $dateSpec)
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
