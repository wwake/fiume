@testable import fiume
import Testing

struct SomePeople {
  @Test
  func startsUnchanged() {
    let people = People()
    #expect(!people.wasChanged)
  }

  @Test
  func doesntChangeWhenNewPeopleLoaded() {
    let people = People()
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
    let people = People()
    people.add(Person(name: "Buck", birth: 2000.oct, death: nil))
    #expect(people.wasChanged)
  }
}
