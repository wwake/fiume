import Foundation

func save<T: Encodable>(_ filename: String, _ encodable: T) throws {
  let encoder = JSONEncoder()
  let url = URL.documentsDirectory.appending(path: filename)
  let jsonData = try encoder.encode(encodable)
  let data = Data(jsonData)
  try data.write(to: url, options: [.atomic, .completeFileProtection])
}

func open<T: Decodable>(_ filename: String, _ type: T.Type) throws -> T {
  let url = URL.documentsDirectory.appending(path: filename)
  let data = try Data(contentsOf: url)

  let decoder = JSONDecoder()
  return try decoder.decode(type, from: data)
}
