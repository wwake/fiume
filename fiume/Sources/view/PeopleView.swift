import fiume_model
import SwiftUI

struct PeopleView: View {
  @Environment(People.self)
  var people: People

  @State var isShowingCreateView = false
  @State var isEditPresented = false

  var header: some View {
    HStack {
      Image(systemName: "person.2.fill")
        .accessibilityLabel(Text("People"))
      Text("People")
      Spacer()
      Button {
        isShowingCreateView.toggle()
      } label: {
        Image( systemName: "plus")
          .accessibilityLabel(Text("Add"))
      }
    }
    .sheet(isPresented: $isShowingCreateView) {
      EditPersonView(person: Person.null, buttonName: "Create") { person in
        people.add(person)
      }
    }
  }

  var body: some View {
    List {
      Section(header: header) {
        ForEach(people.sorted()) { person in
          HStack {
            Text(person.name)
            Text("  b. \(person.birth)")

            Text("  d. \(person.death == nil ? "?" : "\(person.death!)")")

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
    }
  }
}

#Preview {
  @State var people = People()
  people.add(Person(name: "Bob", birth: 1970.mar, death: nil))
  people.add(Person(name: "Chris", birth: 1980.dec, death: 2025.apr))

  return PeopleView()
    .environment(people)
}
