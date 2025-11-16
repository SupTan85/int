# int.unm

![https://github.com/SupTan85/int.lua](.assets/cover.png)

## function

> [!NOTE]
This function is made for a **unary operator**, so it reverses the sign of a number.

**Input type:**

- **x** -- [**int object**](type.intobj.md) only.

**Output type:**

- [**int object**](type.intobj.md)

```lua
function int.unm(x) -- reverses the sign.
```

**Example:**

```lua
local int = require("int") -- import module

local x, y = int.new("12.2", "12.3456")
print(int.unm(x)) -- output: -12.2
print(int.unm(y)) -- output: -12.3456
```

---

## operators

This feature lets you to call a function with an operator.

> [!IMPORTANT]
> function was embedded in `__unm` on metadata.

```lua
local int = require("int") -- import module

local x, y = int.new("123", "12.3456")
print(-x) -- output: -123
print(-y) -- output: -12.3456
```

---

## methods

This feature lets you to call functions on an object.

```lua
local int = require("int") -- import module

local x, y = int.new("12.2", "12.3456")
print(x:unm()) -- output: -12.2
print(y:unm()) -- output: -12.3456
```

> [!TIP]
In this example, a function inside the object is called and returns the object itself as the input.

also you can do like this:

```lua
local int = require("int") -- import module

local x, y = int.new("12.2", "12.3456")

-- this works like "print(int.unm(x))"
print(y.unm(x)) -- output: -12.2

-- this works like "print(int.unm(y))"
print(x.unm(y)) -- output: -12.3456
```

> [!TIP]
In this example, a function inside the object is called but a different object is used as the input.

---

[**function & methods**](../README.md#function--methods)\
[**operators**](../README.md#operators)

![end](.assets/bar.png)
