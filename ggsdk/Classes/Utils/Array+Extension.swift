import Foundation

extension Array {
    
    mutating func randomArray() {
        var list = self
        for index in 0..<list.count {
            let newIndex = Int(arc4random_uniform(UInt32(list.count-index))) + index
            if index != newIndex {
                list.swapAt(index, newIndex)
            }
        }
        self = list
    }
    
}

func array2NSMutableArray(_ array: [Any]) -> NSMutableArray {
    let NSMutableArray: NSMutableArray = []
    for item in array {
        NSMutableArray.add(item)
    }
    return NSMutableArray
}
