import Testing
import Foundation

protocol FluentUnitTesting {
    // your Testing class must have a no-param init
    init()
}

extension FluentUnitTesting {
    // to improve readability
    var sut: Self {
        self
    }

    // to improve readability, and also means we can avoid
    // having to use "_ = " because of the @discardableResult
    @discardableResult
    func given(_ zelf: Self) -> Self {
        zelf
    }

    @discardableResult
    func not(_ assertion: @autoclosure () -> Self) -> Self {
        // doing this flip (rather than setting simply true then false) means
        // that nested nots behave correctly. Very marginal behaviour though!
        Thread.current.futInvertExpectation.toggle()
        _ = assertion()
        Thread.current.futInvertExpectation.toggle()
        return self
    }

    // call this instead of #expect if you want to use .not()
    func fexpect(_ ac: @autoclosure () -> Bool) {
        #expect(ac() != Thread.current.futInvertExpectation)
    }

    @discardableResult
    func times(_ times: Int, _ expr: @autoclosure () -> Self) -> Self {
        for _ in 0..<times {
            _ = expr()
        }
        return self
    }
}

private extension Thread {
    var futInvertKey: String { "FluentUnitTesting.invert" }

    var futInvertExpectation: Bool {
        get { (threadDictionary[futInvertKey] as? Bool) ?? false }
        set { threadDictionary[futInvertKey] = newValue }
    }
}
