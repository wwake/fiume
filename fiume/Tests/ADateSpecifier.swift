@testable import fiume
import Testing

struct ADateSpecifier {
  private func makePerson() -> Person {
    Person(name: "bub", birth: MonthYear(month: 2, year: 1970), death: nil)
  }

  @Test
  func equatable() throws {
    #expect((DateSpecifier.unchanged) == DateSpecifier.unchanged)
    #expect(DateSpecifier.month(3) != DateSpecifier.unchanged)
    #expect(DateSpecifier.unchanged != DateSpecifier.month(3))
    #expect((DateSpecifier.month(3)) == DateSpecifier.month(3))
    #expect(DateSpecifier.month(3) != DateSpecifier.month(4))
    #expect(DateSpecifier.month(3) != DateSpecifier.age(makePerson(), 67))
  }

  @Test
  func update_when_values_change() {
    let value1 = DateSpecifier.month(10)
    let value2 = DateSpecifier.month(12)
    let sut = value1.update(using: value2)
    #expect(sut == DateSpecifier.month(12))
  }

  @Test
  func update_retains_original_when_new_value_is_unchanged() {
    let value1 = DateSpecifier.month(10)
    let value2 = DateSpecifier.unchanged
    let sut = value1.update(using: value2)
    #expect(sut == DateSpecifier.month(10))
  }

  @Test
  func update_age_changes() {
    let value1 = DateSpecifier.month(10)
    let person = makePerson()
    let value2 = DateSpecifier.age(person, 70)
    let sut = value1.update(using: value2)
    #expect(sut == DateSpecifier.age(person, 70))
  }

  @Test
  func description() {
    #expect(DateSpecifier.unchanged.description == "(unchanged)")
    #expect(DateSpecifier.month(3).description == "3")
    #expect(DateSpecifier.age(makePerson(), 72).description == "bub@72")
  }
}
