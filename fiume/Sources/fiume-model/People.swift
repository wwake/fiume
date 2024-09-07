import Foundation

@Observable
public class People: Codable {
  public static var shared = People()

  enum CodingKeys: String, CodingKey {
    case _wasChanged = "wasChanged"
    case _people = "people"
  }

  public var wasChanged: Bool
  fileprivate var people: [Person]

  public init() {
    people = [Person]()
    wasChanged = false
  }

  public init(_ people: [Person]) {
    self.people = people
    wasChanged = false
  }

  public func load(_ newPeople: People) {
    people = newPeople.people
    self.wasChanged = false
  }

  public func add(_ person: Person) {
    people.append(person)
    wasChanged = true
  }

  public func replace(_ person: Person) {
    remove(person)
    add(person)
  }

  public func remove(_ person: Person) {
    people.removeAll { $0.id == person.id }
    wasChanged = true
  }

  public var count: Int {
    people.count
  }

  public func findById(_ id: UUID) -> Person? {
    people.first { $0.id == id }
  }

  public func containsName(_ name: String) -> Bool {
    let found = people.first { $0.name == name }
    return found != nil
  }
}

extension People: Sequence {
  public func makeIterator() -> some IteratorProtocol<Person> {
    people
      .sorted(by: { $0.name < $1.name })
      .makeIterator()
  }
}

extension People {
  public func all() -> [Person] {
    Array(self).sorted(by: { $0.name < $1.name })
  }
}
