--[[

    |   𝘜𝘓𝘛𝘐𝘔𝘈𝘛𝘌 𝘐𝘕𝘛 (master)
    ||  Module version 156-2 beta!
    module | math and calculate for large data.
    >> basic packagelib
]]

local master = {
    _config = {
        SETINTEGER_PERBLOCK = {
            STABLE = 1,
            BALANCE = 4,
            FULL = 9,

            DEFAULT = 9,
        },
        ACCURACY_LIMIT = {
            -- MASTER --
            MASTER_CALCULATE_DIV = 15,

            -- MEDIA --
            MEDIA_NATURAL_LOGARITHM = 15,
            MEDIA_EXPONENTIAL_FUNCTION = 15,
        },
        --[[
        MAXIMUM_PERTABLE = {
            INTEGER = 9223372036854775806,
            DECIMAL = 9223372036854775808
        },
        ]]
    },
    _version = "156-2"
}

master.convert = function(st, s)
    st, s = tostring(st), s or 1
    local min = math.min
    local result, step = {_size = s}, 0
    local i, i2 = st:match("^(%d+)%.(%d+)$")
    i, i2 = (i or st):reverse(), (i2 or ""):match("^(.-)0*$")
    local len_i, len_i2 = i:len(), i2:len()
    for index = 1, math.max(len_i, len_i2), s do
        step = step + 1
        if index <= len_i then
            result[step] = tonumber(i:sub(index, min(index + s - 1, len_i)):reverse())
        end
        if index <= len_i2 then
            local d = i2:sub(index, min(index + s - 1, len_i2))
            result[1 - step] = tonumber(d .. ("0"):rep(s - d:len()))
            result._dlen = 1 - step
        end
    end
    result._dlen = result._dlen or 1
    return result
end

master.deconvert = function(a, s)
    if type(a) ~= "table" then
        error(("[DECONVERT] attempt to deconvert with a '%s'"):format(type(a)))
    end
    s = a._size or s or 1
    local result, cd = "", false
    for i = (a._dlen or 1), #a do
        local v = a[i]
        if not v then
            error("[DECONVERT] missing value in index = "..i)
        end
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
    for i = x._dlen or 1, 0 do
        x[i] = nil
    end
    x._dlen = 1
    return x
end

master.cfloor = function(x, large) -- Custom a `x` decimal.
    large = - math.abs(large or 0)
    if math.ceil(large / (x._size or 1)) > (x._dlen or 1) - 1 then
        local size = (x._size or 1)
        local endp = math.ceil(large / size)
        for i = x._dlen or 1, endp do
            if i == endp then
                local shift = tostring(x[i]):sub(1, large % size)
                x[i] = tonumber(shift..("0"):rep(size - shift:len()))
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
        if (x._size or 1) ~= (y._size or 1) then error(("BLOCK_SIZE_ISSUE (%s, %s)"):format(x._size or 1, y._size or 1)) end
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
        if (x._size or 1) ~= (y._size or 1) then error(("BLOCK_SIZE_ISSUE (%s, %s)"):format(x._size or 1, y._size or 1)) end
        if #x < #y then
            return true
        elseif #x == #y then
            if (x._dlen or 1) < (y._dlen or 1) then
                return true
            elseif (x._dlen or 1) == (y._dlen or 1) then
                local e = true
                for i = x._dlen or 1, #x do
                    if x[i] > y[i] then
                        return false
                    elseif e and x[i] ~= y[i] then
                        e = false
                    end
                end
                return not e
            end
        end
        return false
    end,
    more = function(x, y) -- block size should be same
        return not master.equation.less(x, y)
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
            local min, max, connext, clean, c_empty, lastcut = math.min, math.max, assets.m_connext, assets.m_clean, assets.c_empty, type(lastcut) == "number" and lastcut or 0
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
            if (a._size or 1) ~= (b._size or 1) then error(("[%s] BLOCK_SIZE_ISSUE (%s, %s)"):format(CODE_NAME or "UNKNOW", a._size or 1, b._size or 1)) end
            if (a._size or 1) > SIZE_MAXIUMUM then error(("[%s] BLOCK_SIZE_OVERFLOW (%s > %s)"):format(CODE_NAME or "UNKNOW", a._size or 1, SIZE_MAXIUMUM)) end
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
    div = function(a, b, s, l) -- _size maxiumum 9 ("l" mean limit of accuracy value and decimal. default is 15) **block size should be same**
        master.calculate._assets.VERIFY(a, b, 9, "DIV")
        local s, b_dlen, max, min = a._size or s or 1, b._dlen, math.max, math.min
        local accuracy = (l or master._config.ACCURACY_LIMIT.MASTER_CALCULATE_DIV) + 2
        local d
        b = master.calculate.mul(b, master.convert("1"..("0"):rep(math.abs(b_dlen - 1)), b._size))
        local function check(n)
            local od = d and (d:match("%.(%d+)$") or ""):match("0*$") or ""
            local dc = d and master.roll.right(master.convert(d, s), od..n) or master.convert(n, s)
            local nc = tonumber(master.deconvert(master.calculate.mul(b, dc))) or 0
            if nc > 1 then
                return 1
            elseif nc < 1 then
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
            local high, low = 9, 0
            for _, i in ipairs(map) do
                if i >= low and i <= high then
                    local code = check(i)
                    if code == 0 then
                        low = max(low, i)
                    elseif code == 1 then
                        high = min(high, i)
                    else
                        return true, i
                    end
                elseif high - low == 1 then
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
            accuracy = fin and accuracy - 1 or accuracy
        until accuracy <= 0
        d = master.convert(d, s)
        if b_dlen < 1 then
            d = master.calculate.mul(d, master.convert("1"..("0"):rep(math.abs(b_dlen - 1))))
        end
        local raw = master.calculate.mul(a, d)
        if -raw._dlen >= (accuracy - 1) // s then
            raw = master.cfloor(raw, (master.deconvert(raw):match("%.(0*)") or ""):len() + (l or 15))
            local i = raw._dlen
            local iu
            repeat
                local v = tostring(raw[i])
                local cu = tonumber(v:match("^(%d-)0*$"):sub(1, -2)) or 0
                local ma = tonumber("1"..("0"):rep(math.min(#tostring(cu), s + 1)))
                if v:match("(%d?)0*$") > "5" or iu then
                    cu, iu = (cu + (iu or 1)) % ma, (cu + (iu or 1)) // ma
                end
                raw[i], i, raw._dlen = cu ~= 0 and cu..("0"):rep(s - tostring(cu):len()) or nil, i + 1, cu == 0 and raw._dlen + 1 or raw._dlen
            until not iu or iu == 0
        end
        return raw
    end,
}

local media = {
    convert = function(n, size) -- automatic setup a table.
        local t = master.convert(type(n) == "string" and n:match("^[+-]?(%d+)%s*$") or n, size)
        t.sign = type(n) == "string" and (n:match("^[+-]") or "+") or math.sign(n) < 1 and "-" or "+"
        return setmetatable(t, master._metatable)
    end,
    deconvert = function(int) -- read table data and convert to the number. *string type*
        local str = master.deconvert(int)
        return (int.sign == "-" and str ~= "0" and "-" or "")..str
    end,

    equal = function(x, y) -- work same `equation.equal` but support sign config.
        return x.sign == y.sign and master.equation.equal(x, y)
    end,
    less = function(x, y) -- work same `equation.less` but support sign config.
        return x.sign == y.sign and master.equation.less(x, y) or x.sign == "-"
    end,
    more = function(x, y) -- work same `equation.more` but support sign config.
        return x.sign == y.sign and master.equation.more(x, y) or y.sign == "-"
    end,

    In = function(x, l) -- Returns the Natural logarithm of `x` in the given base. `l` mean limit of accuracy value
        if tostring(x) <= "0" then
            error("Natural logarithm function return non-positive value.")
        end
        local result = master.convert("0", x._size)
        result.sign = "+"
        -- taylor series of logarithms --
        local X1 = (x - 1) / (x + 1)
        for n = 1, 1 + (2 * (l or master._config.ACCURACY_LIMIT.MEDIA_NATURAL_LOGARITHM)), 2 do
            result = result + ((1 / n) * (X1 ^ n))
        end
        return setmetatable(master.cfloor(result * 2, 15), master._metatable)
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
}

function media.exp(x, l) -- Exponential function
    local result = setmetatable(master.convert("0", x._size), master._metatable)
    result.sign = "+"
    for n = 0, (l or master._config.ACCURACY_LIMIT.MEDIA_EXPONENTIAL_FUNCTION) - 1 do
        result = result + ((x ^ n) / media.fact(n, x._size))
    end
    return master.cfloor(result, l or master._config.ACCURACY_LIMIT.MEDIA_EXPONENTIAL_FUNCTION)
end

do 
    -- Build ENV --
    local _ENV <const> = {
        smul = function(x, y)
            return x.sign == y.sign and "+" or "-"
        end,
        vtype = function(...)
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
            return table.unpack(stack)
        end,
        vpow = function(self, x, y) -- power function `y >= 0`
            if tostring(y % 1) == "0" then
                local st = tostring(y)
                if st == "0" then
                    return media.convert("1", x._size)
                elseif st == "1" then
                    return master.cfloor(x, 15)
                elseif tostring(y % 2) == "0" then
                    local half_power = self:vpow(x, y // 2)
                    return master.cfloor(half_power * half_power, 15)
                end
                local half_power = self:vpow(x, (y - 1) // 2)
                return master.cfloor(x * half_power * half_power, 15)
            end
            return media.exp(y * media.In(x))
        end,
        ifloor = master.floor,

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
            raw.sign = (y.sign == "+" and reg or not reg) and "+" or "-"
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
        __mod = function(x, y)
            x, y = vtype(x, y)
            return x - ((x // y) * y)
        end,
        __pow = function(x, y)
            x, y = vtype(x, y)
            local ysign = y.sign
            y.sign = "+"
            return ysign == "-" and 1 / _ENV:vpow(x, y) or _ENV:vpow(x, y)
        end,
        __idiv = function(x, y)
            x, y = vtype(x, y)
            local raw = ifloor(div(x, y))
            raw.sign = smul(x, y)
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
            return equal(vtype(x, y)) or less(vtype(x, y))
        end,

        -- Misc --
        __tostring = media.deconvert
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

local int = {_advanced = master, _defaultmode = master._config.SETINTEGER_PERBLOCK.DEFAULT}

int.new = function(...) -- (string|number) For only create. alway use default mode! **when calculate block size SHOULD BE SAME**
    local stack = {}
    for _, s in ipairs({...}) do
        table.insert(stack, media.convert(s, int._defaultmode))
    end
    return table.unpack(stack)
end

int.cnew = function(number, mode) -- (string|number, mode) For setting mode **when calculate block size SHOULD BE SAME**
    return media.convert(number, mode and master._config.SETINTEGER_PERBLOCK[mode:upper()] or int._defaultmode)
end

int.abs = function(x) -- Returns the absolute value of `x`.
    x.sign = "+"
    return setmetatable(x, master._metatable)
end

int.In = media.In
int.fact = media.fact
int.exp = media.exp

int.sign = function(x) -- Returns -1 if x < 0, 0 if x == 0, or 1 if x > 0.
    local siz = x._size or 1
    local zeo = media.convert(0, siz)
    local reg, req = media.more(x, zeo), media.equal(x, zeo)
    local t = req and zeo or media.convert(1, siz)
    t.sign = reg or req and "+" or "-"
    return t
end

int.floor = function(x) -- Returns the largest integral value smaller than or equal to `x`.
    return setmetatable(master.floor(x), master._metatable)
end

int.tostring = function(x) -- Returns string
    return media.deconvert(x)
end

int.tonumber = function(x) -- Returns number
    return tonumber(media.deconvert(x))
end

int.fdigitlen = function(x) -- Returns `INTEGER + DECIMAL` len **do not use `#` to get a digit len.**
    return #x + math.abs((x._dlen or 1) - 1)
end

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