@testable import fiume
import Foundation
import Testing

struct ThePeople {
  let people = People()

  @Test
  func startsUnchanged() {
    #expect(!people.wasChanged)
  }

  @Test
  func doesntChangeWhenNewPeopleLoaded() {
    people.add(Person(name: "initial", birth: 2020.mar, death: nil))
    let newPeople = [
      Person(name: "new1", birth: 2021.may, death: nil),
      Person(name: "new2", birth: 2021.may, death: nil),
    ]

    people.load(newPeople)
    #expect(people.count == 2)
    #expect(people.wasChanged == false)
  }

  @Test
  func changesWhenPersonIsAdded() {
    people.add(Person(name: "Buck", birth: 2000.oct, death: nil))
    #expect(people.wasChanged)
  }

  @Test
  func returnsNilIfPersonIdNotFound() {
    #expect(people.findById(UUID()) == nil)
  }

  @Test
  func returnsPersonWhenFound() {
    let person = Person(name: "Bob", birth: 2010.apr, death: nil)
    people.add(person)

    #expect(people.findById(person.id) == person)
  }
}
