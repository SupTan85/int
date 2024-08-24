# int.fmod

![https://github.com/SupTan85/int](cover.png)

## function

This function returns the result of a modulo operation.

**Input type:**

- **x** -- either an [int object](../README.md#int-object), a string, a number.
- **y** -- either an [int object](../README.md#int-object), a string, a number.

```lua
function int.fmod(x, y) -- Returns the remainder of the division of `x` by `y` that rounds the quotient towards zero.
```

**Example:**

```lua
local int = require("int") -- import module

local x, y = int.new("12", "5")
print(int.fmod(x, y)) -- output: 2
```

---

## operator

use operator to calculate number, support either an [int object](../README.md#int-object), a string, a number.

>modulo operator "%"
some version of Lua are not support (require Lua 5.1 >=)

**Example:**

```lua
local int = require("int") -- import module

local x, y = int.new("12", "5")
print(x % y) -- output: 2
```

**also you can do this:**

```lua
local int = require("int") -- import module

local x = int.new("12")
print(x % "5") -- output: 2 (recommend)
print(x % 5) -- output: 2 (not recommend for large number or very less number of number type)
```

---

## methods

This feature support to call in object.

**This example call function inside object and return self object as input.**

```lua
local int = require("int") -- import module

local x, y = int.new("12", "5")
print(x:fmod(y)) -- output: 2
```

also you can do like this:

**This example call function inside object but didn't return self object as input.**

```lua
local int = require("int") -- import module

local x, y = int.new("12", "5")

-- this works like "print(int.fmod(x, y))"
print(y.fmod(x, y)) -- output: 2

-- this works like "print(int.fmod(x, y))"
print(x.fmod(x, y)) -- output: 2
```

---

[**Home**](../README.md#function--methods)

![end](image-d.png)
