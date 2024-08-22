@testable import fiume
import fiume_model
import Foundation
import Testing

struct ADateSpecifier {
  private func makePerson() -> Person {
    Person(name: "bub", birth: 1970.mar)
  }

  @Test
  func is_equatable() throws {
    let person = makePerson()
    #expect((DateSpecifier.unchanged) == DateSpecifier.unchanged)
    #expect((DateSpecifier.month(2025.jan)) == DateSpecifier.month(2025.jan))
    #expect(DateSpecifier.month(2025.jan) != DateSpecifier.month(2025.apr))
    #expect(DateSpecifier.month(2025.jan) != DateSpecifier.age(person.id, 67))
    #expect(DateSpecifier.month(2025.feb) != DateSpecifier.unchanged)
  }

  @Test
  func updates_when_month_values_change() {
    let value1 = DateSpecifier.month(1999.jan)
    let value2 = DateSpecifier.month(2000.jan)
    let sut = value1.update(using: value2)
    #expect(sut == DateSpecifier.month(2000.jan))
  }

  @Test
  func updates_retains_original_when_new_month_value_is_unchanged() {
    let value1 = DateSpecifier.month(2030.dec)
    let value2 = DateSpecifier.unchanged
    let sut = value1.update(using: value2)
    #expect(sut == DateSpecifier.month(2030.dec))
  }

  @Test
  func updates_when_values_change() {
    let value1 = DateSpecifier.month(2024.oct)
    let value2 = DateSpecifier.month(2024.dec)
    let sut = value1.update(using: value2)
    #expect(sut == DateSpecifier.month(2024.dec))
  }

  @Test
  func retains_original_when_new_value_is_unchanged() {
    let value1 = DateSpecifier.month(2024.oct)
    let value2 = DateSpecifier.unchanged
    let sut = value1.update(using: value2)
    #expect(sut == DateSpecifier.month(2024.oct))
  }

  @Test
  func updates_age_changes() {
    let value1 = DateSpecifier.month(2024.oct)
    let person = makePerson()
    let value2 = DateSpecifier.age(person.id, 70)
    let sut = value1.update(using: value2)
    #expect(sut == DateSpecifier.age(person.id, 70))
  }

  @Test
  func description_from_found_person() {
    let people = People.shared
    let person = makePerson()
    people.add(person)
    #expect(DateSpecifier.unchanged.description.isEmpty)
    #expect(DateSpecifier.month(2023.apr).description == "Apr 2023")
    #expect(DateSpecifier.age(person.id, 72).description == "bub@72")
  }

  @Test
  func description_from_person_not_found() {
    #expect(DateSpecifier.age(UUID(), 72).description == "<person not found>@72")
  }

  @Test
  func effective_start_for_unchanged() {
    #expect(DateSpecifier.unchanged.effectiveStart == MonthYear.start)
  }

  @Test
  func effective_start_for_month() {
    #expect(DateSpecifier.month(2099.mar).effectiveStart == 2099.mar)
  }

  @Test
  func effective_start_for_age() {
    let people = People.shared
    let person = makePerson() // b. 1970.mar
    people.add(person)

    #expect(DateSpecifier.age(person.id, 50).effectiveStart == 2020.mar)
  }

  @Test
  func effective_start_for_age_when_person_not_found() {
    #expect(DateSpecifier.age(UUID(), 50).effectiveStart > 2200.jan)
  }
}
