import UIKit

protocol TextFieldViewDelegate: class {
    func textField(didEnter text: String)
}

final class TextFieldView: UIView {
    
    static let nibView: TextFieldView = buildNib()
    
    @IBOutlet private var textField: UITextField! {
        didSet {
            textField.delegate = self
            textField.font = UIFont.preferredFont(forTextStyle: .callout)
            textField.adjustsFontForContentSizeCategory = true
            let placeholder = NSAttributedString(string: NSLocalizedString("+ Add New Item", comment: ""),
                                                 attributes: [.foregroundColor: UIColor.gray,
                                                              .font: UIFont.preferredFont(forTextStyle: .callout)])
            textField.attributedPlaceholder = placeholder
            
            textField.layer.cornerRadius = 16
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
