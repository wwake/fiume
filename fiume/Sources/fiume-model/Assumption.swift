public enum Assumption: Identifiable {
  case percent(String, Double, Double, Double)

  public var name: String {
    switch self {
    case .percent(let name, _, _, _):
      return name
    }
  }

  public var id: String {
    name
  }
}
