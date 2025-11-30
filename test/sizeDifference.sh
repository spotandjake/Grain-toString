# Compute Sizes
echo "Compiling Programs..."
grain compile HelloWorldGrain.gr --release --wat
grain compile HelloWorld.gr --release --wat
# Get Sizes
grainSize=$(wc -c HelloWorldGrain.wasm | awk '{print $1}')
librarySize=$(wc -c HelloWorld.wasm | awk '{print $1}')
echo "Grain Size: $((grainSize / 1024)) kB, $grainSize bytes"
echo "Library Size: $((librarySize / 1024)) kB, $librarySize bytes"
# Compute Difference
echo "Size Difference:"
sizeDiff=$((librarySize - grainSize))
# Echo in red if positive, green if negative
if [ $sizeDiff -gt 0 ]; then
  echo -e "\033[0;31m+$((sizeDiff / 1024)) KB, $sizeDiff bytes\033[0m"
  echo -e "\033[0;31m+$(echo "scale=2; $librarySize / $grainSize * 100" | bc)%\033[0m"
else
  echo -e "\033[0;32m$((sizeDiff / 1024)) KB, $sizeDiff bytes\033[0m"
  echo -e "\033[0;3em+$(echo "scale=2; $librarySize / $grainSize * 100" | bc)%\033[0m"
fi