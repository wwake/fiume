import fiume_model
import SwiftUI

struct DateSpecifierView: View {
  var label: String

  @Binding var dateSpec: DateSpecifier

  @State private var dateType: DateSpecifierType

  init(label: String, dateSpec: Binding<DateSpecifier>) {
    self.label = label
    self._dateSpec = dateSpec
    self.dateType = dateSpec.wrappedValue.type
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

      Group {
        switch dateType {
        case .unchanged:
          Text("Unbounded start or end date.")
            .onChange(of: dateType, initial: true) {
              dateSpec = DateSpecifier.unchanged
            }

        case .monthYear:
          MonthYearDateView(dateSpec: $dateSpec)

        case .age:
          AgeSelector(dateSpec: $dateSpec)

        case .assumption:
          AssumedDateView(dateSpec: $dateSpec)

        @unknown default:
          fatalError("Unknown date spec type")
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
