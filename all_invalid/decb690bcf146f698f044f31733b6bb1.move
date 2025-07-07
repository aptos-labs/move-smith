// # publish
address 0xCAFE {
    module VectorModule {
        // A struct wrapping a vector for testing parametric types
        struct MyVector<T> has store, drop {
            inner: vector<T>,
        }

        // Create a new MyVector from an input vector
        public fun new<T>(v: vector<T>): MyVector<T> {
            MyVector { inner: v }
        }

        // Return length of inner vector
        public fun length<T>(v: &MyVector<T>): u64 {
            Vector::length(&v.inner)
        }

        // Get element at index (unsafe for simplicity)
        public fun borrow_element<T>(v: &MyVector<T>, idx: u64): &T {
            Vector::borrow(&v.inner, idx)
        }

        // Runner to exercise the above
        public fun runner() {
            let v = vector[1u8, 2u8, 3u8];
            let mv = Self::new(v);
            let len = Self::length(&mv);
            assert!(len == 3, 1);
            let el = Self::borrow_element(&mv, 1);
            assert!(*el == 2u8, 2);

            let v2 = vector[100u64, 200u64, 300u64];
            let mv2 = Self::new(v2);
            let len2 = Self::length(&mv2);
            assert!(len2 == 3, 3);
            let el2 = Self::borrow_element(&mv2, 2);
            assert!(*el2 == 300u64, 4);

            // Nested vector to test generic vectors
            let vec_vec = vector[vector[5u8,6u8], vector[7u8,8u8]];
            let mvv = Self::new(vec_vec);
            let lenv = Self::length(&mvv);
            assert!(lenv == 2, 5);
            let first_vec = Self::borrow_element(&mvv, 0);
            assert!(Vector::length(first_vec) == 2, 6);
        }
    }
}
// # run 0xCAFE::VectorModule::runner --signers 0xCAFE


// # publish
address 0xCAFE {
    module CompileVerifyModule {
        use 0x1::Vector;

        // A simple struct with copy, drop for easy use
        struct Point has copy, drop, store, key {
            x: u64,
            y: u64,
        }

        // Return a tuple to check destructuring and returning tuples
        public fun make_point_pair(): (Point, Point) {
            let p1 = Point {x: 10, y: 20};
            let p2 = Point {x: 30, y: 40};
            (p1, p2)
        }

        // A function that takes vectors as input and returns sum of all coordinates in points
        public fun sum_points(points: vector<Point>): u64 {
            let mut sum = 0;
            let len = Vector::length(&points);
            let mut i = 0;
            while (i < len) {
                let p = *Vector::borrow(&points, i);
                sum = sum + p.x + p.y;
                i = i + 1;
            };
            sum
        }

        // Runner that verifies the above
        public fun runner() {
            let (a, b) = Self::make_point_pair();
            assert!(a.x == 10, 10);
            assert!(b.y == 40, 11);

            let vec_points = vector[
                Point { x: 1, y: 2 },
                Point { x: 3, y: 4 },
                Point { x: 5, y: 6 },
            ];
            let total = Self::sum_points(vec_points);
            assert!(total == (1+2 + 3+4 + 5+6), 12);
        }
    }
}
// # run 0xCAFE::CompileVerifyModule::runner --signers 0xCAFE


// # run
script {
    use 0xCAFE::VectorModule;
    use 0xCAFE::CompileVerifyModule;

    fun main(sender: signer) {
        // Run VectorModule::runner() to test generic vectors + parametric structs
        VectorModule::runner();

        // Run CompileVerifyModule::runner() to test tuple returns, vectors of structs and loops
        CompileVerifyModule::runner();

        // Additional inline vector creation and manipulations here to test compiler / VM

        // Create vector of u8 and sum it
        let v = vector[10u8, 20u8, 30u8];
        let mut sum: u64 = 0;
        let len = Vector::length(&v);
        let mut i = 0;
        while (i < len) {
            let x: u8 = *Vector::borrow(&v, i);
            sum = sum + (x as u64);
            i = i + 1;
        };

        // sum should be 60
        assert!(sum == 60, 100);

        // Create vector of nested vectors of bools
        let bool_vec1 = vector[true, false, true];
        let bool_vec2 = vector[false, false];
        let nested = vector[bool_vec1, bool_vec2];

        let len2 = Vector::length(&nested);
        assert!(len2 == 2, 101);
    }
}

// Featurres:
// 71f6838867cd49cfda14b3b0fd4c527d: Verify an individual compiled unit for correctness.
// a9b8bb739e5fad9cf3e17a8f4d9c27e1: Create vectors with element type parameters and argument lists.
// 336076452978ed665784ddcf662dcede: Write tests for Move modules that are primary targets of compilation
