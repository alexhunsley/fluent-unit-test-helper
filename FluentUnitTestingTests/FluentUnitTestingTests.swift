import Testing
//@_spi(Experimental) import Testing
import Foundation

@testable import FluentUnitTesting

// need to use a reference type (class) for mutation reasons
final class FluentUnitTestingTests: FluentUnitTesting {
    var name: String
    var age: Int
    var loopReps = 100

    init() {
        print("Init!")
        self.name = "alex"
        self.age = 10
    }

    // NB parallelisation is across different tests in a suite, and suites
    @Test("Age setting and getting works", arguments: [0, 1, 10, 90])
    func test_agesBelow100(_ age: Int) async throws {
        for _ in 0..<loopReps {
            given(
                sut
                    .withAge(age)
                    .hasAge(age)
                    .not(hasAge(age + 1))
                    .withHappyBirthday
                    .hasAge(age + 1)
                    .times(2, withHappyBirthday)
                    .hasAge(age + 3)
                    .not(hasReachedCentenery)
                    .withAge(100)
                    .hasReachedCentenery
            )
        }
    }

    func test_agesBelow100B(_ age: Int) async throws {
        for _ in 0..<loopReps {
            given(
                sut
                    .withAge(age)
                    .hasAge(age)
                    .not(hasAge(age + 1))
                    .withHappyBirthday
                    .hasAge(age + 1)
                    .times(2, withHappyBirthday)
                    .hasAge(age + 3)
                    .not(hasReachedCentenery)
                    .withAge(100)
                    .hasReachedCentenery
            )
        }
    }

    func test_agesBelow100C(_ age: Int) async throws {
        for _ in 0..<loopReps {
            given(
                sut
                    .withAge(age)
                    .hasAge(age)
                    .not(hasAge(age + 1))
                    .withHappyBirthday
                    .hasAge(age + 1)
                    .times(2, withHappyBirthday)
                    .hasAge(age + 3)
                    .not(hasReachedCentenery)
                    .withAge(100)
                    .hasReachedCentenery
            )
        }
    }

    @Test("Incrementing age and centenery status", arguments: [97, 98])
    func test_ageReaching100(_ age: Int) async throws {
        given(
            sut
                .withAge(age)
                .hasAge(age)
                .not(hasReachedCentenery)
                .withHappyBirthday
                .not(hasReachedCentenery)
                .times(3, withHappyBirthday)
                .hasReachedCentenery
                .withHappyBirthday
                .hasReachedCentenery
        )
    }

    @Test func test_age1() async throws {
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

    func withName(_ name: String) {
        self.name = name
    }

    func withAge(_ age: Int) -> Self {
        self.age = age
        return self
    }

    var withHappyBirthday: Self {
        age += 1
        return self
    }

    var withAgeFifty: Self {
        age = 50
        return self
    }

    var hasReachedCentenery: Self {
        fexpect(self.age >= 100)
        return self
    }

    var isNamedBob: Self {
        fexpect(name == "bob")
        return self
    }

    func hasAge(_ expectAge: Int) -> Self {
        fexpect(age == expectAge)
        return self
    }
}

