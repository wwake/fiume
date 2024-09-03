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
    #expect((DateSpecifier.assumption("Holiday")) == DateSpecifier.assumption("Holiday"))
    #expect(DateSpecifier.assumption("Holiday") != DateSpecifier.assumption("SS Starts"))
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
  func description_from_found_assumption() {
    let assumptions = PercentAssumptions.shared
    let assumption = Assumption(type: .date, name: "SS Start", min: 2030, max: 2050, current: 2040)
    assumptions.add(assumption)

    let sut = DateSpecifier.assumption("SS Start")

    #expect(sut.description == "SS Start, currently 2040")
  }

  @Test
  func description_from_assumption_not_found() {
    #expect(DateSpecifier.assumption("Missing").description == "<Assumed date 'Missing' not found>")
  }

  @Test
  func effective_start_for_unchanged() {
    #expect(DateSpecifier.unchanged.effectiveStart == 1900.jan)
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

  @Test
  func effective_start_for_found_assumed_date() {
    let assumptions = PercentAssumptions.shared
    let assumption = Assumption(type: .date, name: "SS Start", min: 2030, max: 2050, current: 2040)
    assumptions.add(assumption)

    let sut = DateSpecifier.assumption("SS Start")

    #expect(sut.effectiveStart == 2040.jan)
  }

  @Test
  func effective_start_for_assumed_date_not_found() {
    #expect(DateSpecifier.assumption("Missing").effectiveStart == 1900.jan)
  }

  @Test
  func geq_for_found_assumed_date() {
    let assumptions = PercentAssumptions.shared
    let assumption = Assumption(type: .date, name: "SS Start", min: 2030, max: 2050, current: 2040)
    assumptions.add(assumption)

    let sut = DateSpecifier.assumption("SS Start")
    #expect(sut.geq(2039.dec))
    #expect(sut.geq(2040.jan))
    #expect(!sut.geq(2040.feb))
  }

  @Test
  func geq_for_assumed_date_not_found() {
    #expect(!DateSpecifier.assumption("Missing").geq(2000.jan))
  }
}
