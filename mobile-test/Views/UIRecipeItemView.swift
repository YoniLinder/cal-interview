import UIKit

class UIRecipeItemView: UIView {
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
        descriptionLabel.text = recipe.description

        image.setImage(with: URL(string: recipe.image)!)
    }

    private lazy var nameLabel: UILabel = {
        RecipeViewsUtils.makeGenericLabel(withTextSize: 24)
    }()

    private lazy var fatsLabel: UILabel = {
        RecipeViewsUtils.makeGenericLabel(withTextSize: 16)
    }()
    
    private lazy var caloriesLabel: UILabel = {
        RecipeViewsUtils.makeGenericLabel(withTextSize: 16)
    }()
    
    private lazy var carbosLabel: UILabel = {
        RecipeViewsUtils.makeGenericLabel(withTextSize: 16)
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = RecipeViewsUtils.makeGenericLabel(withTextSize: 16)
        label.numberOfLines = 0
        return label
    }()

    private lazy var image: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        iv.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private static let imageAspectRatio: CGFloat = 502.0/710.0

    override func layoutSubviews() {
        super.layoutSubviews()
        image.layer.masksToBounds = true
        image.contentMode = .scaleToFill
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        addSubview(image)
        addSubview(fatsLabel)
        addSubview(caloriesLabel)
        addSubview(carbosLabel)
        addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            image.widthAnchor.constraint(equalTo: widthAnchor, constant: -10),
            image.heightAnchor.constraint(equalTo: image.widthAnchor,
                                          multiplier: Self.imageAspectRatio),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10),
            descriptionLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -10),
            
            fatsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            fatsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            
            caloriesLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            caloriesLabel.topAnchor.constraint(equalTo: fatsLabel.bottomAnchor, constant: 2),
            
            carbosLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            carbosLabel.topAnchor.constraint(equalTo: caloriesLabel.bottomAnchor, constant: 2)
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
