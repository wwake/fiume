import Foundation

enum Persistence {
  static let assumptionsFilename = "assumptions.json"
  static let peopleFilename = "people.json"
  static let plansFilename = "plans.json"
}

func save<T: Encodable>(_ filename: String, _ encodable: T) throws {
  let encoder = JSONEncoder()
  let jsonData = try encoder.encode(encodable)
  let url = URL.documentsDirectory.appending(path: filename)
  let data = Data(jsonData)
  try data.write(to: url, options: [.atomic, .completeFileProtection])
}

func open<T: Decodable>(_ filename: String, _ type: T.Type) throws -> T {
  let url = URL.documentsDirectory.appending(path: filename)
  let data = try Data(contentsOf: url)
  let decoder = JSONDecoder()
  return try decoder.decode(type, from: data)
}
