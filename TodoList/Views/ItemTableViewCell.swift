import UIKit

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var label: UILabel! {
        didSet {
            label.numberOfLines = 0
            label.font = UIFont.preferredFont(forTextStyle: .headline)
            label.adjustsFontForContentSizeCategory = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }
    
    private func setupUI() {
        label.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = label.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
        
        selectionStyle = .none
    }
    
    func set(text: String, isCompleted: Bool) {
        
        backgroundColor = isCompleted ? UIColor.white.withAlphaComponent(0.3) : .white
        
        label.attributedText = NSAttributedString(string: text,
                                                  attributes: attributes(isCompleted: isCompleted))
    }
    
    private func attributes(isCompleted: Bool) -> [NSAttributedStringKey: Any] {
        
        if isCompleted {
            let bodyFont = UIFont.preferredFont(forTextStyle: .body)
            return [.strikethroughStyle: 1, .font: bodyFont, .foregroundColor: UIColor.lightGray]
        }
        
        return [.font: label.font, .foregroundColor: UIColor.black]
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
        accessoryType = .none
    }
}
