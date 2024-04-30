--[[

    |   𝘜𝘓𝘛𝘐𝘔𝘈𝘛𝘌 𝘐𝘕𝘛 (master)
    ||  Module version 142 beta!
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
        --[[
        MAXIMUM_PERTABLE = {
            INTEGER = 9223372036854775806,
            DECIMAL = 9223372036854775808
        },
        ]]
    },
    _version = "142"
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
        error(("[deconvert] attempt to deconvert with a '%s'"):format(type(a)))
    end
    s = a._size or s or 1
    local result, cd = "", false
    for i = (a._dlen or 1), #a do
        local v = a[i]
        if not v then
            error("[deconvert] missing value in index = "..i)
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

master.equation = {
    equal = function(a, b) -- block size should be same
        if (a._size or 1) ~= (b._size or 1) then error(("BLOCK_SIZE_ISSUE (%s, %s)"):format(a._size or 1, b._size or 1)) end
        if #a == #b and (a._dlen or 1) == (b._dlen or 1) then
            for i = a._dlen or 1, #a do
                if a[i] ~= b[i] then
                    return false
                end
            end
            return true
        end
        return false
    end,
    less = function(a, b) -- block size should be same
        if (a._size or 1) ~= (b._size or 1) then error(("BLOCK_SIZE_ISSUE (%s, %s)"):format(a._size or 1, b._size or 1)) end
        if #a < #b then
            return true
        elseif #a == #b then
            if (a._dlen or 1) < (b._dlen or 1) then
                return true
            elseif (a._dlen or 1) == (b._dlen or 1) then
                local e = true
                for i = a._dlen or 1, #a do
                    if a[i] > b[i] then
                        return false
                    elseif e and a[i] ~= b[i] then
                        e = false
                    end
                end
                return not e
            end
        end
        return false
    end,
    more = function(a, b) -- block size should be same
        return not master.equation.less(a, b)
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
            for i = math.abs(dc - 1), math.abs(dlen) do
                atable_int[-i] = nil
            end
            return atable_int
        end,

        c_process = function(atable_int, to_int, time, lastcut, startfront, nofilter, size, _side)
            local assets = master.roll._assets
            local min, max, connext, clean, c_empty, lastcut = math.min, math.max, assets.m_connext, assets.m_clean, assets.c_empty, type(lastcut) == "number" and lastcut or 0
            local s, dlen, time = atable_int._size or size or 1, atable_int._dlen or 1, time or 1
            to_int = _side and ((to_int and tostring(to_int)) or "0"):reverse() or ((to_int and tostring(to_int)) or "0")
            local to, tolen, len = to_int:rep(math.ceil(s / to_int:len())), to_int:len(), ((_side and not startfront or startfront) and #atable_int) or dlen
            local last, _tolen, i, dc = 0, to_int:len(), -1, 1
            local li, lv, db
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
                    db = db or tostring(raw):match("^0+$") ~= nil
                    dc, dlen = not db and min(index, dc) or dc, index
                end
                if last >= time then
                    v = _side and v:sub(1 + ((lastcut > 0 and lastcut - 1) or (li + (_tolen * max(0, math.floor(last - time))))), -1) or v:sub(1, -1 - ((lastcut > 0 and lastcut - 1) or (li + (_tolen * max(0, math.floor(last - time))))))
                    atable_int[index] = clean(b, index, v, s, _side)
                    break
                end
                atable_int[index] = raw
            end
            if not nofilter then
                atable_int = c_empty(atable_int, dlen, dc)
            end
            atable_int._size, atable_int._dlen = atable_int._size or size, dc
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
        local s, d = math.floor(10 ^ (result._size)), 0
        local stack, ad, bd, cd
        for i = a._dlen or 1, #a do
            local block_a = a[i]
            ad = ad or (block_a ~= 0 and i)
            for i2 = b._dlen or 1, #b do
                local block_b = b[i2]
                bd = bd or (block_b ~= 0 and i2)
                local calcul = block_a * block_b
                local offset = i + i2 - 1
                local block_data = (calcul + (result[offset] or 0))
                local next = block_data // s
                block_data = block_data % s
                cd = (cd or block_data ~= 0) and true or nil
                result[offset] = (offset >= 1 or cd) and block_data or nil
                d = result[offset] == nil and d + 1 or d
                stack = ((block_data == 0 and offset >= 1) and ((stack and { stack[1], offset }) or { offset, offset })) or nil
                result[offset + 1] = (next ~= 0 and (next + (result[offset + 1] or 0))) or result[offset + 1]
            end
        end
        if stack then
            for i = stack[1], stack[2] do
                result[i] = nil
            end
        end
        if #result == 0 then
            result[1] = 0
        end
        result._dlen = (ad or 1) + (bd or 1) - 1 + d
        return result
    end,
    div = function(a, b, s, l) -- _size maxiumum 9 ("l" mean limit of accuracy value and decimal. default is 14) **block size should be same**
        master.calculate._assets.VERIFY(a, b, 9, "DIV")
        local s, max, min = a._size or s or 1, math.max, math.min
        local accuracy = l or 14
        local d
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
                local ceil <const>, insert <const> = math.ceil, table.insert
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
        local lastpoint, mark
        for _ = 1, accuracy + 1 do
            local dv, lp = calcu(lastpoint)
            d, lastpoint, mark = d and ("%s%s"):format(d, mark and lp or "."..lp) or tostring(lp), lp, mark or #(d or "") > 0 and true
            if dv then
                break
            end
        end
        local raw = master.calculate.mul(a, master.convert(d, s))
        if -raw._dlen >= (accuracy - 1) // s then
            local i = raw._dlen
            local iu
            repeat
                local v <const> = tostring(raw[i])
                local cu = tonumber(v:match("^(%d-)0*$"):sub(1, -2)) or 0
                local ma = tonumber("1"..("0"):rep(math.min(#tostring(cu), s + 1)))
                if v:match("(%d?)0*$") > "5" or iu then
                    cu, iu = (cu + (iu or 1)) % ma, (cu + (iu or 1)) // ma
                end
                raw[i], i, raw._dlen = cu ~= 0 and cu..(i > 1 and ("0"):rep(v:match("0*$"):len()) or "") or nil, i + 1, cu == 0 and raw._dlen + 1 or raw._dlen
            until not iu or iu == 0
        end
        return raw
    end,
}

master.floor = function(x) -- Returns the largest integral value smaller than or equal to `x`.
    for i = x._dlen or 1, 0 do
        x[i] = nil
    end
    x._dlen = 1
    return x
end

do
    -- Build ENV --
    local _ENV <const> = {
        smul = function(x, y)
            return (x.sign or "+") == (y.sign or "+") and "+" or "-"
        end,
        vtype = function(...)
            local stack, v = {}, {...}
            local SOFT, INTEGER = {table = 1, string = 2, number = 3}, master._config.SETINTEGER_PERBLOCK.DEFAULT
            table.sort(v, function(a, b) return (SOFT[type(a)] or 0) < (SOFT[type(b)] or 0) end)
            for i, s in ipairs(v) do
                if type(s) == "table" then
                    stack[i], INTEGER = s, s._size or INTEGER
                else
                    local c = master.convert(math.abs(type(s) == "string" and s:match("^[+-]?(%d+)%s*$") or s), INTEGER)
                    c.sign = type(s) == "string" and (s:match("^[+-]") or "+") or math.sign(s) < 1 and "-" or "+"
                    stack[i] = setmetatable(c, master._metatable)
                end
            end
            return table.unpack(stack)
        end,
        vpow = function(self, x, y)
            if tostring(y) == "0" then
                return 1
            elseif tostring(y) == "1" then
                return x
            elseif tostring(y % 2) == "0" then
                local half_power = self:vpow(x, y // 2)
                return half_power * half_power
            end
            local half_power = self:vpow(x, (y - 1) // 2)
            return x * half_power * half_power
        end,
        ifloor = master.floor,

        add = master.calculate.add,
        sub = master.calculate.sub,
        mul = master.calculate.mul,
        div = master.calculate.div,

        equal = master.equation.equal,
        less = master.equation.less,
        more = master.equation.more,
        
        setmetatable = setmetatable
    }

    -- Build metatable --
    master._metatable = {

        -- Calculation operators --
        __add = function(x, y)
            x, y = vtype(x, y)
            if x.sign or "+" == y.sign or "+" then
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
            local raw = (x.sign or "+" == y.sign or "+") and sub(reg and x or y, reg and y or x) or add(x, y)
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
            return _ENV:vpow(x, y)
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
        __tostring = function(x)
            return (x.sign == "-" and "-" or "")..master.deconvert(x)
        end
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
        local c = master.convert(math.abs(type(s) == "string" and s:match("^[+-]?(%d+)%s*$") or s), int._defaultmode)
        c.sign = type(s) == "string" and (s:match("^[+-]") or "+") or math.sign(s) < 1 and "-" or "+"
        table.insert(stack, setmetatable(c, master._metatable))
    end
    return table.unpack(stack)
end

int.cnew = function(number, mode) -- (string|number, mode) For setting mode **when calculate block size SHOULD BE SAME**
    local t = master.convert(math.abs(type(number) == "string" and number:match("^[+-]?(%d+)%s*$") or number), mode and master._config.SETINTEGER_PERBLOCK[mode:upper()] or int._defaultmode)
    t.sign = type(number) == "string" and (number:match("^[+-]") or "+") or math.sign(number) < 1 and "-" or "+"
    return setmetatable(t, master._metatable)
end

int.abs = function(x) -- Returns the absolute value of `x`.
    x.sign = "+"
    return setmetatable(x, master._metatable)
end

int.sign = function(x) -- Returns -1 if x < 0, 0 if x == 0, or 1 if x > 0.
    local siz = x._size or 1
    local zeo = master.convert(0, siz)
    local reg, req = master.equation.more(x, zeo), master.equation.equal(x, zeo)
    local t = req and zeo or master.convert(1, siz)
    t.sign = reg or req and "+" or "-"
    return setmetatable(t, master._metatable)
end

int.floor = function(x) -- Returns the largest integral value smaller than or equal to `x`.
    return setmetatable(master.floor(x), master._metatable)
end

int.tostring = function(x) -- Returns string
    return (x.sign == "-" and "-" or "")..master.deconvert(x)
end

int.tonumber = function(x) -- Returns number
    return tonumber(int.tostring(x))
end

int.fdigitlen = function(x) -- Returns `INTEGER + DECIMAL` len **do not use `#` to get a digit len.**
    return #x + math.abs((x._dlen or 1) - 1)
end

local x, y = int.new(99, 99)

print(x ^ y)

print(("MODULE LOADED\nMEMORY USAGE: %s B"):format(math.floor(collectgarbage("count") * 1024)))
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