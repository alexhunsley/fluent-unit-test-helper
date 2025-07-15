import Testing
@testable import FluentUnitTesting

struct Account {
    var age: Int
}

class AccountClass {
    var age: Int

    init(age: Int) {
        self.age = age
    }
}

final class FluentUnitTestingTests: FluentUnitTesting {
    // can't mutate this value directly, but can mutate what
    // things are referencing.

    // hmm, make a sut class? then can change.
    //    class SUT {
    var name: String
    var account: Account
    var accountClass: AccountClass
    var age: Int

    init() {
        print("Init!")
        self.name = "alex"
        self.account = Account(age: 23)
        self.accountClass = AccountClass(age: 23)
        self.age = 10
    }
    //    }

    @Test("Age setting and getting works", arguments: [0, 1, 10, 90])
    func test_age0(_ age: Int) async throws {
        // testing age2 test hasn't left an effect
        given(
            sut
                .hasAge(10)
                .withAge(age)
                .hasAge(age)
                .withReachedBirthday
                .hasAge(age + 1)
                .withReachedBirthday
                .withReachedBirthday
                .hasAge(age + 3)
                .not({ $0.hasReachedCentenery })
        )
    }

    @Test func test_age1() async throws {
        // testing age2 test hasn't left an effect
        given(sut
            .hasAge(10)
        )
    }

    @Test func test_age2() async throws {
        given(
            sut
                .hasAge(10)
                .withAgeFifty
                .hasAge(50)
                .withAge(2)
                .hasAge(2)
        )
    }

    @Test func test_age3() async throws {
        // testing age2 test hasn't left an effect
        given(sut
            .hasAge(10)
        )
    }
}

extension FluentUnitTestingTests {
    var withNameBob: Self {
        self.name = "bob"
        return self
    }

//    func sut(goober: @autoclosure )

    // so we can mutate direct value via a func, but not a computed property
    func withName(_ name: String) {
//        self.name = name
        self.name = name
    }

    func withAge(_ age: Int) -> Self {
        self.age = age
        return self
    }

    var withReachedBirthday: Self {
        age += 1
        return self
    }

    var withAgeFifty: Self {
        // NOTE: not allowed to change a value, but can tweak contents of a reference type
//        self.account.age = 50
//        self.accountClass.age = 50
        age = 50
        return self
    }

    var hasReachedCentenery: Self {
        #expect(self.age >= 100)
        return self
    }

//    var sut: Self {
//        .init()
//    }


//    var given: Self {
//        self
//    }

    var isNamedBob: Self {
        #expect(name == "bob")
        return self
    }

    func hasAge(_ expectAge: Int) -> Self {
        #expect(age == expectAge)
        return self
    }

}

protocol FluentUnitTesting {
    init()
}

extension FluentUnitTesting {
    // don't make a new one. do test side effects pile up? - no, good.
    var sut: Self {
        self
    }

    // use autoclosure?
    @discardableResult
    func given(_ zelf: Self) -> Self {
        zelf
    }

    //    func not(_ kp: KeyPath<Self, Bool>) -> Self {
    //    func not(_ kp: KeyPath<Self, Bool>) -> Self {
    //        withKnownIssue("this is to flip the expectation") {
    //            _ = self[keyPath: kp]
    //        }
    //        return self
    //    }

    @discardableResult
//    func not(_ assertion: @autoclosure () -> Self) -> Self {
    func not(_ assertion: (Self) -> Self) -> Self {
      withKnownIssue("flipped expectation") {
          // the assertion bit itself contains any #expect
          _ = assertion(self)
//        #expect(assertion())
      }
      return self
    }
}
