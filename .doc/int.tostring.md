# int.tostring

![https://github.com/SupTan85/int.lua](.assets/cover.svg)

## function

> [!NOTE]
This function converts an [**int object**](type.intobj.md) to number but on string type, to handle a large number.

**Input type:**

- **x** -- [**int object**](type.intobj.md) only.

**Output type:**

- **string**

```lua
function int.tostring(x) -- Deconvert table to string.
```

**Example:**

```lua
local int = require("int") -- import module

local x = int.new("35")
print(int.tostring(x)) -- output: 35
```

**or:**

>[!TIP]
You can use the `tostring` function in Lua to call this function or convert [**int object**](type.intobj.md)!

```lua
local int = require("int") -- import module

local x = int.new("35")
print(tostring(x)) -- output: 35
```

---

## methods

This feature lets you to call functions on an object.

```lua
local int = require("int") -- import module

local x = int.new("35")
print(x:tostring()) -- output: 35
```

> [!TIP]
In this example, a function inside the object is called and returns the object itself as the input.

also you can do like this:

```lua
local int = require("int") -- import module

local x, y = int.new("35", "85")

-- this works like "print(int.tostring(x))"
print(y.tostring(x)) -- output: 35

-- this works like "print(int.tostring(y))"
print(x.tostring(y)) -- output: 85
```

> [!TIP]
In this example, a function inside the object is called but a different object is used as the input.

---

[**function & methods**](../README.md#function--methods)

![end](.assets/bar.svg)
