import SwiftData
import SwiftUI

struct PeopleView: View {
  @Environment(\.modelContext)
  var modelContext

  @Query(sort: \Person.name)
  var people: [Person]

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
        ForEach(people) { person in
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

#Preview {
  let person1 = Person(name: "Bob", birth: 1970.mar, death: nil)
  let person2 = Person(name: "Chris", birth: 1980.dec, death: 2025.apr)
  var people = [Person]()
  people.append(person1)
  people.append(person2)
  return PeopleView()
}
