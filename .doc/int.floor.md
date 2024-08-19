# int.floor

![https://github.com/SupTan85/int](cover.png)

## function

This function returns the largest integral value. However, you can custom it.

**Input type:**

- **x** -- [int object](../README.md#int-object) only.
- **length** -- number only.

```lua
function int.floor(x, length) -- Returns the largest integral value smaller than or equal to `x`, or Custom a `x` fraction.
```

**Example:**

```lua
local int = require("int") -- import module

local x, y = int.new("12.2", "12.3456")
print(int.floor(x)) -- output: 12
print(int.floor(y, 2)) -- output: 12.34
```

---

## methods

This feature support to call in object.

**This example call function inside object and return self object as input.**

```lua
local int = require("int") -- import module

local x, y = int.new("12.2", "12.3456")
print(x:floor()) -- output: 12
print(y:floor(2)) -- output: 12.34
```

also you can do like this:

**This example call function inside object but didn't return self object as input.**

```lua
local int = require("int") -- import module

local x, y = int.new("12.2", "12.3456")

-- this works like "print(int.floor(x))"
print(y.floor(x)) -- output: 15

-- this works like "print(int.floor(y, 2))"
print(x.floor(y, 2)) -- output: 13
```

---

[**Home**](../README.md#function--methods)

![end](image-d.png)