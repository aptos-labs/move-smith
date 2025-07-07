//# publish
module 0x1::RefTest {
    struct MyStruct { x: u64, y: u64 }

    public fun create_struct(): MyStruct {
        MyStruct { x: 10, y: 20 }
    }

    public fun mutate_struct(s: &mut MyStruct) {
        s.x = s.x + 1;
        s.y = s.y + 1;
    }

    public fun read_struct(s: &MyStruct): u64 {
        s.x + s.y
    }

    public fun runner() {
        let mut s = create_struct();
        mutate_struct(&mut s);
        let _ = read_struct(&s);
    }
}
//# run 0x1::RefTest::runner

//# publish
module 0x1::VariantTest {
    use std::option::Option;

    struct StructVariant {
        a: u64,
        b: Option<u64>
    }

    public fun create_variant(): StructVariant {
        StructVariant { a: 100, b: Option::some(50) }
    }

    public fun read_variant(v: &StructVariant): u64 {
        let b = match &v.b {
            Option::some(value) => *value,
            Option::none => 0,
        };
        v.a + b
    }

    public fun runner() {
        let v = create_variant();
        let _sum = read_variant(&v);
    }
}
//# run 0x1::VariantTest::runner

// Test import of unbound module and member, check warnings (ignored by testing)
import 0x1::NonExistentModule;
import 0x1::VariantTest::nonexistent_function;

//# run
script {
    use 0x1::RefTest;
    use 0x1::VariantTest;

    fun main() {
        let mut s = RefTest::create_struct();
        RefTest::mutate_struct(&mut s);
        let _ = RefTest::read_struct(&s);

        let v = VariantTest::create_variant();
        let _ = VariantTest::read_variant(&v);
    }
}