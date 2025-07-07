address 0x1 {
    module Math {
        /// Calculates difference between (sum of first n integers)^2 and sum of squares of first n integers.
        public fun difference(n: u64): u64 {
            let mut sum = 0;
            let mut sum_squares = 0;
            let mut i = 1;
            while (i <= n) {
                sum = sum + i;
                sum_squares = sum_squares + (i * i);
                i = i + 1;
            };
            let square_of_sum = sum * sum;
            square_of_sum - sum_squares
        }
    }
}

address 0x1 {
    module HigherOrder {
        use 0x1::Math;

        /// Invokes two closures with different parameter types and usages.
        /// Returns tuple of their results.
        public fun invoke_closures<T1: copy + drop + store, T2: copy + drop + store>(
            f1: &mut (fun(u64): u64),
            f2: &mut (fun(T1, &T2): u64),
            x: u64,
            y1: T1,
            y2: &T2
        ): (u64, u64) {
            let r1 = *f1(x);
            let r2 = *f2(y1, y2);
            (r1, r2)
        }

        /// Demonstrates qualified access with 4 segments and usage of closures to compute the difference.
        public fun test_difference_with_closures(n: u64): u64 {
            // Closure 1: Just calls Math::difference with the integer
            let mut closure1 = fun (a: u64): u64 {
                0x1::Math::difference(a)
            };

            // Closure 2: Uses a tuple (u64, &u64), sums first element and dereferenced second, then calls difference.
            let mut closure2 = fun ((x, y): (u64, &u64)): u64 {
                let v = x + *y;
                0x1::Math::difference(v)
            };

            // Use invoke_closures to run the closures and get both results
            let (res1, res2) = Self::invoke_closures(&mut closure1, &mut closure2, n, n / 2, & (n / 2));
            // Just return difference between these two results (arbitrary to test combined usage)
            if res1 > res2 { res1 - res2 } else { res2 - res1 }
        }
    }
}

address 0x1 {
    module Test {
        use 0x1::Math;
        use 0x1::HigherOrder;

        #[test]
        public fun test_difference_calculations() {
            // Check difference for n=10:
            let diff_10 = Math::difference(10);
            // Known answer: (1+...+10)^2 - (1^2 + ... + 10^2)
            // = 55^2 - 385 = 3025 - 385 = 2640
            assert!(diff_10 == 2640, 1);

            // Check difference for n=100:
            // (1+...+100)^2 - (1^2 + ... + 100^2)
            // sum = 5050, sum^2 = 25502500
            // sum_of_squares = 338350
            // diff = 25502500 - 338350 = 25164150
            let diff_100 = Math::difference(100);
            assert!(diff_100 == 25164150, 2);
        }

        #[test]
        public fun test_closures_and_qualified_access() {
            // Test HigherOrder::test_difference_with_closures for n=10 and n=100

            let output_10 = HigherOrder::test_difference_with_closures(10);
            // For n=10:
            // closure1 returns Math::difference(10) = 2640
            // closure2 returns Math::difference(10/2 + 10/2) = Math::difference(5 + 5) = Math::difference(10) = 2640
            // So difference is 0
            assert!(output_10 == 0, 11);

            let output_100 = HigherOrder::test_difference_with_closures(100);
            // closure1: Math::difference(100) = 25164150
            // closure2: Math::difference(50 + 50) = Math::difference(100) = 25164150
            assert!(output_100 == 0, 12);
        }
    }
}

// Featurres:
// 175dc40719f78a0cc52202221abab584: Test passing and invoking multiple closures as arguments with different parameter usages in a function.
// ac3b56b7db3a2457d57e8ea4553f43b9: Use qualified module access chains with up to four segments in Move code.
// aaed2d449943518d0cfabe6136d81025: Test that the function correctly calculates the difference between the square of the sum and the sum of squares for a given n, specifically verifying it for n=10 and n=100.
