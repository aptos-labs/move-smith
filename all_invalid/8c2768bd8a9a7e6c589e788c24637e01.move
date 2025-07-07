
//# run 0xCAFE::ListFormatter::format_u8_list --args vector u8 []



//# run 0xCAFE::ListFormatter::format_u8_list --args vector u8 [42]



//# run 0xCAFE::ListFormatter::format_u8_list --args vector u8 [1,2,3,4,5]



//# run 0xCAFE::ListFormatter::format_nested_u8_list --args vector vector u8 [[], [3], [255,0,10]]




//# publish
module 0xCAFE::CycleA {
    use 0xCAFE::CycleB;

    public fun call_b(): u8 {
        CycleB::foo()
    }
}



//# publish
module 0xCAFE::CycleB {
    use 0xCAFE::CycleA;

    public fun foo(): u8 {
        42
    }
}



//# run 0xCAFE::CycleA::call_b

// Note: The above cyclic use is invalid and the Move compiler must reject it in reality,
// but for testing error message correctness, we keep this structure.



//# publish
module 0xCAFE::FriendA {
    friend 0xCAFE::FriendB;

    struct SA has store {
        value: u64,
    }

    public fun create_sa(v: u64): SA {
        SA { value: v }
    }

    public fun get_value(sa: &SA): u64 {
        sa.value
    }

    public fun update_value(sa: &mut SA, v: u64) {
        sa.value = v;
    }
}



//# publish
module 0xCAFE::FriendB {
    use 0xCAFE::FriendA;

    friend 0xCAFE::FriendA;

    public fun update_sa(sa: &mut FriendA::SA, v: u64) {
        FriendA::update_value(sa, v);
    }

    public fun read_sa(sa: &FriendA::SA): u64 {
        FriendA::get_value(sa)
    }
}



//# run 0xCAFE::FriendA::create_sa --args 100u64



//# run 0xCAFE::FriendB::read_sa --args 0xCAFE::FriendA::SA



//# publish
module 0xCAFE::UnpackTest {
    struct Simple has store {
        a: u8,
        b: u16,
    }

    public fun match_simple(s: Simple): u64 {
        match s {
            Simple {a, b} => ((a as u64) << 16) + (b as u64)
        }
    }

    struct Nested has store {
        inner: Simple,
        flag: bool
    }

    public fun match_nested(n: Nested): u64 {
        match n {
            Nested {inner, flag} => {
                let Simple {a, b} = inner;
                let base = ((a as u64) << 16) + (b as u64);
                if (flag) {
                    base + 1
                } else {
                    base
                }
            }
        }
    }

    struct Generic<T> has store {
        field: T
    }

    public fun unpack_generic_u8(g: Generic<u8>): u8 {
        match g {
            Generic {field} => field
        }
    }
}



//# run 0xCAFE::UnpackTest::match_simple --args 0xCAFE::UnpackTest::Simple {a: 3u8, b: 258u16}



//# run 0xCAFE::UnpackTest::match_nested --args 0xCAFE::UnpackTest::Nested {inner: 0xCAFE::UnpackTest::Simple {a: 5u8, b: 1u16}, flag: true}



//# run 0xCAFE::UnpackTest::unpack_generic_u8 --args 0xCAFE::UnpackTest::Generic<u8> {field: 99u8}




//# publish
module 0xCAFE::FormatUnpack {

    use std::vector;
    use 0xCAFE::UnpackTest;

    // Format vector<UnpackTest::Simple> to string of comma separated "a:b"
    public fun format_simple_list(list: vector<UnpackTest::Simple>): vector<u8> {
        let len = vector::length(&list);
        if (len == 0) {
            return vector::empty<u8>();
        };
        let result = vector::empty<u8>();
        let i = 0;
        while (i < len) {
            let s = *vector::borrow(&list, i);
            let UnpackTest::Simple {a, b} = s;
            let a_s = u8_to_string(a);
            let b_s = u16_to_string(b);
            vector::append(&mut result, a_s);
            vector::push_back(&mut result, b':' as u8);
            vector::append(&mut result, b_s);
            if (i != len - 1) {
                vector::push_back(&mut result, b',' as u8);
                vector::push_back(&mut result, b' ' as u8);
            };
            i = i + 1;
        };
        result
    }

    fun u8_to_string(value: u8): vector<u8> {
        if (value == 0) {
            return vector::singleton(b'0');
        };
        let val = value;
        let digits = vector::empty<u8>();
        while (val > 0) {
            let d = val % 10;
            vector::push_back(&mut digits, (b'0' + d) as u8);
            val = val / 10;
        };
        let len = vector::length(&digits);
        let result = vector::empty<u8>();
        let i = 0;
        while (i < len) {
            vector::push_back(&mut result, *vector::borrow(&digits, len - 1 - i));
            i = i + 1;
        };
        result
    }

    fun u16_to_string(value: u16): vector<u8> {
        if (value == 0) {
            return vector::singleton(b'0');
        };
        let val = value;
        let digits = vector::empty<u8>();
        while (val > 0) {
            let d = (val % 10) as u8;
            vector::push_back(&mut digits, (b'0' + d) as u8);
            val = val / 10;
        };
        let len = vector::length(&digits);
        let result = vector::empty<u8>();
        let i = 0;
        while (i < len) {
            vector::push_back(&mut result, *vector::borrow(&digits, len - 1 - i));
            i = i + 1;
        };
        result
    }
}



//# run 0xCAFE::FormatUnpack::format_simple_list --args vector 0xCAFE::UnpackTest::Simple []



//# run 0xCAFE::FormatUnpack::format_simple_list --args vector 0xCAFE::UnpackTest::Simple [0xCAFE::UnpackTest::Simple {a: 8u8, b: 10u16}]



//# run 0xCAFE::FormatUnpack::format_simple_list --args vector 0xCAFE::UnpackTest::Simple [0xCAFE::UnpackTest::Simple {a: 1u8, b: 2u16}, 0xCAFE::UnpackTest::Simple {a: 3u8, b: 4u16}]




//# publish
module 0xCAFE::DepModA {
    use 0xCAFE::ListFormatter;
    use 0xCAFE::UnpackTest;

    // Compose formatted string by formatting vector of Simple structs by unpack and ListFormatter
    public fun format_dep(list: vector<UnpackTest::Simple>): vector<u8> {
        ListFormatter::format_u8_list(
            vector::map(
                &list,
                fun (s: UnpackTest::Simple): u8 {
                    let UnpackTest::Simple {a, _b} = s;
                    a
                }
            )
        )
    }
}



//# run 0xCAFE::DepModA::format_dep --args vector 0xCAFE::UnpackTest::Simple [0xCAFE::UnpackTest::Simple {a: 7u8, b: 8u16}, 0xCAFE::UnpackTest::Simple {a: 9u8, b: 10u16}]




//# publish
module 0xCAFE::DepModB {
    use 0xCAFE::DepModA;
    use 0xCAFE::ListFormatter;

    public fun run() {
        // Compose nested u8 lists and format them
        let l1 = vector[1u8, 2u8];
        let l2 = vector[3u8, 4u8];
        let nested = vector[l1, l2];
        let _ = ListFormatter::format_nested_u8_list(nested);

        let simple_list = vector[
            0xCAFE::UnpackTest::Simple {a: 5u8, b: 6u16},
            0xCAFE::UnpackTest::Simple {a: 7u8, b: 8u16}
        ];
        let _ = DepModA::format_dep(simple_list);
    }
}



//# run 0xCAFE::DepModB::run
