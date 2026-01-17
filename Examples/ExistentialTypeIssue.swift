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
    let color2: any Styleable = .red
    print(color2)
}

func acceptStyleable(_ style: any Styleable) {
    print(style)
}

func testImplicitAccess() {
    acceptStyleable(.red)
}
