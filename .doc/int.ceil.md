# int.ceil

![https://github.com/SupTan85/int](cover.png)

## function

> [!NOTE] Information
This function returns the smallest integer greater than or equal to the given value.\
**When inputting negative numbers, the function will behave oppositely.**

**Input type:**

- **x** -- [int object](../README.md#int-object) only.

```lua
function int.ceil(x) -- Returns the smallest integral value larger than or equal to `x`.
```

**Example:**

```lua
local int = require("int") -- import module

local x, y = int.new("12.1", "14")
print(int.ceil(x)) -- output: 13
print(int.ceil(y)) -- output: 14
```

---

## methods

This feature support to call in object.

> [!TIP]
> This example call function inside object and return self object as input.

```lua
local int = require("int") -- import module

local x, y = int.new("12.1", "14")
print(x:ceil()) -- output: 13
print(y:ceil()) -- output: 14
```

also you can do like this:

> [!TIP]
This example call function inside object but didn't return self object as input.

```lua
local int = require("int") -- import module

local x, y = int.new("12.1", "14")

-- this works like "print(int.ceil(x))"
print(y.ceil(x)) -- output: 13

-- this works like "print(int.ceil(y))"
print(x.ceil(y)) -- output: 14
```

---

[**Home**](../README.md#function--methods)

![end](image-d.png)
