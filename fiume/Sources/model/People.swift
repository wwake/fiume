import Foundation

@Observable
class People: Codable {
  enum CodingKeys: String, CodingKey {
    case _wasChanged = "wasChanged"
    case _people = "people"
  }

  var wasChanged: Bool
  var people: [Person]

  init() {
    people = [Person]()
    wasChanged = false
  }

  init(_ people: [Person]) {
    self.people = people
    wasChanged = false
  }

  func load(_ newPeople: [Person]) {
    people = newPeople
    self.wasChanged = false
  }

  func add(_ person: Person) {
    people.append(person)
    wasChanged = true
  }

  func replace(_ person: Person) {
    people.removeAll { $0.id == person.id }
    add(person)
  }

  var count: Int {
    people.count
  }

  func findById(_ id: UUID) -> Person? {
    people.first { $0.id == id }
  }
}

extension People: Sequence {
  func makeIterator() -> some IteratorProtocol<Person> {
    people
      .sorted(by: { $0.name < $1.name })
      .makeIterator()
  }
}

extension People {
  func sorted() -> [Person] {
    Array(self).sorted(by: { $0.name < $1.name })
  }
}
