import fiume_model
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
      EditPersonView(person: Person.null, buttonName: "Create") { person in
        people.add(person)
      }
    }
  }

  var body: some View {
    List {
      Section(header: header) {
        ForEach(people.sorted()) { person in
          PersonView(person: person)
        }
      }
    }
  }
}

#Preview {
  @State var people = People()
  people.add(Person(name: "Bob", birth: 1970.mar))
  people.add(Person(name: "Chris", birth: 1980.dec))

  return PeopleView()
    .environment(people)
}
