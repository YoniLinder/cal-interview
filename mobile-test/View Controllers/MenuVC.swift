import LocalAuthentication
import UIKit

class MenuVC: UIViewController {
    // MARK: - Views
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )

    // MARK: - Properties
    var recipes: [Recipe] = []
    var api: RecipeService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
            
        self.recipes = self.api?.queryAny() ?? []
        self.collectionView.reloadData()
    }
}

// MARK: - Collection View Delegate & Data Source
extension MenuVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recipes.count
    }

    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecipeThumbnailCell.reuseIdentifier, for: indexPath
        ) as! RecipeThumbnailCell
        cell.configure(with: recipes[indexPath.item])
        return cell
    }
}

extension MenuVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                        error: &error) else {
            presentCantAuthenticateAlert()
            return
        }
        
        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Please provide fingerprint authentification"
        ) { success, error in
            DispatchQueue.main.async { [weak self] in
                guard success else {
                    self?.presentAuthenticationFailedAlertWithError(String(describing: error))
                    return
                }
                
                let menuItemVC = MenuItemVC()
                menuItemVC.recipe = self?.recipes[indexPath.item]
                self?.navigationController?.pushViewController(menuItemVC, animated: true)
            }
        }
    }
    
    private func presentCantAuthenticateAlert() {
        let cantAuthenticateAlert = UIAlertController(
            title: "Biometry unavailable",
            message: "Can only view menu items with biometric authentication",
            preferredStyle: .alert
        )
        cantAuthenticateAlert.addAction(UIAlertAction(title: "ok", style: .default))
        present(cantAuthenticateAlert, animated: true)
    }
    
    private func presentAuthenticationFailedAlertWithError(_ error: String) {
        let authenticationFailedAlert = UIAlertController(
            title: "Authentication failed",
            message: "error: \(error)",
            preferredStyle: .alert
        )
        authenticationFailedAlert.addAction(UIAlertAction(title: "ok", style: .default))
        self.present(authenticationFailedAlert, animated: true)
    }
}

// MARK: - Layout & View helpers
private extension MenuVC {
    func setupViews() {
        view.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        collectionView.register(RecipeThumbnailCell.self, 
                                forCellWithReuseIdentifier: RecipeThumbnailCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self

        guard let collectionLayout = collectionView.collectionViewLayout 
                as? UICollectionViewFlowLayout else {
            preconditionFailure("Unexpected collection layout")
        }

        collectionLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: 120)
        collectionLayout.minimumInteritemSpacing = 10
        collectionLayout.minimumLineSpacing = 40

        let stack = UIStackView(arrangedSubviews: [collectionView])
        stack.axis = .vertical
        stack.distribution = .fill

        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.topAnchor.constraint(equalTo: view.topAnchor),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        view.layoutIfNeeded()
    }
}
