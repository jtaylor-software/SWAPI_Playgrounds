import UIKit

struct Person: Decodable {
    let name: String
    let films: [URL]
}

struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
}

class SwapiService {
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    
    static let personEndpoint = "people"
    static let filmsEndpoint = "films"
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
      // 1 - Prepare URL
        guard let baseURL = baseURL else {return completion(nil) }
        let finalURL = baseURL.appendingPathComponent(personEndpoint).appendingPathComponent("\(id)")
        
      // 2 - Contact server
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return completion(nil)
            }
            
            guard let data = data else { return completion(nil)}
            
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                return completion(person)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return completion(nil)
            }
            
            guard let data = data else { return completion(nil)}
            
            do {
                let film = try JSONDecoder().decode(Film.self, from: data)
                return completion(film)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func fetchFilm(url: URL) {
      SwapiService.fetchFilm(url: url) { film in
          if let film = film {
              print(film)
          }
      }
    }
}

SwapiService.fetchPerson(id: 2) { (person) in
    if let person = person {
        print(person.name)
        for film in person.films {
            SwapiService.fetchFilm(url: film) { (film) in
                if let film = film {
                    print(film.title)
                }
            }
        }
    }
}
