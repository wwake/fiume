import SwiftUI

struct PeopleView: View {
  @Bindable var people: People
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
      CreatePersonView(people: people)
    }
  }

  var body: some View {
    List {
      Section(header: header) {
        ForEach(people.people) { person in
          HStack {
            Text(person.name)
            Text("  b. \(person.birth == nil ? "?" : "\(person.birth!)")")

            Text("  d. \(person.death == nil ? "?" : "\(person.death!)")")
          }
        }
      }
    }
  }
}

#Preview {
  let person1 = Person(name: "Bob", birth: MonthYear(.mar, 1970), death: nil)
  let person2 = Person(name: "Chris", birth: MonthYear(.dec, 1980), death: MonthYear(.apr, 2025))
  let people = People()
  people.add(person1)
  people.add(person2)
  return PeopleView(people: people)
}
