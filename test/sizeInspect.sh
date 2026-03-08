# Preprocess our wat
sed -E 's/\(exact \$([0-9]+)\)/\$\1/g' ./HelloWorld.wat > ./HelloWorldNames.wat
# Compile with wasm-tools
wasm-tools parse ./HelloWorldNames.wat -o ./HelloWorldNames.wasm
# Size analysis
bloaty ./HelloWorldNames.wasm -d symbols -n 0 --domain file --demangle=full