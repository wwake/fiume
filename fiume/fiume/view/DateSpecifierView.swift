import SwiftUI

struct DateSpecifierView: View {
  var label: String
  @Binding var month: Int?

  var body: some View {
    NumberField(label: label, value: $month)
  }
}

#Preview {
  @State var month: Int?
  return DateSpecifierView(label: "Choose date", month: $month)
}
