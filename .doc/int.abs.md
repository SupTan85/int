# int.abs

![https://github.com/SupTan85/int.lua](.assets/cover.svg)

## function

> [!NOTE]
This function always set the sign of a number to positive.

**Input type:**

- **x** -- [**int object**](type.intobj.md) only.

**Output type:**

- [**int object**](type.intobj.md)

```lua
function int.abs(x) -- Returns the absolute value of `x`.
```

**Example:**

```lua
local int = require("int") -- import module

local x, y = int.abs("-3.14", "12.3456")
print(int.abs(x)) -- output: 3.14
print(int.abs(y)) -- output: 12.3456
```

---

## methods

This feature lets you to call functions on an object.

```lua
local int = require("int") -- import module

local x, y = int.new("-12.2", "12.3456")
print(x:abs()) -- output: 12.2
print(y:abs()) -- output: 12.3456
```

> [!TIP]
In this example, a function inside the object is called and returns the object itself as the input.

also you can do like this:

```lua
local int = require("int") -- import module

local x, y = int.new("-12.2", "12.3456")

-- this works like "print(int.abs(x))"
print(y.abs(x)) -- output: 12.2

-- this works like "print(int.abs(y))"
print(x.abs(y)) -- output: 12.3456
```

> [!TIP]
In this example, a function inside the object is called but a different object is used as the input.

---

[**function & methods**](../README.md#function--methods)

![end](.assets/bar.svg)
