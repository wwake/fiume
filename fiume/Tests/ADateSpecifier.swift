@testable import fiume
import Testing

struct ADateSpecifier {
  private func makePerson() -> Person {
    Person(name: "bub", birth: MonthYear(.mar, 1970), death: nil)
  }

  @Test
  func equatable() throws {
    #expect((DateSpecifier.unchanged) == DateSpecifier.unchanged)
    #expect((DateSpecifier.month(MonthYear(.jan, 2025))) == DateSpecifier.month(MonthYear(.jan, 2025)))
    #expect(DateSpecifier.month(MonthYear(.jan, 2025)) != DateSpecifier.month(MonthYear(.apr, 2025)))
    #expect(DateSpecifier.month(MonthYear(.jan, 2025)) != DateSpecifier.age(makePerson(), 67))
    #expect(DateSpecifier.month(MonthYear(.feb, 2025)) != DateSpecifier.unchanged)
  }

  @Test
  func update_when_month_values_change() {
    let value1 = DateSpecifier.month(MonthYear(.jan, 1999))
    let value2 = DateSpecifier.month(MonthYear(.jan, 2000))
    let sut = value1.update(using: value2)
    #expect(sut == DateSpecifier.month(MonthYear(.jan, 2000)))
  }

  @Test
  func update_retains_original_when_new_month_value_is_unchanged() {
    let value1 = DateSpecifier.month(MonthYear(.dec, 2030))
    let value2 = DateSpecifier.unchanged
    let sut = value1.update(using: value2)
    #expect(sut == DateSpecifier.month(MonthYear(.dec, 2030)))
  }

  @Test
  func update_when_values_change() {
    let value1 = DateSpecifier.month(MonthYear(.oct, 2024))
    let value2 = DateSpecifier.month(MonthYear(.dec, 2024))
    let sut = value1.update(using: value2)
    #expect(sut == DateSpecifier.month(MonthYear(.dec, 2024)))
  }

  @Test
  func update_retains_original_when_new_value_is_unchanged() {
    let value1 = DateSpecifier.month(MonthYear(.oct, 2024))
    let value2 = DateSpecifier.unchanged
    let sut = value1.update(using: value2)
    #expect(sut == DateSpecifier.month(MonthYear(.oct, 2024)))
  }

  @Test
  func update_age_changes() {
    let value1 = DateSpecifier.month(MonthYear(.oct, 2024))
    let person = makePerson()
    let value2 = DateSpecifier.age(person, 70)
    let sut = value1.update(using: value2)
    #expect(sut == DateSpecifier.age(person, 70))
  }

  @Test
  func description() {
    #expect(DateSpecifier.unchanged.description == "(unchanged)")
    #expect(DateSpecifier.month(MonthYear(.apr, 2023)).description == "April, 2023")
    #expect(DateSpecifier.age(makePerson(), 72).description == "bub@72")
  }
}
