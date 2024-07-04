@testable import fiume
import Foundation
import Testing

struct ThePeople {
  let people = People()

  @Test
  func starts_unchanged() {
    #expect(!people.wasChanged)
  }

  @Test
  func doesnt_change_when_new_people_loaded() {
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
  func changes_when_person_is_added() {
    people.add(Person(name: "Buck", birth: 2000.oct, death: nil))
    #expect(people.wasChanged)
  }

  @Test
  func returns_nil_if_person_id_not_found() {
    #expect(people.findById(UUID()) == nil)
  }

  @Test
  func returns_person_when_found() {
    let person = Person(name: "Bob", birth: 2010.apr, death: nil)
    people.add(person)

    #expect(people.findById(person.id) == person)
  }
}
