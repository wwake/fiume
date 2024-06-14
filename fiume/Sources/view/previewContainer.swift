import SwiftData

func previewContainer(_ theType: any PersistentModel.Type) -> ModelContainer {
  let config = ModelConfiguration(isStoredInMemoryOnly: true)

  // swiftlint:disable:next force_try
  let container = try! ModelContainer(for: theType, configurations: config)

  return container
}
