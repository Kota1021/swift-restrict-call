import Foundation

protocol Styleable {
}

struct MyColor: Styleable {
    static var red: MyColor {
        MyColor()
    }
}

extension Styleable where Self == MyColor {
    static var red: MyColor {
        MyColor.red
    }
}

func testDirectAccess() {
    let color1 = MyColor.red
    print(color1)
}

func testProtocolAccess() {
    acceptStyleable(.red)
}

func acceptStyleable<T: Styleable>(_ style: T) {
    print(style)
}
