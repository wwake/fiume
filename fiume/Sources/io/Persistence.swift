import Foundation

func save<T: Encodable>(_ filename: String, _ encodable: T) {
  print(URL.documentsDirectory)
  let encoder = JSONEncoder()
  do {
    let url = URL.documentsDirectory.appending(path: filename)
    let jsonData = try encoder.encode(encodable)
    let data = Data(jsonData)
    try data.write(to: url, options: [.atomic, .completeFileProtection])
  } catch {
    print(error.localizedDescription)
  }
}

func open<T: Decodable>(_ filename: String, _ type: T.Type) -> T {
  print(URL.documentsDirectory)
  let url = URL.documentsDirectory.appending(path: filename)

  guard let data = try? Data(contentsOf: url) else {
    fatalError("Failed to load \(url).")
  }

  let decoder = JSONDecoder()

  guard let loaded = try? decoder.decode(type, from: data) else {
    fatalError("Failed to decode \(type) from \(url).")
  }

  return loaded
}
