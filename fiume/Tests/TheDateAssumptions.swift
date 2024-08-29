@testable import fiume
import fiume_model
import Testing

@Observable
public class DateAssumptions {
  var wasChanged = false
  var assumptions = [DateAssumption]()

  public func add(_ assumption: DateAssumption) {
    assumptions.append(assumption)
    wasChanged = true
  }

  public func find(_ name: String) -> DateAssumption? {
    assumptions.first { $0.name == name }
  }

  public func remove(_ name: String) {
    assumptions.removeAll { $0.name == name }
    wasChanged = true
  }

  public func replace(_ newAssumption: DateAssumption) {
    remove(newAssumption.name)
    add(newAssumption)
    wasChanged = true
  }
}

public struct DateAssumption {
  public var name: String
  public var min: Int
  public var max: Int
  public var current: Int

  init(_ name: String, min: Int, max: Int, current: Int) {
    self.name = name
    self.min = min
    self.max = max
    self.current = current
  }

  init(_ base: DateAssumption, _ newCurrent: Int) {
    self = base
    self.current = newCurrent
  }
}

struct TheDateAssumptions {
  func makeAssumptions() -> DateAssumptions {
    DateAssumptions()
  }

  @Test
  func adds_new_assumptions() {
    let sut = makeAssumptions()
    sut.wasChanged = false

    sut.add(DateAssumption("Holiday", min: 2020, max: 2030, current: 2025))

    #expect(sut.wasChanged)
    #expect(sut.find("Holiday") != nil)
  }

  @Test
  func remove_assumption() {
    let sut = makeAssumptions()
    sut.add(DateAssumption("Holiday", min: 2020, max: 2030, current: 2025))
    sut.wasChanged = false

    sut.remove("Holiday")

    #expect(sut.wasChanged)
    #expect(sut.find("the one") == nil)
  }

  @Test
  func replaces_an_assumption() {
    let sut = makeAssumptions()
    let assumption = DateAssumption("Holiday", min: 2020, max: 2030, current: 2025)
    sut.add(assumption)
    sut.wasChanged = false

    sut.replace(DateAssumption(assumption, 2027))

    #expect(sut.wasChanged)
    #expect(sut.find("Holiday")!.current == 2027)
  }
}
