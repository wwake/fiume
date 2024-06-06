import SwiftUI

enum DateSpecifierType: String, CaseIterable, Identifiable {
  var id: Self { self }

  case unchanged = "Unchanged",
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
    self.monthYear = 2000.jan

    switch dateSpec.wrappedValue {
    case .unchanged:
      dateType = DateSpecifierType.unchanged

    case let .month(monthYearIn):
      dateType = DateSpecifierType.monthYear
      monthYear = monthYearIn

    case let .age(person, age):
      dateType = DateSpecifierType.age
    }
  }

  func updateDateSpec(_ dateType: DateSpecifierType) {
    switch dateType {
    case .unchanged:
      dateSpec = DateSpecifier.unchanged

    case .monthYear:
      dateSpec = DateSpecifier.month(monthYear)

    case .age:
      dateSpec = .age(Person(name: "bob", birth: 2000.jan, death: nil), 40)
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

      switch dateType {
      case .unchanged:
        Text("Leave any previous date in effect.")

      case .monthYear:
        MonthYearView(monthYear: $monthYear)
          .onChange(of: monthYear) {
            updateDateSpec(.monthYear)
          }
          .frame(height: 200)

      case .age:
        Text("Pick an age")

        //        Picker("Age", selection: self.$yearNumber) {
        //          ForEach(years, id: \.self) { year in
        //            Text(verbatim: "\(year)")
        //              .tag(year)
        //          }
        //        }
        //        .halfSize(geometry.size)
        //        .onChange(of: yearNumber) {
        //          updateValues()
        //        }
      }
    }
  }
}

#Preview {
  @State var dateSpec = DateSpecifier.month(2020.mar)
  return DateSpecifierView(label: "Choose date", dateSpec: $dateSpec)
}
