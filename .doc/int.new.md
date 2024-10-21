# int.new

![https://github.com/SupTan85/int.lua](.assets/cover.png)

## function

> [!NOTE]
The [**int object**](../README.md#int-object) is represented as a table in Lua, designed for calculation purposes within the int module. This table includes numerical data and calculation-related information, and it supports a metatable to facilitate ease of use.

**Input type:**

- [**arg(...)**](type.vararg.md) -- either a string or a number.

**Output type:**

- [**int object**](type.intobj.md)

```lua
function int.new(...) -- (string|number) For only create. alway use default size! **BLOCK SIZE SHOULD BE SAME WHEN CALCULATE**
```

**Example:**

```lua
local int = require("int") -- import module

local x, y = int.new(1, 2)
print(x) -- output: 1
print(y) -- output: 2
```

>[!TIP]
if you want to custom when create one [**int object**](type.intobj.md) only,\
you can use [**int.cnew**](int.cnew.md) function!

---

[**function & methods**](../README.md#function--methods)

![end](.assets/bar.png)
