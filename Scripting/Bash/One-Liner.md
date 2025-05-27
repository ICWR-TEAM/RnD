# One Liner

### For print update only

```bash
f="file.txt"; p=".data_last.json"; [ -f "$p" ] || echo '{}' > "$p"; last=$(jq -r --arg f "$f" '.[$f]//0' "$p"); current=$(wc -l < "$f" | tr -d ' '); diff=$((current - last)); [ "$diff" -gt 0 ] && tail -n "$diff" "$f"; jq --arg f "$f" --argjson pos "$current" '.[$f]=$pos' "$p" > tmp.$$.json && mv tmp.$$.json "$p"
```
