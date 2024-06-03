--[[

    |   𝘜𝘓𝘛𝘐𝘔𝘈𝘛𝘌 𝘐𝘕𝘛 (master)
    ||  Module version 181 beta!
    module | math and calculate for large data.
    >> basic packagelib
]]

local master = {
    _config = {
        SETINTEGER_PERBLOCK = {
            STABLE = 1,
            BALANCE = 4,
            FASTEST = 9,

            DEFAULT = 9,
        },
        ACCURACY_LIMIT = {
            -- AUTO --

            --[[ MASTER DIVISION | AUTO CONFIG ACCURACY LIMIT >>
                HOW DOSE IT WORK :
                    automatic setting a accuracy limit in division function. *only when there is no self config value*
                    note: this option causes a division speed slow, but very powerful for high accuracy.

                // DISABLE : MASTER_CALCULATE_LIMIT_DIV
                Copy right (C) 2024 SupTan85
            << BUILD-IN >>]]
            MASTER_CALCULATE_DIV_AUTO_CONFIG_ACCURATE = true,

            -- MASTER FUNCTION CONFIG --
            MASTER_CALCULATE_LIMIT_DIV = 15,
            MASTER_DEFAULT_FRACT_LIMIT_DIV = 15,

            -- MEDIA FUNCTION CONFIG --
            MEDIA_NATURAL_LOGARITHM = 15,
            MEDIA_EXPONENTIAL_FUNCTION = 15,
        },

        -- SYSTEM CONFIG ! DO NOT CHANGE ! --
        MAXIMUM_DIGIT_PERTABLE = {
            INTEGER = "9223372036854775806",
            FRACTION = "9223372036854775808"
        },

        MAXIMUM_SIZE_PERBLOCK = 9, -- stable size is 9
        MAXIMUM_LUA_INTEGER = 9223372036854775807 -- math.maxinteger
    },

    _VERSION = "181"
}

master.convert = function(st, s)
    assert(type(st) == "string" or type(st) == "number", ("[CONVERT] attempt to convert with a '%s'"):format(type(st)))
    st, s = tostring(st), s or 1
    assert(not (s <= 0), ("[CONVERT] SETTING_SIZE_ISSUE (%s < 1)"):format(s))
    assert(not (s > master._config.MAXIMUM_SIZE_PERBLOCK), ("[CONVERT] MAXIMUM_SIZE_PERBLOCK (%s > %s)"):format(s, master._config.MAXIMUM_SIZE_PERBLOCK))
    local min = math.min
    local result, step = {_size = s}, 0
    local i, i2 = st:match("^(%d+)%.(%d+)$")
    i, i2 = (i or st):reverse(), (i2 or ""):match("^(.-)0*$")
    local len_i, len_i2 = i:len(), i2:len()
    for index = 1, math.max(len_i, len_i2), s do
        step = step + 1
        if index <= len_i then
            result[step] = tonumber(i:sub(index, min(index + s - 1, len_i)):reverse()) or error("[CONVERT] attempt to convert but got 'nil'")
        end
        if index <= len_i2 then
            local d = i2:sub(index, min(index + s - 1, len_i2))
            result[1 - step] = tonumber(d .. ("0"):rep(s - d:len())) or error("[CONVERT] attempt to convert but got 'nil'")
            result._dlen = 1 - step
        end
    end
    result._dlen = result._dlen or 1
    return result
end

master.deconvert = function(a, s)
    assert(type(a) == "table", ("[DECONVERT] attempt to deconvert with a '%s'"):format(type(a)))
    s = a._size or s or 1
    local result, cd = "", false
    for i = (a._dlen or 1), #a do
        local v = a[i]
        assert(v, "[DECONVERT] missing value in index = "..i)
        v = tostring(v)
        if v:len() ~= s and i ~= #a then
            v = ("0"):rep(s - v:len()) .. v
        end
        if cd == false and i < 1 then
            v = v:match("^(.-)0+$") or v
            v = (v ~= "0" and v) or nil
            if v then
                cd = true
            end
        end
        result = (v and ((i == 0 and v ~= "" and "." .. v .. result) or v .. result)) or result
    end
    return #result > 0 and result or "0"
end

master.floor = function(x) -- Returns the largest integral value smaller than or equal to `x`.
    assert(type(x) == "table", ("[FLOOR] INPUT_TYPE_NOTSUPPORT (%s)"):format(type(x)))
    for i = x._dlen or 1, 0 do
        x[i] = nil
    end
    x._dlen = 1
    return x
end

master.cfloor = function(x, length) -- Custom a `x` fraction.
    assert(type(x) == "table", ("[CFLOOR] INPUT_TYPE_NOTSUPPORT (%s)"):format(type(x)))
    length = math.abs(length or 0)
    if math.ceil(-length / (x._size or 1)) > (x._dlen or 1) - 1 then
        local size = (x._size or 1)
        local endp = math.ceil(-length / size)
        for i = x._dlen or 1, endp do
            if i == endp then
                local shift = tostring(x[i]):sub(1, length % size)
                local hofu = tonumber((shift..("0"):rep(size - shift:len())):match("^0*(.+)"))
                x[i] = hofu
                if not hofu then
                    endp = endp + 1
                end
            else
                x[i] = nil
            end
        end
        x._dlen = endp
    end
    return x
end

master.equation = {
    equal = function(x, y) -- block size should be same
        assert((x._size or 1) == (y._size or 1), ("BLOCK_SIZE_ISSUE (%s, %s)"):format(x._size or 1, y._size or 1))
        if #x == #y and (x._dlen or 1) == (y._dlen or 1) then
            for i = x._dlen or 1, #x do
                if x[i] ~= y[i] then
                    return false
                end
            end
            return true
        end
        return false
    end,
    less = function(x, y) -- block size should be same
        assert((x._size or 1) == (y._size or 1), ("BLOCK_SIZE_ISSUE (%s, %s)"):format(x._size or 1, y._size or 1))
        if #x < #y then
            return true
        elseif #x == #y then
            for i = -#x, -(x._dlen or 1) do
                i = -i
                local vx, vy = x[i] or 0, y[i] or 0
                if vx < vy then
                    return true
                elseif vx > vy then
                    return false
                end
            end
        end
        return false
    end,
    more = function(x, y) -- block size should be same
        return not master.equation.less(x, y) and not master.equation.equal(x, y)
    end
}

master.roll = {
    _assets = {
        m_clean = function(block, index, v, s, rv)
            block = (rv and (block:match("(.-)0+$") or block):reverse() or block):sub(1 + v:len(), -1)
            local st = rv and block..v or v..block
            return tonumber(st..(index < 1 and ("0"):rep(s - v:len() - block:len()) or ""))
        end,

        m_connext = function(block, s, index, nofilter)
            return ("0"):rep(s - #block)..(index < 1 and not nofilter and block:match("(.-)0+$") or block)
        end,

        c_empty = function(atable_int, dlen, dc)
            for i = dlen, dc do
                atable_int[i] = nil
            end
            return atable_int, dc + 1
        end,

        c_process = function(atable_int, to_int, time, lastcut, startfront, nofilter, size, _side)
            local assets = master.roll._assets
            local max, connext, clean, c_empty, lastcut = math.max, assets.m_connext, assets.m_clean, assets.c_empty, type(lastcut) == "number" and lastcut or 0
            local s, dlen, time = atable_int._size or size or 1, atable_int._dlen or 1, time or 1
            to_int = _side and ((to_int and tostring(to_int)) or "0"):reverse() or ((to_int and tostring(to_int)) or "0")
            local to, tolen, len = to_int:rep(math.ceil(s / to_int:len())), to_int:len(), ((_side and not startfront or startfront) and #atable_int) or dlen
            local last, _tolen, i = 0, to_int:len(), -1
            local li, lv, dc
            while true do
                i = i + 1
                local index = _side and len + i or len - i
                local b = (li or lastcut >= 0) and tostring(atable_int[index] or "") or tostring(atable_int[index] or ""):sub(0, -1 + (_side and (index > 0 and lastcut) or (index < 1 and lastcut) or 0))
                local v = (li and (_side and to:sub(li + 1, li + s):reverse() or to:sub(li + 1, li + s))) or (startfront and "")
                if v then
                    v = _side and ((lastcut ~= 0 or last < time) and to:sub(1, max(s - v:len() - (not li and index < 1 and (b:match("(0+)$") or ""):len() or 0), 0)) or ""):reverse() .. v or 
                        v .. ((lastcut ~= 0 or last < time) and to:sub(1, max(s - v:len() - (not li and index > 0 and s - b:len() or 0), 0)) or "")
                else
                    v = connext(b, s, index, nofilter)
                    v = _side and ((lastcut ~= 0 or last < time) and to:sub(1, max(s - v:len() - (index < 1 and s - (b:match("(0+)$") or ""):len() or 0), 0)) or ""):reverse() .. v or 
                        v .. ((lastcut ~= 0 or last < time) and to:sub(1, max(s - v:len() - (index > 0 and s - b:len() or 0), 0)) or "")
                end
                li = ((li or (not startfront and -connext(b, s, index, nofilter):len() or 0)) + v:len()) % _tolen
                local raw = clean(b, index, v, s, _side)
                lv = (lv or (not startfront and -connext(b, s, index, nofilter):len() or 0)) + (raw and v:len() or 0)
                last = (lv or 0) / tolen
                if index < 1 then
                    dc, dlen = tostring(raw):match("^0+$") ~= nil and index or nil, index
                end
                if last >= time then
                    v = _side and v:sub(1 + ((lastcut > 0 and lastcut - 1) or (li + (_tolen * max(0, math.floor(last - time))))), -1) or v:sub(1, -1 - ((lastcut > 0 and lastcut - 1) or (li + (_tolen * max(0, math.floor(last - time))))))
                    atable_int[index] = clean(b, index, v, s, _side)
                    break
                end
                atable_int[index] = raw
            end
            if not nofilter and dc then
                atable_int, dlen = c_empty(atable_int, dlen, dc)
            end
            atable_int._size, atable_int._dlen = atable_int._size or size, dlen
            return atable_int
        end
    },

    left = function(TABLE, INT, LOOPTIME, LASTCUT_OFFSET, IS_FRONT, NOFILTER, BLOCK_SIZE)
        return master.roll._assets.c_process(TABLE, INT, LOOPTIME, LASTCUT_OFFSET, IS_FRONT, NOFILTER, BLOCK_SIZE, true)
    end,

    right = function(TABLE, INT, LOOPTIME, LASTCUT_OFFSET, IS_FRONT, NOFILTER, BLOCK_SIZE)
        return master.roll._assets.c_process(TABLE, INT, LOOPTIME, LASTCUT_OFFSET, IS_FRONT, NOFILTER, BLOCK_SIZE)
    end
}

master.calculate = {
    _assets = {
        VERIFY = function(a, b, SIZE_MAXIUMUM, CODE_NAME)
            assert((a._size or 1) == (b._size or 1), ("[%s] BLOCK_SIZE_ISSUE (%s : %s)"):format(CODE_NAME or "UNKNOW", a._size or 1, b._size or 1))
            assert(not ((a._size or 1) > SIZE_MAXIUMUM), ("[%s] BLOCK_SIZE_OVERFLOW (%s > %s)"):format(CODE_NAME or "UNKNOW", a._size or 1, SIZE_MAXIUMUM))
        end
    },

    add = function(a, b, s)  -- _size maxiumum 18 **block size should be same**
        master.calculate._assets.VERIFY(a, b, 18, "ADD")
        local result = {_size = a._size or s or 1}
        local s, c, d = math.floor(10 ^ (result._size)), false, false
        for i = math.min(a._dlen or 1, b._dlen or 1), math.max(#a, #b) do
            local block_result = (a[i] or 0) + (b[i] or 0)
            local next = block_result // s
            result[i + 1] = (next ~= 0 and next) or nil
            if i >= 1 or c == true or block_result ~= 0 then
                result[i], c = (block_result % s) + (result[i] or 0), true
                if d == false then
                    result._dlen = (i < 1 and i) or 1
                    d = true
                end
            end
        end
        return result
    end,
    sub = function(a, b, s)  -- _size maxiumum 18 (to use this function "a >= b" else result will been wrong!) **block size should be same**
        master.calculate._assets.VERIFY(a, b, 18, "SUB")
        local result = {_size = a._size or s or 1}
        local s, d = math.floor(10 ^ (result._size)), false
        local stack
        for i = math.min(a._dlen or 1, b._dlen or 1), math.max(#a, #b) do
            local block_result = (a[i] or 0) - (b[i] or 0)
            local callback = (block_result % s) - (result[i] or 0)
            local block_data = callback % s
            result[i] = block_data
            if not d and block_data ~= 0 then
                result._dlen, d = (i < 1 and i) or 1, true
            end
            stack = (block_data == 0 and ((stack and {stack[1], i}) or {i, i})) or nil
            result[i + 1] = (callback < 0 and (((callback % s) // s) + (((callback % s) ~= 0 and 1) or 0))) or nil
            result[i + 1] = (block_result < 0 and (result[i + 1] or 0) + (((block_result % s) // s) + (((block_result % s) ~= 0 and 1) or 0))) or result[i + 1]
        end
        if stack then
            for i = stack[1], stack[2] do
                result[i] = nil
            end
        end
        result._dlen = result._dlen or 1
        if #result == 0 then
            result[1] = 0
        end
        return result
    end,
    mul = function(a, b, s) -- _size maxiumum 9 **block size should be same**
        master.calculate._assets.VERIFY(a, b, 9, "MUL")
        local result = {_size = a._size or s or 1}
        local s, op = math.floor(10 ^ (result._size)), 1
        local cd
        for i = a._dlen or 1, #a do
            local block_a = a[i]
            for i2 = b._dlen or 1, #b do
                local block_b = b[i2]
                local calcul = block_a * block_b
                local offset = i + i2 - 1
                local block_data = (calcul + (result[offset] or 0))
                local next = block_data // s
                block_data = block_data % s
                cd = (cd or block_data ~= 0) and true or nil
                result[offset] = (offset >= 1 or cd) and block_data or nil
                op = result[offset] and math.min(op, offset) or op
                result[offset + 1] = (next ~= 0 and (next + (result[offset + 1] or 0))) or result[offset + 1]
            end
        end
        for i = -#result, -2 do
            if result[-i] == 0 then
                result[-i] = nil
            else
                break
            end
        end
        result._dlen = op
        return result
    end,
    div = function(a, b, s, f, l) -- _size maxiumum 9 ("f" for maxiumum of fraction, "l" for set limit of accuracy value and fraction.) **block size should be same**
        master.calculate._assets.VERIFY(a, b, 9, "DIV")
        local s, b_dlen, f = a._size or s or 1, b._dlen or 1, (f or master._config.ACCURACY_LIMIT.MASTER_DEFAULT_FRACT_LIMIT_DIV) + 1
        local auto_acc, mul = not l and master._config.ACCURACY_LIMIT.MASTER_CALCULATE_DIV_AUTO_CONFIG_ACCURATE, master.calculate.mul
        local convert = master.convert
        local accuracy, d
        if auto_acc then
            local function HF(x)
                return (s - tostring(x[#x]):len()) + ((x._dlen or 1) < 1 and s - tostring(x[x._dlen] or ""):len() or 0)
            end
            local AN, BN = (#a + math.abs((a._dlen or 1) - 1)) * s, (#b + math.abs((b._dlen or 1) - 1)) * s
            local NV = AN > BN
            if (NV and AN or BN) < master._config.MAXIMUM_LUA_INTEGER then
                accuracy, auto_acc = (NV and AN or BN) - HF(NV and a or b) + f, false
            else
                local AS, BS = master.calculate.add(convert(#a, s), convert(math.abs((a._dlen or 1) - 1), s)), master.calculate.add(convert(#b, s), convert(math.abs(b_dlen - 1), s))
                local MORE = master.equation.more(AS, BS)
                accuracy = master.calculate.add(master.calculate.sub(mul((MORE and AS or BS), convert(s, s)), convert(HF(MORE and a or b), s)), convert(f, s))
            end
        else
            accuracy = (l or master._config.ACCURACY_LIMIT.MASTER_CALCULATE_LIMIT_DIV) + 1
        end
        b = mul(b, convert("1"..("0"):rep(math.abs(b_dlen - 1)), b._size))
        local function check(n)
            local od = d and (d:match("%.(%d+)$") or ""):match("0*$") or ""
            local dc = d and master.roll.right(convert(d, s), od..n) or convert(n, s)
            local nc = mul(b, dc)
            if master.equation.more(nc, convert(1, s)) then
                return 1
            elseif master.equation.less(nc, convert(1, s)) then
                return 0
            end
        end
        local function calcu(c)
            local map
            if c then
                local ceil, insert = math.ceil, table.insert
                map = {}
                for i = 0, 9 do
                    insert(map, (i % 2 == 0 and (c - ceil(i / 2)) or (c + ceil(i / 2))) % 10)
                end
            else
                map = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
            end
            local high, low, code
            for _, i in ipairs(map) do
                if i >= (low or 0) and i <= (high or 9) then
                    code = i == 0 and 0 or check(i)
                    if code == 0 then
                        low = i
                    elseif code == 1 then
                        high = i
                    else
                        return true, i
                    end
                elseif high and low and high - low == 1 then
                    break
                end
            end
            return false, low
        end
        local lastpoint, fin, mark
        repeat
            local dv, lp = calcu(lastpoint)
            d, lastpoint = d and d..(mark and lp or "."..lp) or tostring(lp), lp
            mark = mark or (d:match("%.") and true)
            if dv then
                break
            end
            fin = fin or (d or ""):match("^0*%.?0*$") == nil
            if fin then
                if auto_acc then
                    local one = convert(1, s)
                    if master.equation.less(accuracy, one) then
                        break
                    end
                    accuracy = master.calculate.sub(accuracy, one) or accuracy
                else
                    accuracy = (accuracy - 1 or accuracy)
                end
            end
        until auto_acc and master.equation.less(accuracy, convert(0, s)) or not auto_acc and accuracy < 0
        d = convert(d, s)
        if b_dlen < 1 then
            d = mul(d, convert("1"..("0"):rep(math.abs(b_dlen - 1)), s))
        end
        local raw = mul(a, d)
        if -raw._dlen >= f // s then
            raw = master.cfloor(raw, (master.deconvert(raw):match("%.(0*)") or ""):len() + f)
            local i, iu, dx, U
            repeat
                local v = raw[i or raw._dlen]
                local rv
                if i then
                    U = U or math.floor(10 ^ s)
                    rv = (v or 0) + iu
                    rv, iu = tostring(rv % U), rv // U
                else
                    for v in tostring(v or ""):match("(%d-)0*$"):reverse():gmatch(".") do
                        v = tonumber(v)
                        if iu then
                            v = v + iu
                            iu, v = v // 10, v % 10
                        else
                            iu, v = v > 5 and 1 or 0, 0
                        end
                        rv = rv and v..rv or tostring(v)
                    end
                end
                if not rv then
                    rv, iu = tostring(iu), nil
                end
                rv = tonumber((rv..(not i and raw._dlen < 1 and ("0"):rep(s - rv:len()) or "")):match("^0*(.+)"))
                dx = dx or rv ~= 0
                raw[i or raw._dlen], i = dx and rv, (i or raw._dlen) + 1
                raw._dlen = raw[i - 1] and raw._dlen or i
            until not iu or iu == 0
        end
        return raw
    end,
}

local media = {
    assets = {},
    convert = function(n, size) -- automatic setup a table.
        local n_type = type(n)
        assert(n_type == "string" or n_type == "number", ("[CONVERT] INPUT_TYPE_NOTSUPPORT (%s)"):format(n_type))
        if tostring(n):find("e") then
            n, n_type = tostring(n), "string"
            local es, fs = tonumber(n:match("^%s*[+-]?%d+%.?%d*e([+-]?%d+)%s*$")), n:match("^%s*([+-]?%d+%.?%d*)e[+-]?%d+%s*$")
            if es and fs then
                if es ~= 0 then
                    local loc = (fs:find("%.") or (fs:len() + 1)) - 1
                    local dot, fs_sign = loc + es, fs:match("^%s*([+-])") or "+"
                    local f, b
                    fs = fs:gsub("%.", ""):gsub("[+-]", "")
                    if dot < 0 then
                        f, b = "0", ("0"):rep(-dot)..fs
                    else
                        fs = fs..("0"):rep(dot - fs:len())
                        f, b = fs:sub(1, dot):match("^0*(.*)$"), fs:sub(dot + 1, -1):match("^(.-)0*$")
                    end
                    fs = fs_sign..(f == "" and "0" or f)..(b ~= "" and "."..b or "")
                end
                local t = master.convert(fs:match("^%s*[+-]?(%d+%.?%d*)%s*$"), size)
                t.sign = fs:match("^%s*([+-]?)") or "+"
                return setmetatable(t, master._metatable)
            end
            error(("malformed number near '%s'"):format(n:match("^%s*(.-)%s*$")))
        end
        local t = master.convert(n_type == "string" and n:match("^%s*[+-]?(%d+%.?%d*)%s*$") or math.abs(tonumber(n) or error(("[CONVERT] MALFORMED_NUMBER '%s'"):format(n))), size)
        t.sign = n_type == "string" and (n:match("^%s*([+-])") or "+") or math.sign(n) < 0 and "-" or "+"
        return setmetatable(t, master._metatable)
    end,
    deconvert = function(int) -- read table data and convert to the number. *string type*
        local str = master.deconvert(int)
        return (int.sign == "-" and str ~= "0" and "-" or "")..str
    end,

    --[[
    FSZsign = function(...) -- set value of `_sign` to `+` when number is zero.
        local nums = {...}
        for i, x in ipairs(nums) do
            nums[i].sign = (x.sign == "-" and #x <= 1 and (x._dlen or 1) == 1 and "+") or x.sign or "+"
        end
        return table.unpack(nums)
    end,
    ]]

    equal = function(x, y) -- work same `equation.equal` but support sign config.
        return x.sign == y.sign and master.equation.equal(x, y)
    end,
    less = function(x, y) -- work same `equation.less` but support sign config.
        local nox = x.sign ~= y.sign
        return nox and y.sign == "+" or (not nox and master.equation.less(x, y))
    end,
    more = function(x, y) -- work same `equation.more` but support sign config.
        local nox = x.sign ~= y.sign
        return nox and y.sign == "-" or (not nox and master.equation.more(x, y))
    end,

    abs = function(x) -- Returns the absolute value of `x`.
        assert(type(x) == "table", ("[ABS] INPUT_TYPE_NOTSUPPORT (%s)"):format(type(x)))
        x.sign = "+"
        return setmetatable(x, master._metatable)
    end,

    fact = function(n, s) -- Factorial function
        local result
        if type(n) == "table" then
            result = setmetatable(master.convert("1", n._size), master._metatable)
            result.sign, n.sign = n.sign or "+", "+"
        else
            result = setmetatable(master.convert("1", s or 1), master._metatable)
            result.sign = "+"
        end
        while tostring(n) > "0" do
            result, n = result * n, n - 1
        end
        return result
    end,

    floor = function(x) -- Returns the largest integral value smaller than or equal to `x`.
        return setmetatable(master.floor(x), master._metatable)
    end,
    cfloor = function(x, length) -- Custom a `x` fraction.
        return setmetatable(master.cfloor(x, length), master._metatable)
    end,

    ceil = function(x) -- Returns the smallest integral value larger than or equal to `x`.
        if (x._dlen or 1) < 1 then
            return setmetatable(master.floor(x), master._metatable) + 1
        end
        return setmetatable(x, master._metatable)
    end
}

function media.integerlen(x) -- Returns `INTEGER` length.
    local le = #x
    return (tostring(x[le] or ""):len() + ((media.convert(le) - 1):max(0) * x._size)):max(1)
end

function media.fractionlen(x) -- Returns `FRACTION` length.
    local le = math.abs((x._dlen or 1) - 1)
    return tostring(x[le] or ""):len() + ((media.convert(le) - 1):max(0) * x._size)
end

function media.fdigitlen(x) -- Returns `INTEGER + FRACTION` length.
    return media.integerlen(x) + media.fractionlen(x)
end

function media.tostring(x) -- Deconvert table to string.
    return media.deconvert(x)
end

function media.tonumber(x) -- Deconvert table to number. *not recommend*
    return tonumber(media.deconvert(x))
end

function media.ntype(...) -- This function make table can mix a number and string. *return table*
    local stack, v = {}, {...}
    local SOFT, INTEGER = {table = 1}, master._config.SETINTEGER_PERBLOCK.DEFAULT
    table.sort(v, function(a, b) return (SOFT[type(a)] or 0) > (SOFT[type(b)] or 0) end)
    for _, s in ipairs(v) do
        if type(s) == "table" then
            INTEGER = s._size or INTEGER
        else
            break
        end
    end
    for i, s in ipairs({...}) do
        local ty = type(s)
        if ty == "string" or ty =="number" then
            stack[i] = media.convert(s, INTEGER)
        elseif ty == "table" then
            stack[i] = s
        else
            error(("[VTYPE] attempt to perform arithmetic on a (%s) value"):format(ty))
        end
    end
    return stack
end

function media.vtype(...) -- This function make table can mix a number and string.
    return table.unpack(media.ntype(...))
end

function media.sign(x) -- Returns -1 if x < 0, 0 if x == 0, or 1 if x > 0.
    local siz = x._size or 1
    local zeo = media.convert(0, siz)
    local reg, req = media.more(x, zeo), media.equal(x, zeo)
    local t = req and zeo or media.convert(1, siz)
    t.sign = reg or req and "+" or "-"
    return t
end

function media.max(x, ...) -- Returns the argument with the maximum value, according to the Lua operator `<`.
    local result
    for _, x in ipairs(media.ntype(x, ...)) do
        result = result and (media.more(result, x) and result) or x
    end
    return result and setmetatable(result, master._metatable)
end

function media.min(x, ...) -- Returns the argument with the minimum value, according to the Lua operator `>`.
    local result
    for _, x in ipairs(media.ntype(x, ...)) do
        result = result and (media.less(result, x) and result) or x
    end
    return result and setmetatable(result, master._metatable)
end

function media.In(x, l) -- Returns the Natural logarithm of `x` in the given base. `l` mean limit of accuracy value
    x = media.vtype(x) or error("[IN] INPUT_VOID")
    if tostring(x) <= "0" then
        if tostring(x) == "0" then
            error("[IN] Natural logarithm function return inf-positive value.")
        end
        error("[IN] Natural logarithm function return non-positive value.")
    end
    local result = master.convert(0, x._size)
    result.sign = "+"
    -- taylor series of logarithms --
    local X1 = (x - 1) / (x + 1)
    for n = 1, 1 + (2 * (l or master._config.ACCURACY_LIMIT.MEDIA_NATURAL_LOGARITHM)), 2 do
        result = result + ((1 / n) * (X1 ^ n))
    end
    return setmetatable(master.cfloor(result * 2, 15), master._metatable)
end

function media.exp(x, l) -- Exponential function
    x = media.vtype(x) or error("[EXP] INPUT_VOID")
    local result = setmetatable(master.convert(0, x._size), master._metatable)
    result.sign = "+"
    for n = 0, (l or master._config.ACCURACY_LIMIT.MEDIA_EXPONENTIAL_FUNCTION) - 1 do
        result = result + ((x ^ n) / media.fact(n, x._size))
    end
    return master.cfloor(result, l or master._config.ACCURACY_LIMIT.MEDIA_EXPONENTIAL_FUNCTION)
end

function media.modf(x) -- Returns the integral part of `x` and the fractional part of `x`.
    x = media.vtype(x)
    local frac = {sign = x.sign or "+", _dlen = x._dlen or 1, _size = x._size}
    for i = frac._dlen, 0 do
        frac[i] = x[i]
    end
    frac[1] = 0
    return setmetatable(master.floor(x), master._metatable), setmetatable(frac, master._metatable)
end

function media.fmod(x, y) -- Returns the remainder of the division of `x` by `y` that rounds the quotient towards zero.
    x, y = media.vtype(x, y)
    local r = x - ((x // y) * y)
    return r == y and media.convert(0, x._size) or r
end

function media.assets.vpow(self, x, y) -- pow function assets. `y >= 0`
    y = tostring(y) >= "0" and y or error(("[VPOW] FUNCTION_NOT_SUPPORT (%s)"):format(tostring(y)))
    if tostring(x) == "0" then
        return x
    end
    if tostring(y % 1) == "0" then
        local st = tostring(y)
        if st == "0" then
            return media.convert(1, x._size)
        elseif st == "1" then
            return media.cfloor(x, 15)
        elseif tostring(y % 2) == "0" then
            local half_power = self:vpow(x, y // 2)
            return media.cfloor(half_power * half_power, 15)
        end
        local half_power = self:vpow(x, (y - 1) // 2)
        return media.cfloor(x * half_power * half_power, 15)
    end
    return media.exp(y * media.In(x))
end

function media.pow(x, y) -- Returns `x ^ y`.
    x, y = media.vtype(x, y)
    local ysign = y.sign
    y.sign = "+"
    return ysign == "-" and 1 / media.assets:vpow(x, y) or media.assets:vpow(x, y)
end

local mediaobj = {
    tostring = media.tostring,
    tonumber = media.tonumber,

    equal = function(x, y) -- equal `==`. *this function made for other types*
        return media.equal(media.vtype(x, y))
    end,
    less = function(x, y) -- less `<`. *this function made for other types*
        return media.less(media.vtype(x, y))
    end,
    more = function(x, y) -- more `>`. *this function made for other types*
        return media.more(media.vtype(x, y))
    end,

    eqless = function(x, y) -- equal or less `<=`. *this function made for other types*
        x, y = media.vtype(x, y)
        return media.equal(x, y) or media.less(x, y)
    end,
    eqmore = function(x, y) -- equal or more `>=`. *this function made for other types*
        x, y = media.vtype(x, y)
        return media.equal(x, y) or media.more(x, y)
    end,

    abs = media.abs,

    sign = media.sign,
    max = media.max,
    min = media.min,

    fact = media.fact,
    In = media.In,
    exp = media.exp,
    pow = media.pow,

    floor = media.floor,
    cfloor = media.cfloor,

    ceil = media.ceil,
    modf = media.modf,
    fmod = media.fmod,

    integerlen = media.integerlen,
    fractionlen = media.fractionlen,
    fdigitlen = media.fdigitlen,
}

do
    -- Build ENV --
    local _ENV = {
        smul = function(x, y)
            local x_sign, y_sign = x.sign or "+", y.sign or "+"
            return (x_sign:len() == 1 and x_sign or "+") == (y_sign:len() == 1 and y_sign or "+") and "+" or "-"
        end,
        vtype = media.vtype,
        ifloor = master.floor,
        modf = media.modf,

        add = master.calculate.add,
        sub = master.calculate.sub,
        mul = master.calculate.mul,
        div = master.calculate.div,

        equal = media.equal,
        less = media.less,
        more = media.more,
        
        setmetatable = setmetatable
    }

    -- Build metatable --
    master._metatable = {

        -- Calculation operators --
        __add = function(x, y)
            x, y = vtype(x, y)
            if x.sign == y.sign then
                local raw = add(x, y)
                raw.sign = x.sign or "+"
                return setmetatable(raw, master._metatable)
            end
            local reg = more(x, y)
            local raw = sub(reg and x or y, reg and y or x)
            raw.sign = (reg and x or y).sign or "+"
            return setmetatable(raw, master._metatable)
        end,
        __sub = function (x, y)
            x, y = vtype(x, y)
            local reg = more(x, y)
            local raw = (x.sign == y.sign) and sub(reg and x or y, reg and y or x) or add(x, y)
            raw.sign = ((y.sign == "+" and reg) or (y.sign == "-" and not reg)) and "+" or "-"
            return setmetatable(raw, master._metatable)
        end,
        __mul = function(x, y)
            x, y = vtype(x, y)
            local raw = mul(x, y)
            raw.sign = smul(x, y)
            return setmetatable(raw, master._metatable)
        end,
        __div = function(x, y)
            x, y = vtype(x, y)
            local raw = div(x, y)
            raw.sign = smul(x, y)
            return setmetatable(raw, master._metatable)
        end,
        __mod = media.fmod,
        __pow = media.pow,
        __idiv = function(x, y)
            x, y = vtype(x, y)
            local d, f = modf(div(x, y))
            local sign, raw = smul(x, y)
            raw = sign == "-" and more(f, vtype(0)) and add(d, vtype(1)) or d
            raw.sign = sign
            return setmetatable(raw, master._metatable)
        end,

        -- Equation operators --
        __eq = function(x, y)
            return equal(vtype(x, y))
        end,
        __lt = function(x, y)
            return less(vtype(x, y))
        end,
        __le = function(x, y)
            x, y = vtype(x, y)
            return equal(x, y) or less(x, y)
        end,

        -- Misc --
        __tostring = media.deconvert,
        __mode = "v",
        __name = "INT OBJECT",

        -- Index --
        __index = mediaobj,
    }
end

math.sign = function(number) -- Returns -1 if x < 0, 0 if x == 0, or 1 if x > 0.
    if number > 0 then
        return 1
    elseif number < 0 then
        return -1
    end
    return 0
end

local int = setmetatable({

    _defaultsize = master._config.SETINTEGER_PERBLOCK.DEFAULT,
    _VERSION = master._VERSION
}, {
    -- metatable --
    __index = mediaobj
})

int.new = function(...) -- (string|number) For only create. alway use default size! **BLOCK SIZE SHOULD BE SAME WHEN CALCULATE**
    local stack = {}
    for _, s in ipairs({...}) do
        table.insert(stack, media.convert(s, int._defaultsize))
    end
    return table.unpack(stack)
end

int.cnew = function(number, size) -- (number:string|number, size:string|number) For setting a size per block. **BLOCK SIZE SHOULD BE SAME WHEN CALCULATE**
    return media.convert(number, size and (tonumber(size) or master._config.SETINTEGER_PERBLOCK[size:upper()]) or int._defaultsize)
end

int.maxinteger = master._config.MAXIMUM_DIGIT_PERTABLE.INTEGER
int.maxfraction = master._config.MAXIMUM_DIGIT_PERTABLE.FRACTION

-- print(("MODULE LOADED\nMEMORY USAGE: %.0d B (%s KB)"):format(collectgarbage("count") * 1024, collectgarbage("count")))
return int
--[[

██╗░░░██╗████████╗██╗███╗░░░███╗░█████╗░████████╗███████╗  ██╗███╗░░██╗████████╗
██║░░░██║╚══██╔══╝██║████╗░████║██╔══██╗╚══██╔══╝██╔════╝  ██║████╗░██║╚══██╔══╝
██║░░░██║░░░██║░░░██║██╔████╔██║███████║░░░██║░░░█████╗░░  ██║██╔██╗██║░░░██║░░░
██║░░░██║░░░██║░░░██║██║╚██╔╝██║██╔══██║░░░██║░░░██╔══╝░░  ██║██║╚████║░░░██║░░░
╚██████╔╝░░░██║░░░██║██║░╚═╝░██║██║░░██║░░░██║░░░███████╗  ██║██║░╚███║░░░██║░░░
░╚═════╝░░░░╚═╝░░░╚═╝╚═╝░░░░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝  ╚═╝╚═╝░░╚══╝░░░╚═╝░░░

    █▀▀ █▀█ █▀█ █▄█ █▀█ █ █▀▀ █░█ ▀█▀   ▄▀ █▀▀ ▀▄   ▀█ █▀█ ▀█ █░█   █▀ █░█ █▀█ ▀█▀ ▄▀█ █▄░█ ░
    █▄▄ █▄█ █▀▀ ░█░ █▀▄ █ █▄█ █▀█ ░█░   ▀▄ █▄▄ ▄▀   █▄ █▄█ █▄ ▀▀█   ▄█ █▄█ █▀▀ ░█░ █▀█ █░▀█ ▄

    ▄▀█ █░░ █░░   █▀█ █ █▀▀ █░█ ▀█▀ █▀   █▀█ █▀▀ █▀ █▀▀ █▀█ █░█ █▀▀ █▀▄ █
    █▀█ █▄▄ █▄▄   █▀▄ █ █▄█ █▀█ ░█░ ▄█   █▀▄ ██▄ ▄█ ██▄ █▀▄ ▀▄▀ ██▄ █▄▀ ▄

]]