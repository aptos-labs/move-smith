//# publish
address 0xCAFE {
    module ModuleA {
        use std::vector;

        // A struct to use for packing multiple values
        struct S has copy, drop, store, key {
            a: u8,
            b: u16,
            c: bool,
        }

        // Function that returns a packed struct S from multiple arguments
        public fun pack_s(a: u8, b: u16, c: bool): S {
            S { a, b, c }
        }

        // A higher order function that takes a function f and a vector of u8
        // It applies f to each element in vector and collects results into a new vector
        public fun map_vec(input: vector<u8>, f: &inline fun (u8): bool): vector<bool> {
            let mut out = vector::empty<bool>();
            let len = vector::length(&input);
            let mut i = 0;
            while (i < len) {
                vector::push_back(&mut out, f(vector::borrow(&input, i)));
                i = i + 1;
            }
            out
        }

        // Overload of map_vec for u8 output (needed because make_incrementer returns inline fun (u8): u8)
        public fun map_vec_u8(input: vector<u8>, f: &inline fun (u8): u8): vector<u8> {
            let mut out = vector::empty<u8>();
            let len = vector::length(&input);
            let mut i = 0;
            while (i < len) {
                vector::push_back(&mut out, f(vector::borrow(&input, i)));
                i = i + 1;
            }
            out
        }

        // A higher order function that returns another inline lambda,
        // which itself takes a u8 and returns u8 doubled + an increment
        public inline fun make_incrementer(inc: u8): inline fun (u8): u8 {
            inline fun (x: u8): u8 {
                x * 2 + inc
            }
        }

        // A struct with nested structs to test dotted expressions
        struct Outer has copy, drop, store, key {
            inner: Inner,
            flag: bool,
        }

        struct Inner has copy, drop, store {
            code: u64,
            sub: SubInner,
        }

        struct SubInner has copy, drop, store {
            value: u8,
        }

        // Function to create Outer struct for test
        public fun make_outer(): Outer {
            Outer {
                inner: Inner {
                    code: 0xABCD,
                    sub: SubInner { value: 42 },
                },
                flag: true,
            }
        }

        // Runner function that exercises all features
        public fun runner(): bool {
            // Test pack_s
            let s = pack_s(10u8, 500u16, true);

            // Test map_vec with inline lambda that checks evenness
            let input = vector::from_elem<u8>(8u8, 5); // [8,8,8,8,8]
            let evens = map_vec(input, &inline fun (x: u8): bool { x % 2 == 0 });

            // Call make_incrementer to get a function, then map over vector with that function
            let inc_fn = make_incrementer(3u8);
            let nums = vector::from_elem<u8>(5u8, 3); // [3,3,3,3,3]
            let inc_results = map_vec_u8(nums, &inc_fn);

            // Test navigating dotted expression
            let o = make_outer();
            // Access nested fields
            let nested_value = o.inner.sub.value;

            // Just return the nested_value == 42 to indicate success
            nested_value == 42
        }
    }
}
//# run 0xCAFE::ModuleA::runner

//# run
script {
    use 0xCAFE::ModuleA;

    fun main() {
        let success = ModuleA::runner();
        // No assertions needed, just run the flow
    }
}