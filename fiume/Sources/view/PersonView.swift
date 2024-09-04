import fiume_model
import SwiftUI

public struct PersonView: View {
  @Environment(People.self)
  var people: People

  var person: Person

  @State var isEditPresented = false

  public var body: some View {
    HStack {
      Text(person.name)
      Text("  b. \(person.birth)")

      Spacer()

      Button(action: {
        people.remove(person)
      }) {
        Image(systemName: "trash")
          .accessibilityLabel(Text("Delete"))
      }
      .buttonStyle(.plain)

      Button(action: {
        isEditPresented = true
      }) {
        Image(systemName: "square.and.pencil")
          .accessibilityLabel(Text("Edit"))
      }
      .buttonStyle(.plain)
    }
    .sheet(isPresented: $isEditPresented) {
      EditPersonView(person: person, buttonName: "Update") { person in
        people.replace(person)
      }
    }
  }
}
