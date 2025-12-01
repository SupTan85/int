# int.floor

![https://github.com/SupTan85/int.lua](.assets/cover.svg)

## function

> [!NOTE]
This function returns the largest integral value of the given number. However, you can custom it.\
*When inputting negative numbers, the function will behave oppositely (floor -> ceil).*

**Input type:**

- **x** -- [**int object**](type.intobj.md) only.
- **length** -- number only.

**Output type:**

- [**int object**](type.intobj.md)

```lua
function int.floor(x, length) -- Returns the largest integral value smaller than or equal to `x`, or Custom a `x` fraction.
```

**Example:**

```lua
local int = require("int") -- import module

local x, y = int.new("-12.2", "12.3456")
print(int.floor(x)) -- output: -13
print(int.floor(y, 2)) -- output: 12.34
```

---

## methods

This feature lets you to call functions on an object.

```lua
local int = require("int") -- import module

local x, y = int.new("-12.2", "12.3456")
print(x:floor()) -- output: -13
print(y:floor(2)) -- output: 12.34
```

> [!TIP]
In this example, a function inside the object is called and returns the object itself as the input.

also you can do like this:

```lua
local int = require("int") -- import module

local x, y = int.new("-12.2", "12.3456")

-- this works like "print(int.floor(x))"
print(y.floor(x)) -- output: -13

-- this works like "print(int.floor(y, 2))"
print(x.floor(y, 2)) -- output: 12.34
```

> [!TIP]
In this example, a function inside the object is called but a different object is used as the input.

---

[**function & methods**](../README.md#function--methods)

![end](.assets/bar.svg)
