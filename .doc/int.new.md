# int.new

![https://github.com/SupTan85/int.lua](.assets/cover.svg)

## Syntax & Usage

> [!NOTE]
The [**int object**](../README.md#int-object) is represented as a table in Lua, designed for calculation purposes within the int module. This table includes numerical data and calculation-related information, and it supports a metatable to facilitate ease of use.

```lua
function int.new(...) -- (string|number) For only create. alway use default size! **CHUNK SIZE SHOULD BE SAME WHEN CALCULATE**
```

**Parameter:**

- [**arg(...)**](type.vararg.md) -- either a string or a number.

**Return Value:**

- [**int object**](type.intobj.md)

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

![end](.assets/bar.svg)
