import UIKit

class RecipeThumbnailCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: RecipeThumbnailCell.self)

    func configure(with recipe: Recipe) {
        recipeView.configure(with: recipe)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private lazy var recipeView = UIRecipeThumbnailView()

    private func setupViews() {
        contentView.addSubview(recipeView)
        NSLayoutConstraint.activate([
            recipeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recipeView.topAnchor.constraint(equalTo: contentView.topAnchor),
            recipeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
