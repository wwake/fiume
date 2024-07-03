import SwiftUI

@Observable
class People: Codable {
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

  var count: Int {
    people.count
  }

  func findById(_ id: UUID) -> Person? {
    people.first { $0.id == id }
  }
}

extension People: Sequence {
  func makeIterator() -> some IteratorProtocol {
    people.makeIterator()
  }
}
