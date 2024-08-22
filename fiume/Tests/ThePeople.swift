@testable import fiume
import fiume_model
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
    people.add(Person(name: "initial", birth: 2020.mar))
    let newPeople = [
      Person(name: "new1", birth: 2021.may),
      Person(name: "new2", birth: 2021.may),
    ]

    people.load(newPeople)
    #expect(people.count == 2)
    #expect(people.wasChanged == false)
  }

  @Test
  func changes_when_person_is_added() {
    people.add(Person(name: "Buck", birth: 2000.oct))
    #expect(people.wasChanged)
  }

  @Test
  func returns_nil_if_person_id_not_found() {
    #expect(people.findById(UUID()) == nil)
  }

  @Test
  func returns_person_when_found() {
    let person = Person(name: "Bob", birth: 2010.apr)
    people.add(person)

    #expect(people.findById(person.id) == person)
  }

  @Test
  func replaces_person() {
    let bob = Person(name: "Bob", birth: 2000.feb)
    people.add(bob)
    let robert = Person(bob.id, name: "Robert", birth: 2000.feb)
    people.wasChanged = false

    people.replace(robert)

    #expect(people.findById(bob.id)!.name == "Robert")
    #expect(people.wasChanged)
  }

  @Test
  func changes_when_person_is_removed() {
    let rene = Person(name: "Rene", birth: 2000.oct)
    let sal = Person(name: "Sal", birth: 2000.oct)
    people.add(rene)
    people.add(sal)
    people.wasChanged = false

    people.remove(sal)

    #expect(people.wasChanged)
    #expect(people.findById(sal.id) == nil)
    #expect(people.findById(rene.id)!.name == "Rene")
  }

  @Test
  func sorts_in_alphabetical_order() {
    let bob = Person(name: "Bob", birth: 2000.feb)
    people.add(bob)
    let art = Person(name: "Art", birth: 1990.feb)
    people.add(art)

    #expect(people.sorted().map { $0.name } == ["Art", "Bob"])
  }
}
