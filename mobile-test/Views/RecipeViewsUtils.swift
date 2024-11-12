import UIKit

enum RecipeViewsUtils {
    static func makeGenericLabel(withTextSize size: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: size)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }
}
