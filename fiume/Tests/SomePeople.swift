@testable import fiume
import Testing

struct SomePeople {
  @Test
  func startsUnchanged() {
    let people = People()
    #expect(!people.wasChanged)
  }

  @Test
  func changesWhenPersonIsAdded() {
    let people = People()
    people.add(Person(name: "Buck", birth: 2000.oct, death: nil))
    #expect(people.wasChanged)
  }
}
