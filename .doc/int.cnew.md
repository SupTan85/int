# int.cnew

![https://github.com/SupTan85/int.lua](.assets/cover.png)

## function

> [!NOTE]
**Information:** This function creates an [**int object**](type.intobj.md) with a custom size per block.\
*It is recommended to use string type as "number" input, also you can input number type.*

**Input type:**

- **number** -- either a string or a number.
- **size** -- number only. *"should be integer"*

**Output type:**

- [**int object**](type.intobj.md)

```lua
function int.cnew(number, size) -- (number:string|number, size:string|number) For setting a size per block. **BLOCK SIZE SHOULD BE SAME WHEN CALCULATE**
```

> [!IMPORTANT]
**What does "size per block" mean?**\
It refers to how a module calculates or stores numbers. Specifically, it saves numbers inside an [**int object**](type.intobj.md), divided into blocks or indexes, to avoid reaching numerical limits. If the "size per block" is larger, calculations can be faster and more efficient, allowing the system to handle more data. However, using a smaller "size per block" may lead to instability in some functions that check the length of number inside object, and **maximum of size per block is 9 (in default setting) & Should be integer.**

**Example:**

```lua
local int = require("int") -- import module

local x = int.cnew("12", 1) -- set size per block to 1 of the object
print(x) -- output: 12
```

>[!TIP]
if you want to create new a lot of [**int object**](type.intobj.md) in one time without custom anything or use default setting,\
you can use [**int.new**](int.new.md) function!

---

[**function & methods**](../README.md#function--methods)

![end](.assets/bar.png)
