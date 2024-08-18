# int.integerlen

![https://github.com/SupTan85/int](cover.png)

## function

This function counts and return length of integer.\
**Note: input [int object](../README.md#int-object) only.**

```lua
function media.integerlen(x) -- Returns length of `INTEGER`.
```

It does not include fraction.

---

**Example:**

```lua
local int = require("int") -- import module

local x, y = int.new("12.34", "123.4")
print(int.integerlen(x)) -- output: 2
print(int.integerlen(y)) -- output: 3
```

---

## methods

This feature support to call in object.

**This example call function inside object and return self object as input.**

```lua
local int = require("int") -- import module

local x, y = int.new("12.34", "123.4")
print(x:integerlen()) -- output: 2
print(y:integerlen()) -- output: 3
```

also you can do like this:

**This example call function inside object but didn't return self object as input.**

```lua
local int = require("int") -- import module

local x, y = int.new("12.34", "123.4")
print(x.integerlen(y)) -- output: 3
```

---

[**Home**](../README.md#function--methods)

![end](image-d.png)
