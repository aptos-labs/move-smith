//# publish
module 0x1::UnitTest {
    /// Function returning a unit value
    public fun return_unit(): () {
        ()
    }

    /// Function that accepts and returns unit to test value passing
    public fun pass_unit(u: ()): () {
        u
    }

    /// Runner function to exercise unit related functions
    public fun run_unit(): () {
        let u = return_unit();
        let _ = pass_unit(u);
        ()
    }
}
//# run 0x1::UnitTest::run_unit

//# publish
module 0x1::BytecodeOptimizer {
    /// A struct to simulate optimization pipeline configuration
    struct Pipeline has copy, drop, store {
        optimize_stackless: bool,
        lambda_lifting: bool,
    }

    /// Simulates an optimization pass over a dummy expression representation
    public fun optimize_stackless_pass(flag: &mut bool) {
        // simulate stackless optimization by flipping flag (dummy effect)
        *flag = true;
    }

    /// Simulates the lambda lifting transformation
    public fun lambda_lifting_pass(flag: &mut bool) {
        // simulate lambda lifting by flipping flag (dummy effect)
        *flag = true;
    }

    /// Runs the configurable pipeline on dummy passes
    public fun run_pipeline(pipeline: &Pipeline): bool {
        let mut stackless_done = false;
        let mut lambda_done = false;

        if (pipeline.optimize_stackless) {
            optimize_stackless_pass(&mut stackless_done);
        };
        if (pipeline.lambda_lifting) {
            lambda_lifting_pass(&mut lambda_done);
        };
        stackless_done && lambda_done
    }

    /// Runner function exercising the pipeline with both passes enabled
    public fun run(): bool {
        // create pipeline with both optimizations enabled
        let pipeline = Pipeline {
            optimize_stackless: true,
            lambda_lifting: true,
        };
        run_pipeline(&pipeline)
    }
}
//# run 0x1::BytecodeOptimizer::run

//# publish
module 0x1::LambdaTest {
    /// Top-level function lifted from lambda
    public fun lifted_lambda(x: u64): u64 {
        x * 2
    }

    /// Function with a lambda expression, simulating lambda lifting 
    public fun with_lambda(x: u64): u64 {
        // lambda expression: |a| a * 2; simulated here by direct call
        let lambda_result = Self::lifted_lambda(x);
        lambda_result + 1
    }

    /// Runner function to validate lambda usage
    public fun run(): u64 {
        with_lambda(10)
    }
}
//# run 0x1::LambdaTest::run

//# run
script {
    use 0x1::UnitTest;
    use 0x1::BytecodeOptimizer;
    use 0x1::LambdaTest;

    fun main() {
        let _ = UnitTest::run_unit();
        let pipeline_result = BytecodeOptimizer::run();
        let lambda_val = LambdaTest::run();

        // ignore assertions as per instructions
    }
}