# variable arguments

![https://github.com/SupTan85/int.lua](.assets/cover.svg)

>[!NOTE]
In Lua, the `...` symbol is called **vararg** (variable arguments). It indicates that a function can take multiple or an indefinite number of arguments. When you're unsure how many arguments a caller will pass, you can use `...` to capture all the passed arguments.

**Example:**

```lua
function sum(...)
  local args = {...}  -- Collect all arguments into a table
  local total = 0
  for i, v in ipairs(args) do
    total = total + v
  end
  return total
end

print(sum(1, 2, 3, 4))  -- Output: 10
```

---

[**function & methods**](../README.md#function--methods)\
[**int.new**](int.new.md)

![end](.assets/bar.svg)
