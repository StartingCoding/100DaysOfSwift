import UIKit
import PlaygroundSupport

let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 500, height: 100)))
view.backgroundColor = .red

PlaygroundPage.current.liveView = view

// Challenge 1
extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

view.bounceOut(duration: 1)

// Challenge 2
extension Int {
    func times(_ closure: () -> Void ) {
        guard self > 0 else { return }
        
        for _ in 1...self {
            closure()
        }
    }
}

5.times { print("Hello World") }

// Challenge 3

var test = [1, 2, 3, 4, 1]

extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        if let index = self.firstIndex(of: item) {
            self.remove(at: index)
        }
    }
}

test.remove(item: 1)
print(test)
test.remove(item: 1)
print(test)
test.remove(item: 9)
print(test)
