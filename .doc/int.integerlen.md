# int.integerlen

![https://github.com/SupTan85/int](cover.png)

## function

> [!NOTE]
**Information:** This function returns the length of integer path.

**Input type:**

- **x** -- [int object](../README.md#int-object) only.

```lua
function int.integerlen(x) -- Returns the length of integer path.
```

It does not include fraction.

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

> [!TIP]
This example call function inside object and return self object as input.

```lua
local int = require("int") -- import module

local x, y = int.new("12.34", "123.4")
print(x:integerlen()) -- output: 2
print(y:integerlen()) -- output: 3
```

also you can do like this:

> [!TIP]
This example call function inside object but didn't return self object as input.

```lua
local int = require("int") -- import module

local x, y = int.new("12.34", "123.4")

-- this works like "int.integerlen(x)"
print(y.integerlen(x)) -- output: 2

-- this works like "int.integerlen(y)"
print(x.integerlen(y)) -- output: 3
```

---

[**Home**](../README.md#function--methods)

![end](image-d.png)
