# int.tonumber

![https://github.com/SupTan85/int.lua](.assets/cover.png)

## function

> [!NOTE]
This function converts an [**int object**](type.intobj.md) to number.

>[!WARNING]
We do not recommend using this function with large numbers, because they may be represented in scientific notation or lose precision.<br>
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

This feature support to call in object.

> [!TIP]
This example call function inside object and return self object as input.

```lua
local int = require("int") -- import module

local x = int.new("35")
print(x:tonumber()) -- output: 35
```

also you can do like this:

> [!TIP]
This example call function inside object but didn't return self object as input.

```lua
local int = require("int") -- import module

local x, y = int.new("35", "85")

-- this works like "print(int.tonumber(x))"
print(y.tonumber(x)) -- output: 35

-- this works like "print(int.tonumber(y))"
print(x.tonumber(y)) -- output: 85
```

---

[**function & methods**](../README.md#function--methods)\
[**tostring**](int.tostring.md)

![end](.assets/bar.png)
