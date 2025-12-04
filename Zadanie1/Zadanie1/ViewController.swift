import UIKit

class ViewController: UIViewController {

    @IBOutlet var resultLabel: UILabel!
    var lastPressed: UIButton = UIButton()
    
    enum Operation: String {
        case add ,subtract, multiply, divide, none
    }
    
    // variables
    var memory: Double = 0.0
    var shouldReplaceLabel: Bool = true
    var operation: Operation = .none
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clear()
    }

    func clear() {
        memory = 0.0
        shouldReplaceLabel = true
        operation = .none
        resultLabel.text = "0"
    }

    
    func doubleToString(_ value: Double) -> String {
        let str = String(value).replacingOccurrences(of: ".", with: ",")
        if str.suffix(2) == ",0" {
            return String(str.dropLast(2))
        }
        return str
    }
    
    func stringToDouble(_ value: String) -> Double {
        var str = value
        if str.isEmpty {
            str = "0"
        }
        if str.last == "," {
            str.append("0")
        }
        return Double(str.replacingOccurrences(of: ",", with: ".")) ?? 0.0
    }
    
    func handleOperation() {
        let number: Double = stringToDouble(resultLabel.text!)
        print("current number: \(number)")
        
        switch operation {
        case .add:
            memory += number
        case .subtract:
            memory -= number
        case .multiply:
            memory *= number
        case .divide:
            if number == 0.0 {
                clear()
                resultLabel.text = "Undefined"
                return
            } else {
                memory /= number
            }
        case .none:
            memory = number
        }
        
        operation = .none
        shouldReplaceLabel = true
        resultLabel.text = doubleToString(memory)
    }
        
    
    func handleNumberPressed(_ number: String) {
        if shouldReplaceLabel {
            if number != "0" {
                shouldReplaceLabel = false
            }
            resultLabel.text = number
        } else {
            if resultLabel.text != "0" || number != "0" {
                resultLabel.text = resultLabel.text! + number
            }
        }
    }
    
    @IBAction func pressed_number(_ sender: UIButton) {
        let number: String = sender.titleLabel!.text!
        handleNumberPressed(number)
    }
    
    
    @IBAction func pressed_clear(_ sender: UIButton) {
        clear()
    }
    
    @IBAction func pressed_sub(_ sender: UIButton) {
        handleOperation()
        operation = .subtract
    }
    
    @IBAction func pressed_add(_ sender: UIButton) {
        handleOperation()
        operation = .add
    }
    
    @IBAction func pressed_mul(_ sender: UIButton) {
        handleOperation()
        operation = .multiply
    }
    
    @IBAction func pressed_div(_ sender: UIButton) {
        handleOperation()
        operation = .divide
    }
    
    @IBAction func pressed_equal(_ sender: UIButton) {
        handleOperation()
    }
    
    @IBAction func pressed_sign(_ sender: UIButton) {
        if resultLabel.text != "0" && resultLabel.text != "Undefined" {
            shouldReplaceLabel = false
            resultLabel.text = "-" + resultLabel.text!
        }
    }
    @IBAction func pressed_dot(_ sender: UIButton) {
        if shouldReplaceLabel {
            resultLabel.text = "0,"
            shouldReplaceLabel = false
        } else {
            if resultLabel.text!.contains(",") {
                return
            }
            resultLabel.text = resultLabel.text! + ","
        }
    }
    
    @IBAction func pressed_percent(_ sender: Any) {
        if resultLabel.text != "0" && resultLabel.text != "Undefined" {
            shouldReplaceLabel = false
            var number: Double = stringToDouble(resultLabel.text!)
            number /= 100.0
            resultLabel.text = doubleToString(number)
        }
        operation = .none
        shouldReplaceLabel = true
    }
    
    @IBAction func pressed_log(_ sender: UIButton) {
        if resultLabel.text == "0" {
            clear()
            resultLabel.text = "Undefined"
        } else if resultLabel.text != "Undefined" {
            shouldReplaceLabel = false
            var number: Double = stringToDouble(resultLabel.text!)
            number = log10(number)
            resultLabel.text = doubleToString(number)
        }
        operation = .none
        shouldReplaceLabel = true
    }
    
    @IBAction func pressed_pow(_ sender: UIButton) {
        if resultLabel.text != "Undefined" {
            shouldReplaceLabel = false
            var number: Double = stringToDouble(resultLabel.text!)
            number *= number
            resultLabel.text = doubleToString(number)
        }
        operation = .none
        shouldReplaceLabel = true
    }
}

