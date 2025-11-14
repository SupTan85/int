# int

![https://github.com/SupTan85/int.lua](.doc/.assets/cover.png)

## Make it possible to calculate large number in Lua

The **int** module extends Lua capability to handle large numbers.

> [!NOTE]
This project is currently in beta.

Support & Verify: LuaJIT, Lua 5.1, Lua 5.2, Lua 5.3, Lua 5.4\
Check by [**TestSuite**](testsuite.lua)

---

## how to install

install with package manager:

> [!NOTE]
> To install this module with Luarocks
>
> ```bash
> luarocks install uint
> ```

**or download the [module](int.lua) and place it in the working directory or any directory in the package path.**

---

## how to use

**Frist, install the module by download or install with package manager.**\
Let's try import the module with `require` function in Lua

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

<img src=".doc\.assets\video1.gif" alt="demo" width="100%"/>

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
- **Equation**
  - equal
  - less than
  - more than
- **Function**
  - exp
  - fact
  - sqrt
  - *and more...*

---

## design

![design](.doc/.assets/design.png)

### inside object

This a example inside [**table**](.doc/type.table.md) of [**int object**](.doc/type.intobj.md).

```lua
local example_intobj_table = {
    -- digit --
    [1] = 1, -- chunk
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
    _size = 1 -- mean per size of chunk *just maximum digit per value in the digit chunk* **DO NOT CHANGE. HAVE LIMIT!!**
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
  - [int.tonumber](.doc/int.tonumber.md)
  - [int.tostring](.doc/int.tostring.md)
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
  - decimallen *-- return number of decimal digits*
  - integerlen *-- return number of integer digits*
  - less
  - ln
  - max
  - min
  - modf
  - more
  - pow *-- power function*
  - sign
  - sqrt
  - [tonumber](.doc/int.tonumber.md)
  - [tostring](.doc/int.tostring.md)
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
**however some function not support hyper threading system.*

- **Calculation**
  - `+` **addition &** `-` **subtraction** - very fast
  - `*` **multiplication** - fast
  - `\` **division &** `\\` **floor division** - slow
  - `%` **modulo** - slow
  - `^` **power** - very slow

- **Equation** "difference is a factor."
  - `==` **equal** - very fast
  - `<=` **equal** or **less then** - very fast
  - `>=` **equal** or **more then** - very fast
  - `<` **less than** - very fast
  - `>` **more than** - very fast

- **ETC**
  - `media.unm` Negation - very fast
  - `media.sqrt` Square root - slow
  - `media.ln` Natural logarithm - very slow
  - `media.exp` Exponential - very slow

---

## limit

- some function won't support a super very large data.

- on Lua version `5.1` maximum value of `_size` is `8`.

---

> [!NOTE]
reason why this module name is "int"? because in this module always use integer to calculate math,\
and feel free to use!\
**186 - 5**

![bar](.doc/.assets/bar.png)
