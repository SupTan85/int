# int.cnew

![https://github.com/SupTan85/int](cover.png)

## function

This function creates an object with a custom size per block.\
**Note: It is recommended to use string type as "number" input, also you can input number type.**

**Input type:**

- **number** -- string / number only
- **size** -- number only

```lua
function int.cnew(number, size) -- (number:string|number, size:string|number) For setting a size per block. **BLOCK SIZE SHOULD BE SAME WHEN CALCULATE**
```

**What does "size per block" mean?**\
It refers to how a module calculates or stores numbers. Specifically, it saves numbers inside an object, divided into blocks or indexes, to avoid reaching numerical limits. If the "size per block" is larger, calculations can be faster and more efficient, allowing the system to handle more data. However, using a smaller "size per block" may lead to instability in some functions that check the length of number inside object, and **maximum size is 9**

**Example:**

```lua
local int = require("int") -- import module

local x = int.cnew("12", 1) -- set size per block to 1 of the object
print(x) -- output: 12
```

---

[**Home**](../README.md#function--methods)

![end](image-d.png)
