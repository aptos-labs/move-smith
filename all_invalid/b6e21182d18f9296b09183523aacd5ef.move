//# publish
module 0x1::Dependency {
    use std::signer;

    #[skip(lint1, lint2)]
    struct R has key {
        value: u64,
    }

    public fun create_r(value: u64): R {
        R { value }
    }

    public fun get_value(r: &R): u64 {
        r.value
    }

    public fun set_value(r: &mut R, val: u64) {
        r.value = val;
    }

    /// runner function that does nothing - for testing compilation
    public fun runner() {}
}

//# publish
module 0x1::Target {
    use std::signer;
    use 0x1::Dependency;

    /// A unit type definition (no fields)
    struct UnitType { }

    /// Resource that holds R
    struct Container has key {
        r: Dependency::R,
    }

    /// Specification function that returns max of two u64
    spec fun max(a: u64, b: u64): u64 {
        if a > b { a } else { b }
    }

    native spec fun native_spec_fun(): bool;

    /// A function that returns the operator precedence of a binary operator
    public fun get_precedence(op: vector<u8>): u8 {
        if (op == b"+") {
            1
        } else if (op == b"*") {
            2
        } else if (op == b"-") {
            1
        } else if (op == b"/") {
            2
        } else if (op == b"^") {
            3
        } else {
            0
        }
    }

    /// The do function modifies or interacts with R based on value of v
    public fun do(container: &mut Container, v: u64) {
        if (v % 2 == 0) {
            let current = Dependency::get_value(&container.r);
            Dependency::set_value(&mut container.r, current + v);
        } else {
            let current = Dependency::get_value(&container.r);
            Dependency::set_value(&mut container.r, current * v);
        }
    }

    /// A no-argument runner function
    public fun runner() {
        let r = Dependency::create_r(10);
        let mut container = Container { r };
        do(&mut container, 2);
        do(&mut container, 3);
        let _prec_plus = get_precedence(b"+");
        let _prec_star = get_precedence(b"*");
    }
}
//# run 0x1::Target::runner

//# run
script {
    use 0x1::Dependency;
    use 0x1::Target;
    fun main(account: signer) {
        let r = Dependency::create_r(5);
        let mut container = Target::Container { r };

        // test even v
        Target::do(&mut container, 4);
        // test odd v
        Target::do(&mut container, 3);

        // check precedence of operators, just call them
        let plus = Target::get_precedence(b"+");
        let minus = Target::get_precedence(b"-");
        let star = Target::get_precedence(b"*");
        let div = Target::get_precedence(b"/");
        let caret = Target::get_precedence(b"^");

        // call spec function (ignored at runtime, but still compiles)
        let _ = Target::max(10, 20);

        // ignore assertions as per instruction
    }
}