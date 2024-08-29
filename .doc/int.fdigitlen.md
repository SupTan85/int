# int.fdigitlen

![https://github.com/SupTan85/int](cover.png)

## function

This function counts and return length of digits.

**Input type:**

- **x** -- [int object](../README.md#int-object) only.

```lua
function int.fdigitlen(x) -- Returns length of `INTEGER` + length of `FRACTION`.
```

**Example:**

```lua
local int = require("int") -- import module

local x, y = int.new("12.34", "123.4")
print(int.fdigitlen(x)) -- output: 4
print(int.fdigitlen(y)) -- output: 4
```

---

## methods

This feature support to call in object.

**This example call function inside object and return self object as input.**

```lua
local int = require("int") -- import module

local x, y = int.new("12.34", "123.4")
print(x:fdigitlen()) -- output: 4
print(y:fdigitlen()) -- output: 4
```

also you can do like this:

**This example call function inside object but didn't return self object as input.**

```lua
local int = require("int") -- import module

local x, y = int.new("12.34", "123.4")

-- this works like "print(int.fdigitlen(x))"
print(y.fdigitlen(x)) -- output: 4

-- this works like "print(int.fdigitlen(y))"
print(x.fdigitlen(y)) -- output: 4
```

---

[**Home**](../README.md#function--methods)

![end](image-d.png)
