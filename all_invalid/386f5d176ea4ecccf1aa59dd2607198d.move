
//# publish
module 0xCAFE::LiveVarAnalysisModule {
    // This module demonstrates a function for hypothetical live variable analysis
    // We simulate live variable analysis by tracking usage of variables in simple ways

    use std::vector;
    use std::string;

    struct VarInfo has store, drop, copy {
        name: vector<u8>,
        used: bool,
    }

    public fun live_var_analysis_example(): vector<VarInfo> {
        // This simulates live variable analysis result
        let v1 = VarInfo { name: b"x", used: true };
        let v2 = VarInfo { name: b"y", used: false };
        let v3 = VarInfo { name: b"z", used: true };
        vector::empty<VarInfo>();
        let vars = vector::empty<VarInfo>();
        let vars = vector::push_back(&vars, v1);
        let vars = vector::push_back(&vars, v2);
        let vars = vector::push_back(&vars, v3);
        vars
    }
}


//# publish
module 0xCAFE::ParsingFunctions {
    use std::vector;
    use std::string;

    // We define generic hooks for parser continuation and item parsing.
    // These are simulated by passing public functions.

    public fun parse_items<A, B>(
        items: vector<A>,
        continue_fun: &fun(&vector<B>, B): bool,
        item_fun: &fun(A): B
    ): vector<B> {
        let res = vector::empty<B>();
        let len = vector::length(&items);
        let i = 0;
        while (i < len) {
            let item = *vector::borrow(&items, i);
            let parsed_item = item_fun(item);
            let cont = continue_fun(&res, parsed_item);
            if (!cont) {
                break;
            };
            res = vector::push_back(&res, parsed_item);
            i = i + 1;
        };
        res
    }

    public fun parser_continue_always<B>(
        _res: &vector<B>,
        _last_parsed: B
    ): bool {
        true
    }

    public fun parser_continue_if_less_than_3<B: copy>(
        res: &vector<B>,
        _last_parsed: B
    ): bool {
        vector::length(res) < 3
    }

    public fun parser_map_add_one(x: u8): u8 {
        x + 1
    }
}


//# publish
module 0xCAFE::SeqItemsModule {
    use std::vector;

    // Define an enum for Seq expressions representing sequence items
    enum Seq<T> has copy, drop {
        Empty,
        Item(T),
        Concat(Box<Seq<T>>, Box<Seq<T>>),
    }

    public inline fun make_empty_seq<T>(): Seq<T> {
        Seq::Empty
    }

    public inline fun make_item_seq<T>(item: T): Seq<T> {
        Seq::Item(item)
    }

    public fun make_concat_seq<T>(left: Seq<T>, right: Seq<T>): Seq<T> {
        Seq::Concat(Box::new(left), Box::new(right))
    }

    // Example evaluation to vector of items for demonstration
    public fun seq_to_vector<T: copy>(s: &Seq<T>): vector<T> {
        match (s) {
            Seq::Empty => vector::empty<T>(),
            Seq::Item(item) => vector::singleton(*item),
            Seq::Concat(left_box, right_box) => {
                let left_vec = seq_to_vector(left_box);
                let right_vec = seq_to_vector(right_box);
                let len = vector::length(&right_vec);
                let i = 0;
                while (i < len) {
                    left_vec = vector::push_back(&left_vec, *vector::borrow(&right_vec, i));
                    i = i + 1;
                };
                left_vec
            }
        }
    }
}


//# run 0xCAFE::LiveVarAnalysisModule::live_var_analysis_example


//# run 0xCAFE::ParsingFunctions::parse_items --args vector[1u8,2u8,3u8,4u8]


//# run 0xCAFE::ParsingFunctions::parser_continue_always --args vector[] u8 1u8


//# run 0xCAFE::ParsingFunctions::parser_continue_if_less_than_3 --args vector[1u8,2u8] u8 2u8


//# run 0xCAFE::ParsingFunctions::parser_map_add_one --args 10u8


//# run 0xCAFE::SeqItemsModule::make_empty_seq


//# run 0xCAFE::SeqItemsModule::make_item_seq --args 42u8


//# run 0xCAFE::SeqItemsModule::make_concat_seq --args 0xCAFE::SeqItemsModule::make_item_seq 1u8 0xCAFE::SeqItemsModule::make_item_seq 2u8


//# run 0xCAFE::SeqItemsModule::seq_to_vector --args 0xCAFE::SeqItemsModule::make_concat_seq 0xCAFE::SeqItemsModule::make_item_seq 1u8 0xCAFE::SeqItemsModule::make_item_seq 2u8


//# run 0xCAFE::ParsingFunctions::parse_items --args vector[10u8, 20u8, 30u8]
// Extra parsing with sequence items to test combined scenario


//# publish
module 0xCAFE::CombinedFeatureTest {
    use std::vector;
    use 0xCAFE::SeqItemsModule;
    use 0xCAFE::ParsingFunctions;
    use 0xCAFE::LiveVarAnalysisModule;

    public fun runner() {
        // Create sequence items using Seq expressions
        let s1 = SeqItemsModule::make_item_seq(100u8);
        let s2 = SeqItemsModule::make_item_seq(200u8);
        let s = SeqItemsModule::make_concat_seq(s1, s2);

        // Convert Seq to vector for parsing
        let items = SeqItemsModule::seq_to_vector(&s);

        // Parse items using parse_items with parser_continue_if_less_than_3 and parser_map_add_one
        let parsed = ParsingFunctions::parse_items<u8, u8>(
            items,
            &ParsingFunctions::parser_continue_if_less_than_3<u8>,
            &ParsingFunctions::parser_map_add_one
        );

        // Use live_var_analysis_example (no args)
        let _live_vars = LiveVarAnalysisModule::live_var_analysis_example();

        // Just to avoid unused variable warnings
        let _ = vector::length(&parsed);
        let _ = vector::length(&_live_vars);
    }
}


//# run 0xCAFE::CombinedFeatureTest::runner


// Featurres:
// cec73c9384cb63d81368e9c1ec7f0ce0: Use LiveVarAnalysis to identify live variables at different points in the code.
// bf49700cf955331be956ada40e195684: Create functions that parse lists of items with customizable continuation and item parsing logic.
// 884d6f3be845aa12df3f53c251cc91b8: Define sequence items with expressions using `Seq`.
