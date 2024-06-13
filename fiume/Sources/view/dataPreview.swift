import SwiftData
import SwiftUI

func dataPreview(
    _ theType: any PersistentModel.Type,
    @ViewBuilder contents: () -> some View
  ) -> some View {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)

    // swiftlint:disable:next force_try
    let container = try! ModelContainer(for: theType, configurations: config)

    return contents()
      .modelContainer(container)
}
