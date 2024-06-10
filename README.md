# int

![https://github.com/SupTan85/int](cover.png)
This Project is math and calculate for large data in Lua. **this module is in beta!**\
reason why this module name is "int"? because in this module alway use integer to calculate math!\
**Verified: `Lua5.3 Lua5.4`**

## Feature

- **Calculate**
  - addition `+`
  - subtraction `-`
  - multiplication `*`
  - division `\, \\`
  - modulo `%`
  - power `^`
  - sqrt

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
  - cround
  - integerlen `INTEGER LEN`
  - fractionlen `FRACTION LEN`
  - fdigitlen `INTEGER LEN + FRACTION LEN`

**and more...**

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
-- require a module
local int = require("int")

-- build a new int object
local x = int.new("20")
local y = int.new("10")

print(x + y) -- output: 30
```

-----
**Note:** in version 148 or latest version. you can calculate **int object** with number without using `int.new`

```lua
-- require a module
local int = require("int")

-- build a new int object
local x = int.new("2")

print(x + 2) -- output: 4

```

-----
**Note:** in version 163 or latest version. you can call function with **int object** without using `int`

```lua
-- require a module
local int = require("int")

-- build a new int object
local x, y = int.new("5"), 2

-- if "x" is more then "y"
if x:more(y) then
    print(x:tostring().." is more then "..y)
end
```

**Recommend:** some equation operators won't work with other type, but alway work with **int object.**

**DO NOT DO LIKE THIS:**

```lua
local int = require("int")
local x = int.new("5")

-- DO NOT DO LIKE THIS:
print(x > 2) -- error
```

**BUT DO LIKE THIS:**

```lua
local int = require("int")
local x = int.new("5")

-- DO LIKE THIS:
print(x:more(2)) -- output: true
```

-----

## Design

This inside of **int object**, this is a number "101" also you use `tonumber` function to convert to number.

```lua
local example_int_table = {
    -- digit --
    [1] = 1, -- this a digit block
    [0] = 0,
    [-1] = 1,

    -- data --
    sign = "+",

    _dlen = -1, -- digit of fraction *this for calculate a fraction* **DO NOT CHANGE. HAVE LIMIT!!**
    _size = 1 -- mean per size of block *just maximum digit per value in the digit block* **DO NOT CHANGE. HAVE LIMIT!!**
}
```

## Function

all function is in version: **build 180**

- **module function**
  - int.new
  - int.cnew
  - int.tostring
  - int.tonumber
  - int.equal
  - int.less
  - int.more
  - int.eqless
  - int.eqmore
  - int.abs
  - int.fact
  - int.In</span>
  - int.exp
  - int.sqrt
  - int.pow
  - int.ceil
  - int.fdigitlen
  - int.floor
  - int.cround
  - int.fmod
  - int.fractionlen
  - int.integerlen
  - int.max
  - int.min
  - int.modf
  - int.sign

**Example to call a function:**

```lua
-- require a module.
local int = require("int")

-- build int object.
local x = int.new("14.695")

-- using a custom floor function.
print(int.cfloor(x, 2)) -- output: 14.69
```

-----

- **methods**
  - abs
  - fact
  - In
  - exp
  - sqrt
  - pow
  - ceil
  - eqless
  - eqmore
  - equal
  - fdigitlen
  - floor
  - cround
  - fmod
  - fractionlen
  - integerlen
  - less
  - max
  - min
  - modf
  - more
  - sign
  - tonumber
  - tostring

**Example to call a function:**

```lua
-- require a module.
local int = require("int")

-- build int object.
local x = int.new("14.695")

-- using a custom floor function.
print(x:cfloor(2)) -- output: 14.69
```

-----

## Limit

- Maximum digit of integer is 9223372036854775806
  - Set `_size` to `9` maximum digit of integer is `83010348331692982254 (9223372036854775806 * 9)`

- Maximum digit of fraction is 9223372036854775808
  - Set `_size` to `9` maximum fraction of integer is `83010348331692982263 (9223372036854775808 * 9)`

![end](image-d.png)
