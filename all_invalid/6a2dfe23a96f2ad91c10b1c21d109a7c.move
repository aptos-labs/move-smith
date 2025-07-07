// # publish
module 0xCAFE::RecursiveChecker {
    use std::vector;
    use std::string;
    use std::signer;

    /// A simple representation of a module item that may recursively reference other modules (by address and name)
    struct ModuleRef has copy, drop, store {
        address: address,
        name: vector<u8>,
        dependencies: vector<ModuleRef>,
    }

    /// Recursively checks if the module reference graph contains any cycles.
    /// Returns true if no cycles, false if cycles detected.
    fun check_no_recursion_internal(
        module: &ModuleRef,
        path: &vector<ModuleRef>
    ): bool {
        // Check if module is already in path (cycle)
        let len = vector::length(path);
        let mut i = 0;
        while (i < len) {
            let m = vector::borrow(path, i);
            if (m.address == module.address && vector::length(&m.name) == vector::length(&module.name)) {
                let mut j = 0;
                while (j < vector::length(&m.name)) {
                    if (*vector::borrow(&m.name, j) != *vector::borrow(&module.name, j)) {
                        break;
                    }
                    j = j + 1;
                }
                if (j == vector::length(&m.name)) {
                    // Cycle found
                    return false;
                }
            }
            i = i + 1;
        }
        // Add current module to path
        let mut new_path = vector::empty<ModuleRef>();
        let len_path = vector::length(path);
        let mut k = 0;
        while (k < len_path) {
            vector::push_back(&mut new_path, *vector::borrow(path, k));
            k = k + 1;
        }
        vector::push_back(&mut new_path, *module);

        // Recurse into dependencies
        let deps_len = vector::length(&module.dependencies);
        let mut d = 0;
        while (d < deps_len) {
            let dep = vector::borrow(&module.dependencies, d);
            if (!check_no_recursion_internal(dep, &new_path)) {
                return false;
            }
            d = d + 1;
        }
        true
    }

    public fun check_no_recursion(module: &ModuleRef): bool {
        let path = vector::empty<ModuleRef>();
        check_no_recursion_internal(module, &path)
    }

    /// Create a sample recursive ModuleRef graph with cycle for test
    public fun sample_cyclic_module(): ModuleRef {
        let leaf = ModuleRef {
            address: 0xCAFE,
            name: vector::from_bytes(b"Leaf"),
            dependencies: vector::empty<ModuleRef>(),
        };
        let mut mid = ModuleRef {
            address: 0xCAFE,
            name: vector::from_bytes(b"Mid"),
            dependencies: vector::empty<ModuleRef>(),
        };
        vector::push_back(&mut mid.dependencies, leaf);

        // Create cycle: leaf depends on mid
        vector::push_back(&mut leaf.dependencies, mid);

        // Return mid (cycle reachable)
        mid
    }

    /// Create a sample acyclic ModuleRef graph for test
    public fun sample_acyclic_module(): ModuleRef {
        let leaf = ModuleRef {
            address: 0xCAFE,
            name: vector::from_bytes(b"Leaf"),
            dependencies: vector::empty<ModuleRef>(),
        };
        let mid = ModuleRef {
            address: 0xCAFE,
            name: vector::from_bytes(b"Mid"),
            dependencies: vector::empty<ModuleRef>(),
        };
        let mut root = ModuleRef {
            address: 0xCAFE,
            name: vector::from_bytes(b"Root"),
            dependencies: vector::empty<ModuleRef>(),
        };
        vector::push_back(&mut root.dependencies, mid);
        vector::push_back(&mut root.dependencies, leaf);
        root
    }

    /// Runner function to check cyclic graph (expected false)
    public fun runner_check_cycle(): bool {
        let cyc = sample_cyclic_module();
        check_no_recursion(&cyc)
    }

    /// Runner function to check acyclic graph (expected true)
    public fun runner_check_acyclic(): bool {
        let acyc = sample_acyclic_module();
        check_no_recursion(&acyc)
    }
}
// # run 0xCAFE::RecursiveChecker::runner_check_cycle
// # run 0xCAFE::RecursiveChecker::runner_check_acyclic

// # publish
module 0xCAFE::TypeParamFormatter {
    use std::string;
    use std::vector;

    /// Represents a type parameter constraint, for simplicity only ability constraints as string
    struct Constraint has copy, drop, store {
        constraint_name: vector<u8>, // e.g., b"copy" or b"drop"
    }

    /// Type parameter info with name and constraints
    struct TypeParamInfo has copy, drop, store {
        name: vector<u8>,
        constraints: vector<Constraint>,
    }

    /// Helper to join vector of bytes with a separator string ("," or others)
    fun join_constraints(constraints: &vector<Constraint>): vector<u8> {
        let len = vector::length(constraints);
        if (len == 0) {
            vector::empty<u8>()
        } else {
            let mut out = vector::empty<u8>();
            let mut i = 0;
            while (i < len) {
                let c = vector::borrow(constraints, i);
                if (i > 0) {
                    vector::append(&mut out, vector::from_bytes(b","));
                }
                vector::append(&mut out, c.constraint_name);
                i = i + 1;
            }
            out
        }
    }

    /// Formats a single type param info as a string with constraints, e.g. "T: copy + drop"
    fun format_type_param(tp: &TypeParamInfo): vector<u8> {
        let mut res = vector::empty<u8>();
        vector::append(&mut res, tp.name);
        let constr_len = vector::length(&tp.constraints);
        if (constr_len > 0) {
            vector::append(&mut res, vector::from_bytes(b": "));
            let len = vector::length(&tp.constraints);
            let mut i = 0;
            while (i < len) {
                let c = vector::borrow(&tp.constraints, i);
                if (i > 0) {
                    vector::append(&mut res, vector::from_bytes(b" + "));
                }
                vector::append(&mut res, c.constraint_name);
                i = i + 1;
            }
        }
        res
    }

    /// Formats a list of type parameters into a vector of u8 as comma separated string
    /// e.g. ["T: copy + drop", "U"]
    public fun format_type_params(params: &vector<TypeParamInfo>): vector<u8> {
        let len = vector::length(params);
        let mut out = vector::empty<u8>();
        let mut i = 0;
        while (i < len) {
            let tp = vector::borrow(params, i);
            if (i > 0) {
                vector::append(&mut out, vector::from_bytes(b", "));
            }
            vector::append(&mut out, format_type_param(tp));
            i = i + 1;
        }
        out
    }

    /// Create sample type params for test: [T: copy + drop, U]
    public fun sample_type_params(): vector<TypeParamInfo> {
        let mut params = vector::empty<TypeParamInfo>();

        let mut constrs_t = vector::empty<Constraint>();
        vector::push_back(&mut constrs_t, Constraint { constraint_name: vector::from_bytes(b"copy") });
        vector::push_back(&mut constrs_t, Constraint { constraint_name: vector::from_bytes(b"drop") });

        let t = TypeParamInfo {
            name: vector::from_bytes(b"T"),
            constraints: constrs_t,
        };

        let u = TypeParamInfo {
            name: vector::from_bytes(b"U"),
            constraints: vector::empty<Constraint>(),
        };

        vector::push_back(&mut params, t);
        vector::push_back(&mut params, u);
        params
    }

    /// Runner function to format sample type params into string
    public fun runner_format(): vector<u8> {
        let params = sample_type_params();
        format_type_params(&params)
    }
}
// # run 0xCAFE::TypeParamFormatter::runner_format

// # publish
module 0xCAFE::ExpressionReturn {
    use std::string;
    use std::vector;

    /// Returns a string with the given name repeated n times, 
    /// using final expression without trailing semicolon for the return value.
    public fun repeat_name(name: vector<u8>, n: u8): vector<u8> {
        let mut out = vector::empty<u8>();
        let mut i = 0u8;
        while (i < n) {
            vector::append(&mut out, &name);
            i = i + 1;
        }
        out // final expression returns out without ;
    }

    /// Runner function to repeat "Expr" 3 times
    public fun runner_repeat(): vector<u8> {
        let name = vector::from_bytes(b"Expr");
        repeat_name(name, 3)
    }
}
// # run 0xCAFE::ExpressionReturn::runner_repeat

// # run
script {
    use 0xCAFE::RecursiveChecker;
    use 0xCAFE::TypeParamFormatter;
    use 0xCAFE::ExpressionReturn;

    fun main() {
        // Test RecursiveChecker runner helpers
        let cycle_free = RecursiveChecker::runner_check_acyclic();
        let cycle_found = RecursiveChecker::runner_check_cycle();

        // Call type param formatter runner
        let formatted_params = TypeParamFormatter::runner_format();

        // Call expression return runner
        let repeated = ExpressionReturn::runner_repeat();

        // No asserts needed, just a run-through
        // Dummy no-op to use variables so they aren't warnings
        let _ = cycle_free;
        let _ = cycle_found;
        let _ = formatted_params;
        let _ = repeated;
    }
}

// Featurres:
// c1d6ce0b3f7643dd3e81334940d5f993: Initialize and run a recursive structure checker on targeted modules.
// 4122afb27c5fe0f1f8211da9cf3e0924: Format a list of type parameters with their names and constraints into a string suitable for code generation.
// 4b1e2b46aabc7fb4cadc6b955a2b1035: Write code blocks where the final expression is allowed without a trailing semicolon to return its value.
