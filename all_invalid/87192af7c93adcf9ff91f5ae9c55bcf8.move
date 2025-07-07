//# publish
module 0xCAFE::ReservedKeywords {
    // Use all reserved keywords as identifiers for functions, variables, structs, constants, etc.
    
    struct abort has copy, drop, store { val: u8 }
    struct acquires has copy, drop, store { val: u8 }
    struct as has copy, drop, store { val: u8 }
    struct break has copy, drop, store { val: u8 }
    struct const has copy, drop, store { val: u8 }
    struct continue has copy, drop, store { val: u8 }
    struct copy has copy, drop, store { val: u8 }
    struct else has copy, drop, store { val: u8 }
    struct false has copy, drop, store { val: u8 }
    struct fun has copy, drop, store { val: u8 }
    struct friend has copy, drop, store { val: u8 }
    struct if has copy, drop, store { val: u8 }
    struct invariant has copy, drop, store { val: u8 }
    struct let has copy, drop, store { val: u8 }
    struct loop has copy, drop, store { val: u8 }
    struct inline has copy, drop, store { val: u8 }
    struct module has copy, drop, store { val: u8 }
    struct move has copy, drop, store { val: u8 }
    struct native has copy, drop, store { val: u8 }
    struct public has copy, drop, store { val: u8 }
    struct return has copy, drop, store { val: u8 }
    struct script has copy, drop, store { val: u8 }
    struct spec has copy, drop, store { val: u8 }
    struct struct_ has copy, drop, store { val: u8 }  // cannot use 'struct' as identifier, so appended _
    struct true has copy, drop, store { val: u8 }
    struct use has copy, drop, store { val: u8 }
    struct while has copy, drop, store { val: u8 }

    const const: u8 = 42;

    fun abort(): u8 {
        let abort: u8 = 1;
        abort
    }

    public fun acquires(): bool {
        let acquires = 2;
        acquires == 2
    }

    fun as(): u8 {
        3
    }

    public fun break(): u8 {
        4
    }

    public fun continue(): u8 {
        5
    }

    native fun native(): u8;

    public fun friend(): u8 {
        6
    }

    public fun if(): u8 {
        7
    }

    public fun invariant(): u8 {
        8
    }

    public fun let(): u8 {
        9
    }

    public fun inline(): u8 {
        10
    }

    public fun module(): u8 {
        11
    }

    public fun move(): u8 {
        12
    }

    public fun public(): u8 {
        13
    }

    public fun return(): u8 {
        14
    }

    public fun script(): u8 {
        15
    }

    public fun spec(): u8 {
        16
    }

    public fun struct(): u8 {
        17
    }

    public fun true(): bool {
        true
    }

    public fun use(): u8 {
        18
    }

    public fun while(): u8 {
        19
    }

    // Runner function to call multiple keyword functions and consume structs
    public fun runner(): u8 {
        let mut sum = 0;
        if Self::abort() == 1 {
            sum = sum + 1;
        };
        if Self::acquires() {
            sum = sum + 2;
        };
        sum = sum + Self::as();
        sum = sum + Self::break();
        sum = sum + Self::continue();
        sum = sum + Self::friend();
        sum = sum + Self::if();
        sum = sum + Self::invariant();
        sum = sum + Self::let();
        sum = sum + Self::inline();
        sum = sum + Self::module();
        sum = sum + Self::move();
        sum = sum + Self::public();
        sum = sum + Self::return();
        sum = sum + Self::script();
        sum = sum + Self::spec();
        sum = sum + Self::struct();
        sum = sum + Self::use();
        sum = sum + Self::while();

        if Self::true() {
            sum = sum + 1000;
        };

        sum
    }

}

//# run 0xCAFE::ReservedKeywords::runner


//# publish
module 0xCAFE::LocalCopyTest {
    // Test that reassigning a local copied variable does not affect original and comparison remains true
    
    public fun runner(): bool {
        let x = 10;
        let y = x;        // copy x
        let z = y;        // copy y
        let mut y = y;    // mutable y for reassignment
        y = 20;           // reassign y, original x unaffected

        // x is still 10
        // z is still 10 (copied before)
        // y is 20 (reassigned afterwards)

        x == z
    }
}

//# run 0xCAFE::LocalCopyTest::runner


///// Diagnostic test related to ambiguous operator without space

// No module needed; test a script that triggers diagnostic on '<' without space before

//# run

script {
    fun main() {
        let a = 3;
        let b = 5;
        // This line should trigger a diagnostic secondary label suggesting a blank space before '<'
        // because it's ambiguous: "a< b" (without space) instead of "a < b"
        let c = a< b;
    }
}

// Featurres:
// e518d62d47a1bb813b7828b3ff3f77ed: Add a diagnostic secondary label suggesting inserting a blank space before the '<' operator when ambiguity occurs.
// 85ad3571b0b466eac23df2fcc602a03b: Test that reassigning a local variable after copying it does not affect the original variable, and the comparison between the copied variables remains true.
// 7dcd99288efac8956318da471526087a: Use reserved keywords such as 'abort', 'acquires', 'as', 'break', 'const', 'continue', 'copy', 'else', 'false', 'fun', 'friend', 'if', 'invariant', 'let', 'loop', 'inline', 'module', 'move', 'native', 'public', 'return', 'script', 'spec', 'struct', 'true', 'use', 'while' as identifiers in Move code.
