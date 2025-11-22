grain smallProgram.gr --release
grain smallProgramBench.gr --release
echo "Size of Current"
stat -f%z smallProgramBench.wasm | awk '{print $1/1024 " KB"}'
echo "Size of New"
stat -f%z smallProgram.wasm | awk '{print $1/1024 " KB"}'
# Compute Difference
echo "Size Difference"
diff=$(stat -f%z smallProgram.wasm | awk '{print $1}')
diffOld=$(stat -f%z smallProgramBench.wasm | awk '{print $1}')
sizeDiff=$((diff - diffOld))
# Echo in red if positive, green if negative
if [ $sizeDiff -gt 0 ]; then
  echo -e "\033[0;31m+$((sizeDiff / 1024)) KB\033[0m"
else
  echo -e "\033[0;32m$((sizeDiff / 1024)) KB\033[0m"
fi