# int.ceil

![https://github.com/SupTan85/int.lua](.assets/cover.svg)

## Syntax & Usage

> [!NOTE]
This function returns the smallest integer value of the given number.\
**When inputting negative numbers, the function will behave oppositely (ceil -> floor).**

```lua
function int.ceil(x) -- Returns the smallest integer greater than or equal to `x`.
```

| Parameter | Type                                  | Description                                 |
| :-------: | :------------------------------------ | :------------------------------------------ |
|     x     | [**int object**](type.intobj.md) only | Required. The value to be processed.        |

**Return Value:**

1. [**int object**](type.intobj.md)

**Example:**

```lua
local int = require("int") -- import module

local x, y = int.new("-12.2", "12.3456")
print(int.ceil(x)) -- output: -12
print(int.ceil(y)) -- output: 13
```

---

## methods

This feature lets you to call functions on an object.

```lua
local int = require("int") -- import module

local x, y = int.new("-12.2", "12.3456")
print(x:ceil()) -- output: -12
print(y:ceil()) -- output: 13
```

> [!TIP]
In this example, a function inside the object is called and returns the object itself as the input.

also you can do like this:

```lua
local int = require("int") -- import module

local x, y = int.new("-12.2", "12.3456")

-- this works like "print(int.ceil(x))"
print(y.ceil(x)) -- output: -12

-- this works like "print(int.ceil(y))"
print(x.ceil(y, 2)) -- output: 13
```

> [!TIP]
In this example, a function inside the object is called but a different object is used as the input.

---

[**function & methods**](../README.md#function--methods)

![end](.assets/bar.svg)
