# int

math and calculate for large data in Lua
**waring this module is in beta!**

## Feature

- **calculate**
    - addition `+`
    - subtraction `-`
    - multiplication `*`
    - division `\, \\`
    - modulo `%`
- **equation**
    - equal
    - less than
    - more than
- **other**
    - tostring
    - tonumber
    - sign
    - abs
    - floor
    - fdigitlen `INTEGER + DECIMAL`

## How to use

you can require a module with *require* function in Lua
```lua
local int = require("int")
```

to use this module you should to make a **new** object
```lua
local int = require("int")

int.new("13") -- input can be a number or string! *recommend to use string*
```

you can use **Calculation operators** to calculate math. 
**note: only operator that in support**
```lua
local int = require("int")

local a = int.new("20")
local b = int.new("10")

print(a + b) -- output: 30
```
## limit
- maximum digit of integer is 9223372036854775806
- maximum digit of decimal is 9223372036854775808
