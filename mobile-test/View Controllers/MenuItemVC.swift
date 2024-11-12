import UIKit

class MenuItemVC: UIViewController {
    // MARK: - Views
    let itemView = UIRecipeItemView()
    
    // MARK: - Properties
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemView.configure(with: recipe!)
        
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(itemView)
        
        NSLayoutConstraint.activate([
            itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            itemView.topAnchor.constraint(equalTo: view.topAnchor),
            itemView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.layoutIfNeeded()
    }
}
