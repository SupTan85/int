# int.pow

![https://github.com/SupTan85/int](cover.png)

## function

> [!NOTE]
**Information:** This function returns the result of a modulo operation.

**Input type:**

- **x** -- either an [int object](../README.md#int-object), a string, a number.
- **y** -- either an [int object](../README.md#int-object), a string, a number.

```lua
function int.pow(x, y, f, l) -- Returns `x ^ y`. (`f` The maxiumum number of fraction, `l` The maximum number of iterations to perform.)
```

**Example:**

```lua
local int = require("int") -- import module

local x, y = int.new("2", "3")
print(int.pow(x, y)) -- output: 8
```

---

## operator

use operator to calculate number, support either an [int object](../README.md#int-object), a string, a number.

> [!WARNING]
**Requirement of power operator "^"**\
some version of Lua are not support (require Lua 5.1 >=)

**Example:**

```lua
local int = require("int") -- import module

local x, y = int.new("2", "3")
print(x ^ y) -- output: 8
```

**also you can do this:**

```lua
local int = require("int") -- import module

local x = int.new("2")
print(x ^ "3") -- output: 8 (recommend)
print(x ^ 3) -- output: 8 (not recommend for large number or very less number of number type)
```

---

## methods

This feature support to call in object.

> [!TIP]
This example call function inside object and return self object as input.

```lua
local int = require("int") -- import module

local x, y = int.new("2", "3")
print(x:pow(y)) -- output: 8
```

also you can do like this:

> [!TIP]
This example call function inside object but didn't return self object as input.

```lua
local int = require("int") -- import module

local x, y = int.new("2", "3")

-- this works like "print(int.fmod(x, y))"
print(y.pow(x, y)) -- output: 8

-- this works like "print(int.fmod(x, y))"
print(x.pow(x, y)) -- output: 8
```

---

[**Home**](../README.md#function--methods)

![end](image-d.png)
