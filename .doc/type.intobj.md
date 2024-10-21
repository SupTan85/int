# int object

![https://github.com/SupTan85/int.lua](.assets/cover.png)

>[!NOTE]
A [**table**](type.table.md) that made for calculate, used with operators or use with [**function & methods**](../README.md#function--methods)\
*"All value type should be a number only and not emply"*

>[!WARNING]
This object was created for this module only!

Way to create this object:

- use [**int.new**](int.new.md)
- use [**int.cnew**](int.cnew.md)

**Example:**

```lua
local int = require("int") -- don't forgot to require a module!

local x, y = int.new("12", "14")
print(x + y) -- output: 26
```

**or:**

```lua
local int = require("int") -- don't forgot to require a module!

local x = int.new("14")
if x:eqmore("12") then -- some Lua version will not suport, that why i recommend you to use function.
    print("omg yes") -- output: omg yes
end
```

---

[**home**](../README.md)\
[**design & inside object**](../README.md#design)

![end](.assets/bar.png)
