# int.new

![https://github.com/SupTan85/int](cover.png)

## Function

This function is used to create multiple objects at once, This function uses the default size settings per block.\
> [!TIP]
> **It is recommended to use string type as input, also you can input number type.**

## Input type

- **...args** -- string / number only

```lua
function int.new(...) -- (string|number) For only create. alway use default size! **BLOCK SIZE SHOULD BE SAME WHEN CALCULATE**
```

## Example

```lua
local int = require("int") -- import module

local x, y = int.new(1, 2)
print(x) -- output: 1
print(y) -- output: 2
```

---

[**Home**](../README.md#function--methods)

![end](image-d.png)
