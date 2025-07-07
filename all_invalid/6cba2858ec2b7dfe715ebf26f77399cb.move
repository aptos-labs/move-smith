//# publish
address 0x1 {
    module ProgramParser {
        use std::vector;
        use std::string;
        use std::option;

        // A struct representing a program file with code and address mapping
        struct ProgramFile has copy, drop, store {
            code: vector<u8>,
            address: address,
        }

        // Parse target files with associated addresses and dependency files with addresses
        // For simplicity, returns the count of all files combined.
        public fun parse_programs(
            targets: vector<ProgramFile>, 
            dependencies: vector<ProgramFile>
        ): u64 {
            let target_len = vector::length<&ProgramFile>(&targets) as u64;
            let dep_len = vector::length<&ProgramFile>(&dependencies) as u64;
            target_len + dep_len
        }

        // Runner
        public fun do() {
            // no state, no signer, just a dummy function
        }
    }
}
//# run 0x1::ProgramParser::do

//# publish
address 0x2 {
    module ResourceModifier {
        use std::signer;

        #[skip(lint_unnecessary_cast, lint_unused_value)]
        struct R has key {
            v: u8,
        }

        // Initialize resource R under signer with v = 0
        public fun init(account: &signer) {
            move_to(account, R { v: 0 });
        }

        // Modify R based on the input v:
        // if v is even, increment by v, otherwise decrement by v
        public fun do(v: u8, account: &signer) {
            let r_ref = borrow_global_mut<R>(signer::address_of(account));
            if (v % 2 == 0) {
                r_ref.v = r_ref.v + v;
            } else {
                // Note: will underflow if v_ref.v < v but skipping asserts
                r_ref.v = r_ref.v - v;
            }
        }

        // Get the current value v from R for testing (no asserts)
        public fun get(account: &signer): u8 {
            let r_ref = borrow_global<R>(signer::address_of(account));
            r_ref.v
        }

        // Runner that creates the resource and applies modifications
        public fun run_runner(account: &signer) {
            init(account);
            do(4, account);  // even increment
            do(3, account);  // odd decrement
        }
    }
}
//# run 0x2::ResourceModifier::run_runner --signers 0x2

//# publish
address 0x3 {
    module AstSimplifier {
        use std::vector;

        /// Dummy expression enum
        enum Expr has copy, drop, store {
            Literal(u64),
            Add(Box<Expr>, Box<Expr>),
            Mul(Box<Expr>, Box<Expr>),
            // List expressions holding multiple expressions
            List(vector<Expr>),
        }

        // Create a list expression from multiple Exprs
        public fun create_list(exprs: vector<Expr>): Expr {
            Expr::List(exprs)
        }

        // Simplify expressions recursively:
        // - Multiplication or addition of literals are folded
        // - List expressions simplified recursively inside
        public fun simplify(e: Expr): Expr {
            match e {
                Expr::Add(box Expr::Literal(a), box Expr::Literal(b)) => Expr::Literal(a + b),
                Expr::Mul(box Expr::Literal(a), box Expr::Literal(b)) => Expr::Literal(a * b),
                Expr::Add(box left, box right) => Expr::Add(Box::new(simplify(left)), Box::new(simplify(right))),
                Expr::Mul(box left, box right) => Expr::Mul(Box::new(simplify(left)), Box::new(simplify(right))),
                Expr::List(lst) => {
                    let mut simplified = vector::empty<Expr>();
                    let len = vector::length(&lst);
                    let mut i = 0;
                    while (i < len) {
                        vector::push_back(&mut simplified, simplify(*vector::borrow(&lst, i)));
                        i = i + 1;
                    }
                    Expr::List(simplified)
                }
                _ => e,
            }
        }

        // Runner function creates a complex expression and simplifies it
        public fun run_runner() {
            let exprs = vector::empty<Expr>();
            vector::push_back(&mut exprs, Expr::Add(Box::new(Expr::Literal(3)), Box::new(Expr::Literal(4))));
            vector::push_back(&mut exprs, Expr::Mul(Box::new(Expr::Literal(2)), Box::new(Expr::Literal(5))));
            let list_expr = create_list(exprs);
            let _simplified = simplify(list_expr);
        }
    }
}
//# run 0x3::AstSimplifier::run_runner

//# run
script {
    use 0x1::ProgramParser;
    use 0x2::ResourceModifier;
    use 0x3::AstSimplifier;
    use std::signer;

    fun main(account: signer) {
        // Test ProgramParser parsing with dummy vectors
        let empty: vector<ProgramParser::ProgramFile> = vector::empty();
        let _parsed_len = ProgramParser::parse_programs(empty, empty);

        // Test ResourceModifier init, modification and get
        ResourceModifier::run_runner(&account);
        let _v = ResourceModifier::get(&account);

        // Test AstSimplifier runner
        AstSimplifier::run_runner();
    }
}