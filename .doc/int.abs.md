# int.abs

![https://github.com/SupTan85/int.lua](.assets/cover.svg)

## Syntax & Usage

> [!NOTE]
This function ensures the sign of a number is always positive by returning its magnitude.

```lua
function int.abs(x, self_changed) -- Returns the absolute value of `x`.
```

|  Parameter   | Type                                  | Description                                                                                                  |
| :----------: | :------------------------------------ | :----------------------------------------------------------------------------------------------------------- |
|      x       | [**int object**](type.intobj.md) only | Required. The value to calculate the absolute value of.                                                      |
| self_changed | boolean (default: false)              | Optional. Enable if you want to change the value in this object only.<br>(disable copy object for optimization) |

**Return Value:**

1. [**int object**](type.intobj.md)

**Example:**

```lua
local int = require("int") -- import module

local x, y = int.abs("-3.14", "12.3456")
print(int.abs(x)) -- output: 3.14
print(int.abs(y)) -- output: 12.3456
```

---

## Methods

This feature lets you to call functions on an object.

```lua
local int = require("int") -- import module

local x, y = int.new("-12.2", "12.3456")
print(x:abs()) -- output: 12.2
print(y:abs()) -- output: 12.3456
```

> [!TIP]
In this example, a function inside the object is called and returns the object itself as the input.

also you can do like this:

```lua
local int = require("int") -- import module

local x, y = int.new("-12.2", "12.3456")

-- this works like "print(int.abs(x))"
print(y.abs(x)) -- output: 12.2

-- this works like "print(int.abs(y))"
print(x.abs(y)) -- output: 12.3456
```

> [!TIP]
In this example, a function inside the object is called but a different object is used as the input.

---

[**function & methods**](../README.md#function--methods)

![end](.assets/bar.svg)
