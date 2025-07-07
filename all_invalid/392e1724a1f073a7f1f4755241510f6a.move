// This is a Move transactional test file covering:
// 1. Detecting target file/dependency file path conflicts
// 2. Block expressions with `{ ... }`
// 3. Nested test attributes organization
// 4. Nested module/resource/function path application using `::` in scripts

//----------------------- 1. Target and Dependency Path Conflict -------------------

// These two modules share the same name and will trigger a compiler error if put into the same file system path.

//# publish
module 0xC0FFEE::SharedPath {
    public fun value(): u8 { 100 }
}

//# publish
module 0xD00D::SharedPath { // name conflict with 0xC0FFEE::SharedPath
    public fun value(): u8 { 200 }
}
// This will make the Move compiler detect/conflict when these modules are in the same file system path.

//------------------------ 2. Block Expressions --------------------

//# publish
module 0xBEEF::Blocks {
    public fun block_example(): u64 {
        let a = 5u64;
        let b = {
            let tmp = 10u64;
            tmp + a
        };
        b * 2u64
    }
    public fun runner() {
        let x = Self::block_example();
        // value should be 30 (5 + 10 = 15; 15 * 2)
    }
}
//# run 0xBEEF::Blocks::runner --signers 0xBEEF

//--------------------- 3. Nested Test Attributes ------------------

//# publish
module 0xABC::TestingAttrs {
    #[test]
    public fun main_test() {
        // main test block
        let a = 1u8 + 2u8;
        #[test(attributes = [nested])]
        {
            // nested test block
            let b = a + 3u8;
            ignore(b); // we don't use assertions as per instructions
        }
    }
    public fun runner() {
        Self::main_test();
    }
}
//# run 0xABC::TestingAttrs::runner --signers 0xABC

//--------------------- 4. Nested Module Paths Using :: Syntax --------------------

//# publish
module 0xF00D::Outer {
    public struct Inner has key, store {
        value: u64,
    }
    public fun make_inner(): Self::Inner {
        Self::Inner { value: 42 }
    }
    public fun get_inner_value(): u64 {
        let inner = Self::make_inner();
        inner.value
    }
}
//# run 0xF00D::Outer::get_inner_value --signers 0xF00D

//# run
script {
    fun main() {
        let mod_ref = 0xF00D::Outer;
        let inner = mod_ref::Inner { value: 77 };
        let value = inner.value;
        // Using :: with struct, nested module path, and field access
        ignore(value);
    }
}