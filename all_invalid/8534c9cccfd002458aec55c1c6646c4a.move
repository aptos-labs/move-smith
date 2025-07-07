//# publish
module 0x1::MathConstants {
    const TEN: u64 = 10;
    const HUNDRED: u64 = 100;
}

//# publish
module 0x1::SquareDifference {
    /// Returns the square of the sum of the first n natural numbers.
    public fun square_of_sum(n: u64): u64 {
        let sum = n * (n + 1) / 2;
        sum * sum
    }

    /// Returns the sum of the squares of the first n natural numbers.
    public fun sum_of_squares(n: u64): u64 {
        (n * (n + 1) * (2 * n + 1)) / 6
    }

    /// Returns the difference between the square of the sum and the sum of squares.
    public fun difference(n: u64): u64 {
        let sq_sum = square_of_sum(n);
        let sum_sq = sum_of_squares(n);
        sq_sum - sum_sq
    }

    /// Runner function that calculates the difference for n=10 and n=100.
    /// No arguments needed.
    public fun run() {
        let diff_10 = difference(0xA); // 10u64
        let diff_100 = difference(0x64); // 100u64
        // no asserts needed per instructions
        // Just exercise functions and types
        diff_10;
        diff_100;
    }
}
//# run 0x1::SquareDifference::run

//# run
script {
    use 0x1::SquareDifference;
    use 0x1::MathConstants;

    fun main() {
        let n10 = MathConstants::TEN;
        let n100 = MathConstants::HUNDRED;
        let diff_10 = SquareDifference::difference(n10);
        let diff_100 = SquareDifference::difference(n100);
        // do nothing with results, just run to exercise VM and compiler
        diff_10;
        diff_100;
    }
}