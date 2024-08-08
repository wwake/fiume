@testable import fiume
import fiume_model
import Testing

struct ADateRange {
  private let people = People()

  @Test
  func determines_amount_outside_month_year_date_range() throws {
    let sut = DateRange(.month(2020.jan), .month(2020.oct))
    #expect(!sut.includes(2019.dec, people))
    #expect(!sut.includes(2020.nov, people))
  }

  @Test
  func determines_amount_inside_month_year_date_range() throws {
    let sut = DateRange(.month(2020.jan), .month(2020.oct))
    #expect(sut.includes(2020.jan, people))
    #expect(sut.includes(2020.oct, people))
  }

  @Test
  func starts_month_at_1_when_unspecified() {
    let sut = DateRange(DateSpecifier.unchanged, .month(2020.feb))
    #expect(sut.includes(2020.jan, people))
  }

  @Test
  func can_start_at_an_age() {
    let bob = Person(name: "Bob", birth: 1970.jan, death: nil)
    people.add(bob)
    let sut = DateRange(.age(bob.id, 40), .unchanged)
    #expect(!sut.includes(2009.dec, people))
    #expect(sut.includes(2010.jan, people))
  }

  @Test
  func can_end_at_an_age() {
    let bob = Person(name: "Bob", birth: 1970.jan, death: nil)
    people.add(bob)
    let sut = DateRange(.unchanged, .age(bob.id, 40))
    #expect(sut.includes(2009.dec, people))
    #expect(!sut.includes(2010.jan, people))
  }

  @Test
  func description_is_empty_if_range_is_empty() {
    let sut = DateRange.always
    #expect(sut.description(people).isEmpty)
  }

  @Test
  func description_shows_first_and_last_if_not_empty() {
    let sut = DateRange(.unchanged, .month(2030.jan))
    #expect(sut.description(people) == "-Jan 2030")
  }
}
