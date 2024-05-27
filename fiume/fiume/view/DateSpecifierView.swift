import SwiftUI

struct DateSpecifierView: View {
  var label: String
  @Binding var dateSpec: DateSpecifier

  @State var month: Int?

  var body: some View {
    NumberField(label: label, value: $month)
      .onChange(of: month) { _, new in
        if new == nil {
          dateSpec = DateSpecifier.unspecified
        } else {
          dateSpec = DateSpecifier.month(new!)
        }
      }
  }
}

#Preview {
  @State var dateSpec = DateSpecifier.month(3)
  return DateSpecifierView(label: "Choose date", dateSpec: $dateSpec)
}
