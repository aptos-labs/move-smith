The transactional test has the following format:
0. Do not use `0x1` as test address. Use somethign like `0xCAFE`.
1. Above each new module, you should write `//# publish` to compile and publish the module.
    This will exercise the compiler to compile the module.
    The publish command must be at the beginning of the immediate line above the module definition.
2. Above each script, you should write `//# run` to indicate that the script should be run.
    This will exervcise both the compiler and the virtual machine.
    The run command must be at the beginning of the immediate line above the script definition.
    If the main function in script requires some argument
3. If some functions defined in a module should be run, you should add `//# run <address>::<module name>::<function_name>` after the module definition.
    * If a signer is needed, you should add `--signers <address>` after the run command.
    * If other arguments are needed, you should add `--args <args>` after the run command where args are the arguments to the function.
    * You should try to implement some "runner" function inside the module that can be called without arguments.
    * An example run command: `//# run 0xCAFE::Module0::some_function --signers 0xBEEF --args 123u8 789u64`
    * Each `//# run` command must be separated by an empty line from any content above it.
4. You can ignore adding assertions.
5. For transactioanl tests, you should not use address aliases. Just use the full address.
6. All transactional commands must be put out of modules and scripts.
7. IMPORTANT: ALL TRANSACTIONAL COMMANDS MUST BE AT TOP LEVEL -- NOT WITHIN A MODULE OR A FUNCTION
