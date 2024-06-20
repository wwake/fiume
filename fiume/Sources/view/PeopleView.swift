import SwiftUI

struct PeopleView: View {
  @Environment(People.self)
  var people: People

  @State var isShowingCreateView = false

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
      CreatePersonView()
    }
  }

  var body: some View {
    List {
      Section(header: header) {
        ForEach(people.people) { person in
          HStack {
            Text(person.name)
            Text("  b. \(person.birth)")

            Text("  d. \(person.death == nil ? "?" : "\(person.death!)")")
          }
        }
      }
    }
  }
}

//#Preview {
//  let container = demoContainer(for: Person.self)
//  container.mainContext.insert(Person(name: "Bob", birth: 1970.mar, death: nil))
//  container.mainContext.insert(Person(name: "Chris", birth: 1980.dec, death: 2025.apr))
//
//  return PeopleView()
//    .modelContainer(container)
//}
