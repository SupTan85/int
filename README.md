# int

![https://github.com/SupTan85/int.lua](.doc/.assets/cover.png)

## Make it possible to calculate large number in Lua

The **int** module extends Lua capability to handle large numbers.

> [!NOTE]
This project is currently in beta.

Support & Verify: Lua 5.1, Lua 5.2, Lua 5.3, Lua 5.4\
Check by [**example.lua**](example.lua) file

---

## how to use

**Frist, download the [module](int.lua) and place it in your folder or somewhere you can access it.**\
Import the module with `require` function in Lua

```lua
local int = require("int")
```

Next, to create a new object, you have to use [**int.new**](.doc/int.new.md) function.

```lua
local int = require("int")

local x = int.new("13") -- input can be either a number or a string! *recommend to use string*

print(x) -- output: "13"
```

To use [**calculation operators**](#operators) to calculate math.

> [!CAUTION]
only operator that is supported.

![video1](.doc/.assets/video1.gif)

you can do like this:

```lua
-- require a module
local int = require("int")

-- build a new int object
local x, y = int.new("20", "10")

print(x + y) -- output: 30
```

---

## feature

> [!TIP]
before use any function, don't forget to read function [**performance**](#performance)!

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

---

## design

![design](.doc/.assets/design.png)

### inside object

This a example inside [**table**](.doc/type.table.md) of [**int object**](.doc/type.intobj.md).

```lua
local example_int_table = {
    -- digit --
    [1] = 1, -- this a digit block
    [0] = 0,
    [-1] = 1,

    --[[
        << fraction | digit >>
      INDEX: -1 | 0 | 1
      VALUE:  1 : 0 : 1

      TOSTRING: "1.01"
      TONUMBER: 1.01
    ]]
    -- data --
    sign = "+",

    _dlen = -1, -- digit of fraction *this for calculate a fraction* **DO NOT CHANGE. HAVE LIMIT!!**
    _size = 1 -- mean per size of block *just maximum digit per value in the digit block* **DO NOT CHANGE. HAVE LIMIT!!**
}
```

### inside module

![image1](.doc/.assets/image1.png)

- **master** library for build-in function.
- **media** library for other build-in function. *-- require master*
- **int** library for call function in the module. *-- require master & media*

> [!IMPORTANT]
when you use `require`, `loadfile` or `dofile` function to load the module,\
the module will return only [**table**](.doc/type.table.md) that name **int** only

---

## function & methods

all function is in version: **186**

>[!NOTE]
Recommend to read in visual studio code.

- **module function**
  - int.abs
  - int.ceil
  - [int.cnew](.doc/int.cnew.md) *-- custom int.new function*
  - int.cround
  - int.eqless *-- equal or less then*
  - int.eqmore *-- equal or more then*
  - int.equal
  - int.exp
  - int.fact
  - int.fdigitlen *-- return sum of number integer digits and number decimal digits.*
  - [int.floor](.doc/int.floor.md)
  - int.fmod *-- modulo function*
  - int.decimallen *-- return number of decimal digits*
  - int.integerlen *-- return number of integer digits*
  - int.less
  - int.ln
  - int.max
  - int.min
  - int.modf
  - int.more
  - [int.new](.doc/int.new.md)
  - int.pow *-- power function*
  - int.sign
  - int.sqrt
  - int.tonumber
  - int.tostring
  - int.unm

**Example to call a function:**

```lua
-- require a module.
local int = require("int")

-- build int object.
local x = int.new("14.695")

-- using a custom floor function.
print(int.floor(x, 2)) -- output: 14.69
```

---

- **methods**
  - abs
  - ceil
  - cround
  - eqless *-- equal or less then*
  - eqmore *-- equal or more then*
  - equal
  - exp
  - fact
  - fdigitlen *-- return sum of number integer digits and number decimal digits.*
  - [floor](.doc/int.floor.md#methods)
  - fmod *-- modulo function*
  - decimallen *-- return only length of fraction*
  - integerlen *-- return only length of integer*
  - less
  - ln
  - max
  - min
  - modf
  - more
  - pow *-- power function*
  - sign
  - sqrt
  - tonumber
  - tostring
  - unm

**Example to call a function:**

```lua
-- require a module.
local int = require("int")

-- build int object.
local x = int.new("14.695")

-- using a custom floor function.
print(x:floor(2)) -- output: 14.69
```

---

## operators

- **Calculation**
  - addition `+`
  - subtraction `-`
  - multiplication `*`
  - division `\`
  - floor division `\\` *-- some version of Lua are not support (require Lua 5.3 >=)*
  - modulo `%` *-- some version of Lua are not support (require Lua 5.1 >=)*
  - power `^` *-- some version of Lua are not support (require Lua 5.1 >=)*

**Example to using a calculation operator:**

```lua
local int = require("int")

local x, y = int.new("4", "2")

print(x / y) -- output: 2
```

> [!IMPORTANT]
some version of Lua you can use calculation operator with number & string

---

- **Equation**
  - `==` equal
  - `<=` equal or less then
  - `>=` equal or more then
  - `<` less than
  - `>` more than

**Example to using a equation operator:**

```lua
local int = require("int")

local x, y = int.new("4", "2")

print(x > y) -- output: true
```

> [!IMPORTANT]
some version of Lua you can use equation operator with number & string

---

## performance

> [!NOTE]
Lua didn't support hyper threading system, mean we can't use full performance of cpu!\
*however some function not support hyper threading system.*

- **Calculation**
  - `+` **addition &** `-` **subtraction** - very fast
  - `*` **multiplication** - fast
  - `\` **division &** `\\` **floor division** - slow
  - `%` **modulo** - slow
  - `^` **power** - very very slow *"because use a lot of memory"*

- **Equation**
  - `==` **equal** - very fast *"difference is a factor."*
  - `<=` **equal** or **less then** - very fast *"difference is a factor."*
  - `>=` **equal** or **more then** - very fast *"difference is a factor."*
  - `<` **less than** - very fast
  - `>` **more than** - very fast

- **ETC**
  - some other function didn't make for very large data, don't forget to report bug!

---

## limit

- some function won't support a super very large data.
</br>

- Maximum integer path is 9223372036854775806
  - Set `_size` to `9` maximum integer path is `83010348331692982254 (9223372036854775806 * 9)`

- Maximum decimal path is 9223372036854775808
  - Set `_size` to `9` maximum decimal path is `83010348331692982263 (9223372036854775808 * 9)`

---

> [!NOTE]
reason why this module name is "int"? because in this module always use integer to calculate math,\
and feel free to use!\
**186 - 3**

![bar](.doc/.assets/bar.png)
