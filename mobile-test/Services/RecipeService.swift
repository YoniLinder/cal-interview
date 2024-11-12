import Foundation

class RecipeService {
    private let api = APIService()
    private var recipes: [Recipe] = []
    
    func updateRecipes(completion: @escaping (Bool) -> Void) {
        api.getRecipeData { result in
            switch result {
            case .success(let json):
                let decoder = JSONDecoder()

                do {
                    let jsonRecipes = try decoder.decode([Recipe].self, from: json)
                    self.recipes = jsonRecipes
                    completion(true)
                } catch {
                    print("\(error)")
                    completion(false)
                }
                
            case .failure(let error):
                print("\(error)")
                completion(false)
            }
        }
    }
    
    func queryAny() -> [Recipe] { recipes }
}
