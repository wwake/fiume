@testable import fiume
import Foundation
import Testing

struct ADateSpecifier {
  private func makePerson() -> Person {
    Person(name: "bub", birth: 1970.mar, death: nil)
  }

  @Test
  func equatable() throws {
    let person = makePerson()
    #expect((DateSpecifier.unchanged) == DateSpecifier.unchanged)
    #expect((DateSpecifier.month(2025.jan)) == DateSpecifier.month(2025.jan))
    #expect(DateSpecifier.month(2025.jan) != DateSpecifier.month(2025.apr))
    #expect(DateSpecifier.month(2025.jan) != DateSpecifier.age(person.id, person.name, person.birth, 67))
    #expect(DateSpecifier.month(2025.feb) != DateSpecifier.unchanged)
  }

  @Test
  func update_when_month_values_change() {
    let value1 = DateSpecifier.month(1999.jan)
    let value2 = DateSpecifier.month(2000.jan)
    let sut = value1.update(using: value2)
    #expect(sut == DateSpecifier.month(2000.jan))
  }

  @Test
  func update_retains_original_when_new_month_value_is_unchanged() {
    let value1 = DateSpecifier.month(2030.dec)
    let value2 = DateSpecifier.unchanged
    let sut = value1.update(using: value2)
    #expect(sut == DateSpecifier.month(2030.dec))
  }

  @Test
  func update_when_values_change() {
    let value1 = DateSpecifier.month(2024.oct)
    let value2 = DateSpecifier.month(2024.dec)
    let sut = value1.update(using: value2)
    #expect(sut == DateSpecifier.month(2024.dec))
  }

  @Test
  func update_retains_original_when_new_value_is_unchanged() {
    let value1 = DateSpecifier.month(2024.oct)
    let value2 = DateSpecifier.unchanged
    let sut = value1.update(using: value2)
    #expect(sut == DateSpecifier.month(2024.oct))
  }

  @Test
  func update_age_changes() {
    let value1 = DateSpecifier.month(2024.oct)
    let person = makePerson()
    let value2 = DateSpecifier.age(person.id, person.name, person.birth, 70)
    let sut = value1.update(using: value2)
    #expect(sut == DateSpecifier.age(person.id, person.name, person.birth, 70))
  }

  @Test
  func descriptionFromFoundPerson() {
    let people = People()
    let person = makePerson()
    people.add(person)
    #expect(DateSpecifier.unchanged.description(people) == "(unchanged)")
    #expect(DateSpecifier.month(2023.apr).description(people) == "April, 2023")
    #expect(DateSpecifier.age(person.id, person.name, person.birth, 72).description(people) == "bub@72")
  }

  @Test
  func descriptionFromPersonNotFound() {
    let people = People()
    #expect(DateSpecifier.age(UUID(), "name", 1970.oct, 72).description(people) == "<person not found>@72")
  }
}
