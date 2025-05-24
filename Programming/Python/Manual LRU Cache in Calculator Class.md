# Manual LRU Cache in `Calculator` Class — Explanation & Example

## Explanation

- Cache stores results of `add` and `multiply` methods.
- Uses a dictionary (`cache_data`) for fast lookups.
- Maintains a list (`cache_order`) to track usage order (LRU).
- When cache size exceeds `maxsize`, it evicts the least recently used item.
- Cache key is a tuple: operation name + arguments.

---

## Code Example

```python
class Calculator:
    def __init__(self, maxsize=100):
        self.cache_data = {}
        self.cache_order = []
        self.maxsize = maxsize

    def _cache_lookup(self, key):
        if key in self.cache_data:
            # Update usage order (LRU)
            self.cache_order.remove(key)
            self.cache_order.append(key)
            return self.cache_data[key]
        return None

    def _cache_store(self, key, result):
        self.cache_data[key] = result
        self.cache_order.append(key)
        if len(self.cache_order) > self.maxsize:
            oldest = self.cache_order.pop(0)
            del self.cache_data[oldest]

    def add(self, a, b):
        key = ('add', a, b)
        cached = self._cache_lookup(key)
        if cached is not None:
            print("Cache hit [add]:", key)
            return cached
        print("Calculating [add]:", a, "+", b)
        result = a + b
        self._cache_store(key, result)
        return result

    def multiply(self, a, b):
        key = ('mul', a, b)
        cached = self._cache_lookup(key)
        if cached is not None:
            print("Cache hit [mul]:", key)
            return cached
        print("Calculating [mul]:", a, "*", b)
        result = a * b
        self._cache_store(key, result)
        return result

    def clear_cache(self):
        self.cache_data.clear()
        self.cache_order.clear()

# --- Usage Example ---

calc = Calculator(maxsize=3)

print(calc.add(2, 3))        # Calculates and caches
print(calc.add(2, 3))        # Cache hit

print(calc.multiply(4, 5))   # Calculates and caches
print(calc.multiply(4, 5))   # Cache hit

print(calc.add(1, 1))        # Calculates and caches
print(calc.add(3, 3))        # Calculates and caches, triggers eviction (maxsize=3)

print(calc.add(2, 3))        # Recalculates because old cache was evicted
````

---

## Expected Output

```
Calculating [add]: 2 + 3
5
Cache hit [add]: ('add', 2, 3)
5
Calculating [mul]: 4 * 5
20
Cache hit [mul]: ('mul', 4, 5)
20
Calculating [add]: 1 + 1
2
Calculating [add]: 3 + 3
6
Calculating [add]: 2 + 3
5
```
