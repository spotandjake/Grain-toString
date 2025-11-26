# Compute Sizes
echo "Compiling Programs..."
grain compile HelloWorldGrain.gr --release --wat
grain compile HelloWorld.gr --release --wat
# Get Sizes
grainSize=$(stat -c%s HelloWorldGrain.wasm | awk '{print $1}')
librarySize=$(stat -c%s HelloWorld.wasm | awk '{print $1}')
echo "Grain Size: $((grainSize / 1024)) kB"
echo "Library Size: $((librarySize / 1024)) kB"
# Compute Difference
echo "Size Difference:"
sizeDiff=$((librarySize - grainSize))
# Echo in red if positive, green if negative
if [ $sizeDiff -gt 0 ]; then
  echo -e "\033[0;31m+$((sizeDiff / 1024)) KB\033[0m"
  echo -e "\033[0;31m+$(echo "scale=2; $librarySize / $grainSize * 100" | bc)%\033[0m"
else
  echo -e "\033[0;32m$((sizeDiff / 1024)) KB\033[0m"
  echo -e "\033[0;3em+$(echo "scale=2; $librarySize / $grainSize * 100" | bc)%\033[0m"
fi