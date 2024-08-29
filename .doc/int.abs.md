# int.abs

![https://github.com/SupTan85/int](cover.png)

## function

> [!NOTE] Information
This function returns the absolute value of the given number.

**Input type:**

- **x** -- [int object](../README.md#int-object) only.

```lua
function int.abs(x) -- Returns the absolute value of `x`.
```

**Example:**

```lua
local int = require("int") -- import module

local x, y = int.new("-15", "13")
print(int.abs(x)) -- output: 15
print(int.abs(y)) -- output: 13
```

---

## methods

This feature support to call in object.

> [!TIP]
This example call function inside object and return self object as input.

```lua
local int = require("int") -- import module

local x, y = int.new("-15", "13")
print(x:abs()) -- output: 15
print(y:abs()) -- output: 13
```

also you can do like this:

> [!TIP]
This example call function inside object but didn't return self object as input.

```lua
local int = require("int") -- import module

local x, y = int.new("-15", "13")

-- this works like "print(int.abs(x))"
print(y.abs(x)) -- output: 15

-- this works like "print(int.abs(y))"
print(x.abs(y)) -- output: 13
```

---

[**Home**](../README.md#function--methods)

![end](image-d.png)
