# table

![https://github.com/SupTan85/int.lua](.assets/cover.png)

>[!NOTE]
In Lua, a **table** is the only built-in data structure and is highly flexible. It can be used to represent arrays, dictionaries, lists, sets, and more. Tables in Lua are associative arrays, meaning they can hold values with both integer and non-integer (key-value) indices.

**Example:**

```lua
-- Creating a table
local mytable = {1, 2, 3, "apple"}

-- Accessing table values
print(mytable[1])  -- Output: 1 (Lua arrays start at index 1)
print(mytable[4])  -- Output: apple

-- Adding a new key-value pair
mytable["fruit"] = "banana"

-- Accessing by key
print(mytable["fruit"])  -- Output: banana
```

---

>[!TIP]
You can use the `pairs` function to loop through all key-value pairs.

**Example for iterating over a table:**

```lua
for key, value in pairs(person) do
  print(key, value)
end
```

---

[**home**](../README.md)

![end](.assets/bar.png)
