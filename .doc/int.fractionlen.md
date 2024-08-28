# int.fractionlen

![https://github.com/SupTan85/int](cover.png)

## function

> [!NOTE] Information
This function counts and return length of fraction.

**Input type:**

- **x** -- [int object](../README.md#int-object) only.

```lua
function int.fractionlen(x) -- Returns length of `FRACTION`.
```

It does not include integer.

**Example:**

```lua
local int = require("int") -- import module

local x, y = int.new("12.34", "123.4")
print(int.fractionlen(x)) -- output: 2
print(int.fractionlen(y)) -- output: 1
```

---

## methods

This feature support to call in object.

> [!TIP]
This example call function inside object and return self object as input.

```lua
local int = require("int") -- import module

local x, y = int.new("12.34", "123.4")
print(x:fractionlen()) -- output: 2
print(y:fractionlen()) -- output: 1
```

also you can do like this:

> [!TIP]
This example call function inside object but didn't return self object as input.

```lua
local int = require("int") -- import module

local x, y = int.new("12.34", "123.4")

-- this works like "print(int.fractionlen(x))"
print(y.fractionlen(x)) -- output: 2

-- this works like "print(int.fractionlen(y))"
print(x.fractionlen(y)) -- output: 1
```

---

[**Home**](../README.md#function--methods)

![end](image-d.png)
