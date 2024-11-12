import Foundation

class APIService {
    func getRecipeData(completion: @escaping (Result<Data, Error>) -> Void) {
        let url = URL(
            string: "https://hf-android-app.s3-eu-west-1.amazonaws.com/android-test/recipes.json"
        )!

        URLSession.shared
            .dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                }

                guard let data = data else {
                    completion(.failure(APIError.noData))
                    return
                }

                completion(.success(data))
            }
            .resume()
    }
}

private extension APIService {
    enum APIError: Error {
        case noData
    }
}
