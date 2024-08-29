import fiume_model
import SwiftUI

struct AssumedDateView: View {
  @Binding var dateSpec: DateSpecifier

  @State private var selection = DateAssumption.null

  func updateValues() {
    dateSpec = DateSpecifier.assumption(selection.name)
  }

  var body: some View {
    if DateAssumptions.shared.count == 0 {
      ContentUnavailableView(
        "Assumed Date Unavailable",
        systemImage: "exclamationmark.triangle",
        description: Text("Add a date assumption to enable this option")
      )
    } else {
      Picker("Assumed Date", selection: $selection) {
        ForEach(Array(DateAssumptions.shared)) {
          Text($0.name)
            .tag($0.name)
        }
      }
      .labelsHidden()
      .onChange(of: selection) {
        updateValues()
      }
    }
  }
}
