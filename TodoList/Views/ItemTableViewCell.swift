import UIKit

final class ItemTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var stateImage: UIImageView!
    @IBOutlet private var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 0
            titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            titleLabel.adjustsFontForContentSizeCategory = true
        }
    }
    
    @IBOutlet private var subtitleLabel: UILabel! {
        didSet {
            subtitleLabel.numberOfLines = 0
            subtitleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
            subtitleLabel.adjustsFontForContentSizeCategory = true
        }
    }
    
    private var isCompleted = false {
        didSet {
            backgroundColor = isCompleted ? UIColor.white.withAlphaComponent(0.5) : .white
            stateImage.tintColor = isCompleted ? UIColor.black.withAlphaComponent(0.3) : .black
            stateImage.image = isCompleted ? #imageLiteral(resourceName: "completedIcon") : #imageLiteral(resourceName: "todoIcon")
        }
    }
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        subtitleLabel.text = nil
        stateImage.image = nil
        accessoryType = .none
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.preferredContentSizeCategory > .extraExtraLarge {
            stackView.axis = .vertical
        } else {
            stackView.axis = .horizontal
        }
    }
    
    // MARK: - Setter
    func set(title: String, subtitle: String?, isCompleted: Bool) {
        self.isCompleted = isCompleted
        
        titleLabel.attributedText = NSAttributedString(string: title,
                                                       attributes: titleAttributes(isCompleted: isCompleted))
        
        subtitleLabel.attributedText = NSAttributedString(string: subtitle ?? "",
                                                          attributes: subtitleAttributes(isCompleted: isCompleted))
        stackView.layoutIfNeeded()
    }
    
    // MARK: - Private Helpers
    private func setupUI() {
        let heightConstraint = stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
        
        selectionStyle = .none
    }
    
    private func titleAttributes(isCompleted: Bool) -> [NSAttributedStringKey: Any] {
        
        if isCompleted {
            let bodyFont = UIFont.preferredFont(forTextStyle: .body)
            return [.strikethroughStyle: 1, .font: bodyFont, .foregroundColor: UIColor.gray]
        }
        
        return [.font: titleLabel.font, .foregroundColor: UIColor.black]
    }
    
    private func subtitleAttributes(isCompleted: Bool) -> [NSAttributedStringKey: Any] {
        var attributes: [NSAttributedStringKey: Any]
        attributes = isCompleted ? [.foregroundColor: UIColor.lightGray] : [.foregroundColor: UIColor.gray]
        attributes[.font] = subtitleLabel.font
        
        return attributes
    }
}
