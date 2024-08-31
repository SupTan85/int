# int.new

![https://github.com/SupTan85/int](cover.png)

## function

> [!NOTE]
**Information:** This function is used to create multiple objects at once, This function uses the default setting of size per block.\
*It is recommended to use string type as input, also you can input number type.*

**Input type:**

- **...args** -- either a string or a number.

```lua
function int.new(...) -- (string|number) For only create. alway use default size! **BLOCK SIZE SHOULD BE SAME WHEN CALCULATE**
```

> [!IMPORTANT]
The [int object](../README.md#int-object) is represented as a table in Lua, designed for calculation purposes within the int module. This table includes numerical data and calculation-related information, and it supports a metatable to facilitate ease of use.

**Example:**

```lua
local int = require("int") -- import module

local x, y = int.new(1, 2)
print(x) -- output: 1
print(y) -- output: 2
```

>[!TIP]
if you want to custom when create one object,\
you can use [**int.cnew**](int.cnew.md) function!

---

[**Home**](../README.md#function--methods)

![end](image-d.png)
