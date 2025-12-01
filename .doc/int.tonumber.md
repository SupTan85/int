# int.tonumber

![https://github.com/SupTan85/int.lua](.assets/cover.svg)

## function

> [!NOTE]
This function converts an [**int object**](type.intobj.md) to number.

>[!WARNING]
We do **not recommend** using this function with large numbers, because they may be represented in scientific notation or lose precision.<br>
please use [**tostring**](int.tostring.md) instead of tonumber!

**Input type:**

- **x** -- [**int object**](type.intobj.md) only.

**Output type:**

- **number**

```lua
function int.tonumber(x) -- Deconvert table to number. *not recommend*
```

**Example:**

```lua
local int = require("int") -- import module

local x = int.new("35")
print(int.tonumber(x)) -- output: 35
```

**or:**

>[!TIP]
You can use the `tonumber` function in Lua to call this function or convert [**int object**](type.intobj.md)!

```lua
local int = require("int") -- import module

local x = int.new("35")
print(tonumber(x)) -- output: 35
```

---

## methods

This feature lets you to call functions on an object.

```lua
local int = require("int") -- import module

local x = int.new("35")
print(x:tonumber()) -- output: 35
```

> [!TIP]
In this example, a function inside the object is called and returns the object itself as the input.

also you can do like this:

```lua
local int = require("int") -- import module

local x, y = int.new("35", "85")

-- this works like "print(int.tonumber(x))"
print(y.tonumber(x)) -- output: 35

-- this works like "print(int.tonumber(y))"
print(x.tonumber(y)) -- output: 85
```

> [!TIP]
In this example, a function inside the object is called but a different object is used as the input.

---

[**function & methods**](../README.md#function--methods)\
[**tostring**](int.tostring.md)

![end](.assets/bar.svg)
