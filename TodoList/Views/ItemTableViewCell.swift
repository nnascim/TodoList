import UIKit

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let heightConstraint = label.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
        
        selectionStyle = .none
    }
    
    func set(text: String, isCompleted: Bool) {
        
        accessoryType = isCompleted ? .checkmark : .none
        
        if isCompleted {
            label.attributedText = NSAttributedString(string: text, attributes: [.strikethroughStyle: 1])
        } else {
            label.attributedText = nil
            label.text = text
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
        accessoryType = .none
    }
}
