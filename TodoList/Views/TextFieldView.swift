import UIKit

protocol TextFieldViewDelegate: class {
    func textField(didEnter text: String)
}


class TextFieldView: UIView {
    
    static let nibView: TextFieldView = buildNib()
    
    @IBOutlet var textField: UITextField! {
        didSet {
            textField.delegate = self
            textField.font = UIFont.preferredFont(forTextStyle: .callout)
            textField.adjustsFontForContentSizeCategory = true
            textField.placeholder = NSLocalizedString("+ Add New Item", comment: "")
            
            textField.layer.cornerRadius = bounds.height/2
            textField.layer.masksToBounds = true
            textField.layer.borderColor = UIColor.black.cgColor
            textField.layer.borderWidth = 1
        }
    }
    
    weak var delegate: TextFieldViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = textField.heightAnchor.constraint(greaterThanOrEqualToConstant: 64)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
    }
}

extension TextFieldView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        
        delegate?.textField(didEnter: text)
        textField.text = ""
        return true
    }
}
