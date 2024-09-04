import fiume_model
import SwiftUI

struct AssumedDateView: View {
  @Binding var dateSpec: DateSpecifier

  @State private var selection: String

  func updateValues() {
    dateSpec = DateSpecifier.assumption(selection)
  }

  init(dateSpec: Binding<DateSpecifier>) {
    self._dateSpec = dateSpec
    self.selection =
         dateSpec.wrappedValue.assumedDateName
      ?? Assumptions.shared.names(.date).first
      ?? ""
  }

  var body: some View {
    if Assumptions.shared.count(.date) == 0 {
      ContentUnavailableView(
        "Assumed Date Unavailable",
        systemImage: "exclamationmark.triangle",
        description: Text("Add a date assumption to enable this option")
      )
    } else {
      VStack {
        Text("Select the date to use; adjust it via Assumptions")
        Picker("Assumed Date", selection: $selection) {
          ForEach(Array(Assumptions.shared.names(.date)), id: \.self) {
            Text($0)
              .tag($0)
          }
        }
        .labelsHidden()
        .onChange(of: selection) {
          updateValues()
        }
      }
      .onAppear {
        updateValues()
      }
    }
  }
}
