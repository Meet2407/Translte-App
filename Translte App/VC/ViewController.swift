import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var spainshdisp: UILabel!
    @IBOutlet weak var translateBtn: UIButton!
    @IBOutlet weak var spansihLbl: UILabel!
    @IBOutlet weak var enTextFeild: UITextField!
    @IBOutlet weak var englishLbl: UILabel!
    @IBOutlet weak var spanishBtn: UIButton!
    @IBOutlet weak var englishBtn: UIButton!
    @IBOutlet weak var spanishView: UIView!
    @IBOutlet weak var enView: UIView!
    @IBOutlet weak var translateView: UIView!
    
    let apiCall = TranslteViewModel()
    var pickerView: UIPickerView!
    var activeTextField: UITextField?
    
    let languages = ["hi", "en", "fr", "gu"]
    var sourceLanguage: String = "en"
    var targetLanguage: String = "hi"
    var lastSelectedButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerView()
        setupUI()
        enTextFeild.isUserInteractionEnabled = false
    }
    
    func setupPickerView() {
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([space, doneButton], animated: false)
        enTextFeild.inputAccessoryView = toolbar
    }
    
    @objc func doneTapped() {
        enTextFeild.resignFirstResponder()
    }
    
    func setupUI() {
        translateView.layer.cornerRadius = 10
        translateView.layer.masksToBounds = true
        
        enView.layer.cornerRadius = 10
        enView.layer.masksToBounds = true
        
        spanishView.layer.cornerRadius = 10
        spanishView.layer.masksToBounds = true
        
        translateBtn.layer.cornerRadius = 10
        translateBtn.layer.masksToBounds = true
        
        enTextFeild.layer.backgroundColor = UIColor.clear.cgColor
        
        enTextFeild.attributedPlaceholder = NSAttributedString(
            string: "Enter text here",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
    }

    @IBAction func englishBtnTapped(_ sender: Any) {
        lastSelectedButton = englishBtn
        enTextFeild.isUserInteractionEnabled = true
        enTextFeild.inputView = pickerView
        enTextFeild.becomeFirstResponder()
    }

    @IBAction func spanishBtnTapped(_ sender: Any) {
        lastSelectedButton = spanishBtn
        enTextFeild.isUserInteractionEnabled = true
        enTextFeild.inputView = pickerView
        enTextFeild.becomeFirstResponder()
    }

    @IBAction func translateBtnTapped(_ sender: Any) {
        guard let textToTranslate = enTextFeild.text, !textToTranslate.isEmpty else {
            spansihLbl.text = "Please enter text to translate."
            return
        }
        translateText(text: textToTranslate, from: sourceLanguage, to: targetLanguage)
    }

    func translateText(text: String, from source: String, to target: String) {
        apiCall.translate(from: source, to: target, text: text) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let jsonResponse = response as? TransModel {
                        if let translatedText = jsonResponse.trans.title as? String {
                            self?.spainshdisp.text = translatedText
                        } else {
                            self?.spainshdisp.text = "Translation failed."
                        }
                    } else {
                        self?.spansihLbl.text = "Translation failed. Check the response format."
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.spansihLbl.text = "Translation Failed: \(error.localizedDescription)"
                }
            }
        }
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row].uppercased()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if lastSelectedButton == englishBtn {
            sourceLanguage = languages[row]
            englishBtn.setTitle(sourceLanguage.uppercased(), for: .normal)
            englishLbl.text = sourceLanguage.uppercased()
        } else if lastSelectedButton == spanishBtn {
            targetLanguage = languages[row]
            spanishBtn.setTitle(targetLanguage.uppercased(), for: .normal)
            spansihLbl.text = targetLanguage.uppercased()
        }
    }
}
