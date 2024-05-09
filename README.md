![https://github.com/SupTan85/int](cover.png)

# int

This Project is math and calculate for large data in Lua. **Waring: this module is in beta !! SO MANY BUG**

why this module name is "int"? because in this module alway use integer to calculate math!

## Feature

- **Calculate**
    - addition `+`
    - subtraction `-`
    - multiplication `*`
    - division `\, \\`
    - modulo `%`
    - power `^`

- **Equation**
    - equal
    - less than
    - more than

- **Other**
    - tostring
    - tonumber
    - sign
    - max
    - min
    - abs
    - In `Natural logarithm`
    - fact `Factorial function`
    - exp `Exponential function`
    - floor
    - cfloor
    - integerlen `INTEGER LEN`
    - decimallen `DECIMAL LEN`
    - fdigitlen `INTEGER LEN + DECIMAL LEN`

## How to use

Require a module with `require` function in Lua
```lua
local int = require("int")
```

Use this module you should to make a new object
```lua
local int = require("int")

local x = int.new("13") -- input can be a number or string! *recommend to use string*

print(x) -- output: "13"
```

Use **Calculation operators** to calculate math.

**Note:** only operator that in support
```lua
local int = require("int")

local x = int.new("20")
local y = int.new("10")

print(x + y) -- output: 30
```
-----
**Note:** in version 148 or latest version. you can calculate **int table** with number without using `int.new`
```lua
local int = require("int")

local x = int.new("2")

print(x + 2) -- output: 4

```
-----
**Note:** in version 163 or latest version. you can call some function with **int table** without using `int`
```lua
local int = require("int")

local x, y = int.new("5"), 2

if x:more(y) then
    print(x:tostring().." is more then "..y)
end
```
## Design

This inside of **int table**, and this mean "101" if you use `tostring` function.

```lua
local example_int_table = {
    -- digit --
    [1] = 1, -- this a digit block
    [0] = 0,
    [-1] = 1,

    -- table info --
    sign = "+",

    _dlen = -1, -- digit of decimal *this for calculate a decimal* **DO NOT CHANGE. HAVE LIMIT!!**
    _size = 1 -- mean per size of block *just maximum digit per value in the digit block* **DO NOT CHANGE. HAVE LIMIT!!**
}
```

## Limit
- Maximum digit of integer is 9223372036854775806
    - Set `_size` to `9` maximum digit of integer is `83010348331692982254! (9223372036854775806 * 9)`

- Maximum digit of decimal is 9223372036854775808
    - Set `_size` to `9` maximum decimal of integer is `83010348331692982272! (9223372036854775808 * 9)`

![](image-d.png)
