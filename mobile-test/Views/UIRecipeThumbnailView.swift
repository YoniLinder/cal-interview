import UIKit

class UIRecipeThumbnailView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func configure(with recipe: Recipe) {
        nameLabel.text = recipe.name
        fatsLabel.text = "fats: " + recipe.fats
        caloriesLabel.text = "calories: " + recipe.calories
        carbosLabel.text = "carbos: " + recipe.carbos

        thumbnail.setImage(with: URL(string: recipe.thumb)!)
    }

    private lazy var nameLabel: UILabel = {
        RecipeViewsUtils.makeGenericLabel(withTextSize: 14)
    }()

    private lazy var fatsLabel: UILabel = {
        RecipeViewsUtils.makeGenericLabel(withTextSize: 12)
    }()
    
    private lazy var caloriesLabel: UILabel = {
        RecipeViewsUtils.makeGenericLabel(withTextSize: 12)
    }()
    
    private lazy var carbosLabel: UILabel = {
        RecipeViewsUtils.makeGenericLabel(withTextSize: 12)
    }()

    private lazy var thumbnail: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        iv.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        thumbnail.layer.masksToBounds = true
        thumbnail.contentMode = .scaleAspectFit
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        addSubview(thumbnail)
        addSubview(fatsLabel)
        addSubview(caloriesLabel)
        addSubview(carbosLabel)

        NSLayoutConstraint.activate([
            carbosLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            carbosLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            caloriesLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            caloriesLabel.bottomAnchor.constraint(equalTo: carbosLabel.topAnchor, constant: 1),
            
            fatsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            fatsLabel.bottomAnchor.constraint(equalTo: caloriesLabel.topAnchor, constant: 1),

            thumbnail.centerXAnchor.constraint(equalTo: centerXAnchor),
            thumbnail.topAnchor.constraint(equalTo: topAnchor),
            thumbnail.bottomAnchor.constraint(equalTo: fatsLabel.topAnchor, constant: -4),
            
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: thumbnail.topAnchor),
        ])
    }
}

private extension UIImageView {
    func setImage(with url: URL) {
        Task { @MainActor in
            do {
                if #available(iOS 15.0, *) {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    image = UIImage(data: data)
                } else {
                    // We have dropped support for ios below 15
                }
            } catch {
                image = nil
            }
        }
    }
}
