----------------------------------------------------
--                 ULTIMATE INT                   --
----------------------------------------------------
-- MODULE VERSION: 185 (03/08/2024) dd:mm:yyyy
-- AUTHOR: SupTan85
-- LICENSE: MIT (the same license as Lua itself)
-- LINK: https://github.com/SupTan85/int
-- 
----------------------------------------------------

local master = {
    _config = {
        SETINTEGER_PERBLOCK = {
            STABLE = 1,
            BALANCE = 4,
            FASTEST = 9,

            DEFAULT = 9,
        },

        OPTION = {
            --[[ MASTER DIVISION | BYPASS FLOATING POINT >>
                How dose it work :
                    optimize division process by less loop calculate cycle.

                Copy right (C) 2024 SupTan85
            << BUILD-IN >>]]
            MASTER_CALCULATE_DIV_BYPASS_FLOATING_POINT = true,

            --[[ MASTER DIVISION | AUTO CONFIG ITERATIONS LIMIT >>
                How dose it work :
                    automatic setting a maxiumum of iterations in division function. *only when there is no self config value*
                    note: this option causes a division speed slow, but very powerful for high accuracy.

                // DISABLE : MASTER_CALCULATE_DIV_MAXITERATIONS
                Copy right (C) 2024 SupTan85
            << BUILD-IN >>]]
            MASTER_CALCULATE_DIV_AUTO_CONFIG_ITERATIONS = true,
        },

        ACCURACY_LIMIT = {
            -- MASTER FUNCTION CONFIG --
            MASTER_CALCULATE_DIV_MAXITERATIONS = 15, -- 15
            MASTER_DEFAULT_FRACT_LIMIT_DIV = 14, -- 14

            -- MEDIA FUNCTION CONFIG --
            MEDIA_DEFAULT_POWER_ACCURATE_LIMIT = 15, -- 15
            MEDIA_DEFAULT_POWER_FRACT_LIMIT = 14, -- 14

            MEDIA_DEFAULT_NATURAL_LOGARITHM_MAXITERATIONS = 15, -- 15
            MEDIA_DEFAULT_EXPONENTIAL_MAXITERATIONS = 15, -- 15

            MEDIA_DEFAULT_SQRTROOT_MAXITERATIONS = 15, -- 15
            MEDIA_DEFAULT_SQRTROOT_TOLERANCE = 14, -- 14
        },

        -- SYSTEM CONFIG ! DO NOT CHANGE ! --
        MAXIMUM_DIGIT_PERTABLE = {
            INTEGER = "9223372036854775806",    FRACTION = "9223372036854775808"
        },

        MAXIMUM_SIZE_PERBLOCK = 9, -- stable size is 9
        MAXIMUM_LUA_INTEGER = 9223372036854775807 -- math.maxinteger
    },

    _VERSION = "185"
}

local OPTION = master._config.OPTION
local ACCURACY_LIMIT = master._config.ACCURACY_LIMIT

---@diagnostic disable-next-line: deprecated
table.unpack = table.unpack or unpack
local max, min, floor, ceil = math.max, math.min, math.floor, math.ceil

master.convert = function(st, s)
    assert(type(st) == "string" or type(st) == "number", ("[CONVERT] INPUT_TYPE_NOTSUPPORT | attempt to convert with a '%s'."):format(type(st)))
    st, s = tostring(st), s or 1
    assert(not (s <= 0), ("[CONVERT] SETTING_SIZE_ISSUE | size per block is less then one. (%s < 1)"):format(s))
    assert(not (s > master._config.MAXIMUM_SIZE_PERBLOCK), ("[CONVERT] MAXIMUM_SIZE_PERBLOCK | size per block is more then maxiumum setting. (%s > %s)"):format(s, master._config.MAXIMUM_SIZE_PERBLOCK))
    local result, step = {_size = s}, 0
    local i, i2 = st:match("^(%d+)%.(%d+)$")
    i, i2 = (i or st):reverse(), (i2 or ""):match("^(.-)0*$")
    local len_i, len_i2 = #i, #i2
    for index = 1, max(len_i, len_i2), s do
        step = step + 1
        if index <= len_i then
            result[step] = tonumber(i:sub(index, min(index + s - 1, len_i)):reverse()) or error("[CONVERT] VOID_VALUE | attempt to convert but got 'nil'.")
        end
        if index <= len_i2 then
            local d = i2:sub(index, min(index + s - 1, len_i2))
            result[1 - step] = tonumber(d .. ("0"):rep(s - #d)) or error("[CONVERT] VOID_VALUE | attempt to convert but got 'nil'.")
            result._dlen = 1 - step
        end
    end
    result._dlen = result._dlen or 1
    return result
end

master.deconvert = function(x)
    assert(type(x or error("[DECONVERT] INPUT_VOID")) == "table", ("[DECONVERT] INPUT_TYPE_NOTSUPPORT | attempt to deconvert with a '%s'."):format(type(x)))
    local em, sm, fm, s = false, {}, {}, x._size or 1
    for i = x._dlen or 1, 0 do
        if not em and x[i] <= 0 then
            x[i] = nil
        else
            local v = tostring(x[i])
            sm[-i], em = ("0"):rep(s - #v)..v, true
        end
    end
    em = false
    for i = #x, 1, -1 do
        if not em and x[i] <= 0 then
            x[i] = nil
        else
            fm[#fm+1], em = x[i], true
        end
    end
    return (fm[1] and table.concat(fm) or "0")..(sm[0] and "."..table.concat(sm, "", 0):match("(%d-)0*$") or "")
end

local Cmaster, Dmaster = master.convert, master.deconvert
master.objfloor = {
    _floor = function(x, length, s)
        local rev, dlen, ispr = length < 0, x._dlen or 1, true
        length = rev and math.abs(((dlen - 1) * s) + (s - #(tostring(x[dlen]):match("^(%d-)0*$") or ""))) + length or length
        local endp
        if rev or ceil(-length / s) > dlen - 1 then
            endp = ceil(-length / s)
            for i = dlen, min(endp, 0) do
                if i == endp then
                    local shift = tostring(x[i]):sub(1, length % s)
                    local hofu = tonumber(shift..("0"):rep(s - #shift))
                    ispr = ispr or (length % s) < #(tostring(x[i]):match("^(%d-)0*$") or "")
                    x[i] = hofu ~= 0 and hofu
                    if not x[i] then
                        endp = endp + 1
                        for i = endp, 0 do
                            if x[i] == 0 then
                                endp, x[i] = endp + 1, nil
                            else
                                break
                            end
                        end
                    end
                else
                    x[i] = nil
                end
            end
            x._dlen = endp
        end
        return {x, ispr, endp or dlen}
    end,

    floor = function(x) -- Returns the largest integral value smaller than or equal to `x`.
        assert(type(x) == "table", ("[FLOOR] INPUT_TYPE_NOTSUPPORT | x: table (not %s)"):format(type(x)))
        for i = x._dlen or 1, 0 do
            x[i] = nil
        end
        x._dlen = 1
        return x
    end,

    cfloor = function(self, x, length) -- Custom a `x` fraction. *use ":" to call a function*
        assert(type(length) == "number", ("[CFLOOR] INPUT_TYPE_NOTSUPPORT | length: number (not %s)"):format(type(length)))
        assert(type(x) == "table", ("[CFLOOR] INPUT_TYPE_NOTSUPPORT | x: table (not %s)"):format(type(x)))
        return self._floor(x, length, x._size or 1)[1]
    end,

    cround = function(self, x, length) -- Custom a `x` fraction, with automatic round fractions. *use ":" to call a function*
        assert(type(length) == "number", ("[CROUND] INPUT_TYPE_NOTSUPPORT | length: number (not %s)"):format(type(length)))
        assert(type(x) == "table", ("[CROUND] INPUT_TYPE_NOTSUPPORT | x: table (not %s)"):format(type(x)))
        local s = x._size or 1
        local ispr, endp
        if length < 0 and length + 1 == 0 then
            ispr, endp = true, x._dlen or 1
        else
            x, ispr, endp = table.unpack(self._floor(x, length + 1, s))
        end
        if ispr and (x._dlen or 1) < 1 then
            local i, iu, dx, U
            repeat
                local v = x[i or endp]
                local rv
                if i then
                    U = U or floor(10 ^ s)
                    rv = (v or 0) + iu
                    rv, iu = tostring(rv % U), floor(rv / U)
                else
                    local ca = {}
                    for v in tostring(v or ""):match("(%d-)0*$"):reverse():gmatch(".") do
                        v = tonumber(v)
                        if iu then
                            v = v + iu
                            iu, v = floor(v / 10), v % 10
                        else
                            iu, v = v > 5 and 1 or 0, 0
                        end
                        ca[#ca+1] = v
                    end
                    rv = table.concat(ca)
                end
                if not rv then
                    rv, iu = tostring(iu), nil
                end
                rv = tonumber((rv..(not i and endp < 1 and ("0"):rep(s - #rv) or "")):match("^0*(.+)"))
                dx = dx or rv ~= 0
                x[i or endp], i = dx and rv or nil, (i or endp) + 1
                if not dx then
                    x._dlen = i
                end
            until not iu or iu == 0
        end
        return x
    end
}

local objfloor = master.objfloor
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
        elseif #x == #y or x[#x] == 0 or y[#y] == 0 then
            for i = #x, x._dlen or 1, -1 do
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
            block = (rv and (block:match("(.-)0+$") or block):reverse() or block):sub(1 + #v, -1)
            local st = rv and block..v or v..block
            return tonumber(st..(index < 1 and ("0"):rep(s - #v - #block) or ""))
        end,

        m_connext = function(block, s, index)
            return ("0"):rep(s - #block)..(index < 1 and block:match("(.-)0+$") or block)
        end,

        c_empty = function(atable_int, dlen, dc)
            for i = dlen, dc do
                atable_int[i] = nil
            end
            return atable_int, dc + 1
        end,

        c_process = function(self, atable_int, to_int, time, lastcut, startfront, size, _side)
            local connext, clean, c_empty, lastcut = self.m_connext, self.m_clean, self.c_empty, type(lastcut) == "number" and lastcut or 0
            local s, dlen, time = atable_int._size or size or 1, atable_int._dlen or 1, time or 1
            to_int = _side and ((to_int and tostring(to_int)) or "0"):reverse() or ((to_int and tostring(to_int)) or "0")
            local to, tolen, len = to_int:rep(ceil(s / #to_int)), #to_int, ((_side and not startfront or startfront) and #atable_int) or dlen
            local last, _tolen, i = 0, #to_int, -1
            local li, lv, dc
            while true do
                i = i + 1
                local index = _side and len + i or len - i
                local b = (li or lastcut >= 0) and tostring(atable_int[index] or "") or tostring(atable_int[index] or ""):sub(0, -1 + (_side and (index > 0 and lastcut) or (index < 1 and lastcut) or 0))
                local v = (li and (_side and to:sub(li + 1, li + s):reverse() or to:sub(li + 1, li + s))) or (startfront and "")
                if v then
                    v = _side and ((lastcut ~= 0 or last < time) and to:sub(1, max(s - #v - (not li and index < 1 and #(b:match("(0+)$") or "") or 0), 0)) or ""):reverse() .. v or 
                        v .. ((lastcut ~= 0 or last < time) and to:sub(1, max(s - #v - (not li and index > 0 and s - #b or 0), 0)) or "")
                else
                    v = connext(b, s, index)
                    v = _side and ((lastcut ~= 0 or last < time) and to:sub(1, max(s - #v - (index < 1 and s - #(b:match("(0+)$") or "") or 0), 0)) or ""):reverse() .. v or 
                        v .. ((lastcut ~= 0 or last < time) and to:sub(1, max(s - #v - (index > 0 and s - #b or 0), 0)) or "")
                end
                li = ((li or (not startfront and -#connext(b, s, index) or 0)) + #v) % _tolen
                local raw = clean(b, index, v, s, _side)
                lv = (lv or (not startfront and -#connext(b, s, index) or 0)) + (raw and #v or 0)
                last = (lv or 0) / tolen
                if index < 1 then
                    dc, dlen = tostring(raw):match("^0+$") ~= nil and index or nil, index
                end
                if last >= time then
                    v = _side and v:sub(1 + ((lastcut > 0 and lastcut - 1) or (li + (_tolen * max(0, floor(last - time))))), -1) or v:sub(1, -1 - ((lastcut > 0 and lastcut - 1) or (li + (_tolen * max(0, floor(last - time))))))
                    atable_int[index] = clean(b, index, v, s, _side)
                    break
                end
                atable_int[index] = raw
            end
            if dc then
                atable_int, dlen = c_empty(atable_int, dlen, dc)
            end
            atable_int._size, atable_int._dlen = atable_int._size or size, dlen
            return atable_int
        end
    },

    left = function(TABLE, INT, LOOPTIME, LASTCUT_OFFSET, IS_FRONT, BLOCK_SIZE)
        return #tostring(INT or ""):match("^0*([^.A-Za-z]-)$") > 0 and master.roll._assets:c_process(TABLE, INT, LOOPTIME, LASTCUT_OFFSET, IS_FRONT, BLOCK_SIZE, true) or TABLE
    end,

    right = function(TABLE, INT, LOOPTIME, LASTCUT_OFFSET, IS_FRONT, BLOCK_SIZE)
        return #tostring(INT or ""):match("^0*([^.A-Za-z]-)$") > 0 and master.roll._assets:c_process(TABLE, INT, LOOPTIME, LASTCUT_OFFSET, IS_FRONT, BLOCK_SIZE) or TABLE
    end
}

master.calculate = {
    _assets = {
        VERIFY = function(a, b, SIZE_MAXIUMUM, CODE_NAME)
            assert((a._size or 1) == (b._size or 1), ("[%s] BLOCK_SIZE_ISSUE (%s : %s)"):format(CODE_NAME or "UNKNOW", a._size or 1, b._size or 1))
            assert(not ((a._size or 1) > SIZE_MAXIUMUM), ("[%s] BLOCK_SIZE_OVERFLOW (%s > %s)"):format(CODE_NAME or "UNKNOW", a._size or 1, SIZE_MAXIUMUM))
        end
    },

    add = function(self, a, b, s)  -- _size maxiumum 18 **block size should be same**
        self._assets.VERIFY(a, b, 18, "ADD")
        local result = {_size = a._size or s or 1}
        local s, c, d = floor(10 ^ (result._size)), false, false
        for i = min(a._dlen or 1, b._dlen or 1), max(#a, #b) do
            local block_result = (a[i] or 0) + (b[i] or 0)
            local next = floor(block_result / s)
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
    sub = function(self, a, b, s)  -- _size maxiumum 18 (to use this function `a >= b` else result will been wrong!) **block size should be same**
        self._assets.VERIFY(a, b, 18, "SUB")
        local result = {_size = a._size or s or 1}
        local s, d = floor(10 ^ (result._size)), false
        local stack
        for i = min(a._dlen or 1, b._dlen or 1), max(#a, #b) do
            local block_result = (a[i] or 0) - (b[i] or 0)
            local callback = (block_result % s) - (result[i] or 0)
            local block_data = callback % s
            result[i] = block_data
            if not d and block_data ~= 0 then
                result._dlen, d = (i < 1 and i) or 1, true
            end
            stack = (block_data == 0 and ((stack and {stack[1], i}) or {i, i})) or nil
            result[i + 1] = (callback < 0 and (floor((callback % s) / s) + (((callback % s) ~= 0 and 1) or 0))) or nil
            result[i + 1] = (block_result < 0 and (result[i + 1] or 0) + (floor((block_result % s) / s) + (((block_result % s) ~= 0 and 1) or 0))) or result[i + 1]
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
    mul = function(self, a, b, s, e) -- _size maxiumum 9 (`e` switch for division process.) **block size should be same**
        self._assets.VERIFY(a, b, 9, "MUL")
        local result = {_size = a._size or s or 1}
        local s, op = floor(10 ^ (result._size)), 1
        local cd
        for i = a._dlen or 1, #a do
            local block_a = a[i]
            for i2 = b._dlen or 1, #b do
                local calcul, offset = block_a * b[i2], i + i2 - 1
                local block_data = (calcul + (result[offset] or 0))
                local next = floor(block_data / s)
                block_data = block_data % s
                cd = (cd or block_data ~= 0) and true or nil
                result[offset] = (offset >= 1 or cd) and block_data or nil
                op = result[offset] and min(op, offset) or op
                result[offset + 1] = (next ~= 0 and (next + (result[offset + 1] or 0))) or result[offset + 1]
            end
            if e and #result >= 1 then
                if #result > 1 or (#result == 1 and result[1] ~= 0) then
                    break
                end
            end
        end
        for i = #result, 2, -1 do
            if result[i] == 0 then
                result[i] = nil
            else
                break
            end
        end
        result._dlen = op
        return result
    end,
    div = function(self, a, b, s, f, l) -- _size maxiumum 9 (`f` The maxiumum number of fraction, `l` The maximum number of iterations to perform.) **block size should be same**
        self._assets.VERIFY(a, b, 9, "DIV")
        assert(not master.equation.equal(b, Cmaster(0, b._size or 1)), "[DIV] INPUT_VALIDATION_FAILED | divisor cannot be zero.")
        local s, b_dlen, f = a._size or s or 1, b._dlen or 1, f or ACCURACY_LIMIT.MASTER_DEFAULT_FRACT_LIMIT_DIV
        local auto_acc, more, less, right = not l and OPTION.MASTER_CALCULATE_DIV_AUTO_CONFIG_ITERATIONS, master.equation.more, master.equation.less, master.roll.right
        local one = Cmaster(1, s)
        local accuracy, uc = 0, 0
        local lastpoint, fin, mark
        local d = OPTION.MASTER_CALCULATE_DIV_BYPASS_FLOATING_POINT and (function(b)
            local p = tostring("1" / b)
            if p:find("e") then
                local L, R = p:match("^[-+]?(%d-%.?%d+)e"), p:match("e[-+]?(%d+)$")
                L, lastpoint = L:sub(1, -2), L:sub(-2, -2)
                local S = L:match("^(%d+)%."):len()
                if tonumber(R) > master._config.MAXIMUM_LUA_INTEGER then
                    return {L:gsub("%.", ""), self.sub(Cmaster(R, s), Cmaster(S, s))}
                end
                return "0."..("0"):rep(tonumber(R) - S)..L:gsub("%.", "")
            end
            return p ~= "0.0" and p
        end)(Dmaster(b))
        if auto_acc then
            local function HF(x)
                return (s - #tostring(x[#x])) + ((x._dlen or 1) < 1 and s - #tostring(x[x._dlen] or "") or 0)
            end
            local AN, BN = (#a + math.abs((a._dlen or 1) - 1)) * s, (#b + math.abs(b_dlen - 1)) * s
            local NV = AN > BN
            if (NV and AN or BN) < master._config.MAXIMUM_LUA_INTEGER then
                accuracy, auto_acc = (NV and AN or BN) - HF(NV and a or b) + f, false
            else
                local AS, BS = self.add(Cmaster(#a, s), Cmaster(math.abs((a._dlen or 1) - 1), s)), self.add(Cmaster(#b, s), Cmaster(math.abs(b_dlen - 1), s))
                local MORE = more(AS, BS)
                accuracy = self.add(self.sub(self:mul((MORE and AS or BS), Cmaster(s, s)), Cmaster(HF(MORE and a or b), s)), Cmaster(f, s))
            end
        else
            accuracy = (l or ACCURACY_LIMIT.MASTER_CALCULATE_DIV_MAXITERATIONS) + 1
        end
        b = self:mul(b, Cmaster("1"..("0"):rep(math.abs(b_dlen - 1)), b._size))
        local function check(n)
            local dc = d and setmetatable({}, {__index = d, __len = function() return #d end}) or Cmaster(n, s)
            local nc = self:mul(b, d and right(dc, ("0"):rep(uc or 0)..n) or dc, s, true)
            if more(nc, one) then
                return 1
            elseif less(nc, one) then
                return 0
            end
        end
        local function calcu(c)
            local map
            if c then
                map = {}
                for i = 0, 9 do
                    map[i + 1] = (i % 2 == 0 and (c - ceil(i / 2)) or (c + ceil(i / 2))) % 10
                end
            else
                map = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
            end
            local high, low, code
            for i = 1, 10 do
                i = map[i]
                if i >= (low or 0) and i <= (high or 9) then
                    code = check(i)
                    if code == 0 then
                        low = i
                    elseif code == 1 then
                        high = i
                    else
                        return true, i
                    end
                    if (high or 9) - (low or 0) <= 1 and high and low then
                        break
                    end
                end
            end
            return false, low
        end
        if d then
            if type(d) == "table" then
                local fp, bp = d[2], d[1]
                accuracy = auto_acc and self.sub(accuracy, bp) or accuracy - Dmaster(bp)
                d = {0, _size = s, _dlen = 1}
                local SIZE = Cmaster(s, s)
                while less(bp, one) do
                    bp = self.sub(bp, SIZE)
                    if less(bp, one) then
                        for v in fp:gmatch(("."):rep(s)) do
                            d._dlen = d._dlen - 1
                            d[d._dlen] = tonumber(v)
                        end
                        break
                    end
                    d._dlen = d._dlen - 1
                    d[d._dlen] = 0
                end
            else
                d = d:sub(1, auto_acc and Dmaster(accuracy) or accuracy)
                accuracy = auto_acc and self.sub(accuracy, Cmaster(d:len())) or accuracy - d:match("%.(.+)$"):len()
                d, lastpoint = Cmaster(d, s), lastpoint or d:match("(%d)0*$")
            end
        end
        while auto_acc and more(accuracy, Cmaster(0, s)) or not auto_acc and accuracy > 0 do
            local dv, lp = calcu(lastpoint)
            d, lastpoint = d and right(d, ("0"):rep(uc)..lp) or not d and Cmaster(lp, s) or d, lp
            uc = lp == 0 and mark and (uc) + 1 or 0
            mark = mark or d ~= nil
            if dv then
                lastpoint = nil
                break
            end
            fin = fin or (Dmaster(d) or ""):match("^0*%.?0*$") == nil
            if fin then
                if auto_acc then
                    if less(accuracy, one) then
                        break
                    end
                    accuracy = self.sub(accuracy, one) or accuracy
                else
                    accuracy = (accuracy - 1 or accuracy)
                end
            end
        end
        if b_dlen < 1 then
            d = self:mul(d, Cmaster("1"..("0"):rep(math.abs(b_dlen - 1)), s))
        end
        local raw = self:mul(a, d)
        if lastpoint and -raw._dlen >= floor(f / s) then
            local shf = 0
            for i = raw._dlen or 1, 0, -1 do
                local sel = raw[i]
                if sel == 0 then
                    shf = shf + s
                else
                    shf = shf + s - #tostring(sel)
                    break
                end
            end
            raw = objfloor:cround(raw, shf + f)
        end
        return raw
    end,
}

local function sign(number) -- Returns -1 if `x < 0`, 0 if `x == 0`, or 1 if `x > 0`.
    if number > 0 then
        return 1
    elseif number < 0 then
        return -1
    end
    return 0
end

local media = {
    assets = {
        FSzero = function(x, y) -- return the same sign when number is *zero*
            local ze, equal = Cmaster(0, x._size), master.equation.equal
            return equal(x, ze) and "+" or x.sign, equal(y, ze) and "+" or y.sign
        end
    },

    convert = function(n, size) -- automatic setup a table.
        n = n or 0
        local n_type = type(n)
        assert(n_type == "string" or n_type == "number", ("[CONVERT] INPUT_TYPE_NOTSUPPORT | n: string|number (not %s)"):format(n_type))
        if tostring(n):find("e") then
            n, n_type = tostring(n), "string"
            local es, fs = tonumber(n:match("^%s*[+-]?%d+%.?%d*e([+-]?%d+)%s*$")), n:match("^%s*([+-]?%d+%.?%d*)e[+-]?%d+%s*$")
            if es and fs then
                if es ~= 0 then
                    local loc = (fs:find("%.") or (#fs + 1)) - 1
                    local dot, fs_sign = loc + es, fs:match("^%s*([+-])") or "+"
                    local f, b
                    fs = fs:gsub("%.", ""):gsub("[+-]", "")
                    if dot < 0 then
                        f, b = "0", ("0"):rep(-dot)..fs
                    else
                        fs = fs..("0"):rep(dot - #fs)
                        f, b = fs:sub(1, dot):match("^0*(.*)$"), fs:sub(dot + 1, -1):match("^(.-)0*$")
                    end
                    fs = fs_sign..(f == "" and "0" or f)..(b ~= "" and "."..b or "")
                end
                local t = Cmaster(fs:match("^%s*[+-]?(%d+%.?%d*)%s*$"), size)
                t.sign = fs:match("^%s*([+-]?)") or "+"
                return setmetatable(t, master._metatable)
            end
            error(("malformed number near '%s'"):format(n:match("^%s*(.-)%s*$")))
        end
        local t = Cmaster(n_type == "string" and n:match("^%s*[+-]?(%d+%.?%d*)%s*$") or math.abs(tonumber(n) or error(("[CONVERT] MALFORMED_NUMBER '%s'"):format(n))), size)
        t.sign = n_type == "string" and (n:match("^%s*([+-])") or "+") or sign(n) < 0 and "-" or "+"
        return setmetatable(t, master._metatable)
    end,
    tostring = function(int) -- Deconvert table to string.
        local str = Dmaster(int)
        return (int.sign == "-" and str ~= "0" and "-" or "")..str
    end,

    abs = function(x) -- Returns the absolute value of `x`.
        assert(type(x) == "table", ("[ABS] INPUT_TYPE_NOTSUPPORT | x: table (not %s)"):format(type(x)))
        x.sign = "+"
        return setmetatable(x, master._metatable)
    end,

    fact = function(n, s) -- Factorial function
        local result
        if type(n) == "table" then
            result = setmetatable(Cmaster("1", n._size), master._metatable)
            result.sign, n.sign = n.sign or "+", "+"
        else
            result = setmetatable(Cmaster("1", s or master._config.SETINTEGER_PERBLOCK.DEFAULT), master._metatable)
            result.sign = "+"
        end
        if tostring(n) >= tostring(master._config.MAXIMUM_LUA_INTEGER) then
            while tostring(n) > "0" do
                result, n = result * n, n - 1
            end
        else
            n = tonumber(tostring(n))
            while n > 0 do
                result, n = result * n, n - 1
            end
        end
        return result
    end,

    floor = function(x, length) -- Returns the largest integral value smaller than or equal to `x`, or Custom a `x` fraction.
        return setmetatable(length and objfloor:cfloor(x, length) or objfloor.floor(x), master._metatable)
    end,
    cround = function(x, length) -- Custom a `x` fraction, with automatic round fractions.
        return setmetatable(length and objfloor:cround(x, length) or objfloor.floor(x), master._metatable)
    end,

    ceil = function(x) -- Returns the smallest integral value larger than or equal to `x`.
        if (x._dlen or 1) < 1 then
            return setmetatable(objfloor.floor(x), master._metatable) + 1
        end
        return setmetatable(x, master._metatable)
    end
}

local assets = media.assets
function media.equal(x, y) -- work same `equation.equal` but support sign config.
    local ze, equal = Cmaster(0, x._size), master.equation.equal
    return (equal(x, ze) and "+" or x.sign) == (equal(y, ze) and "+" or y.sign) and equal(x, y)
end
function media.less(x, y) -- work same `equation.less` but support sign config.
    local xs, ys = assets.FSzero(x, y)
    local nox = xs ~= ys
    return nox and ys == "+" or (not nox and master.equation.less(x, y))
end
function media.more(x, y) -- work same `equation.more` but support sign config.
    local xs, ys = assets.FSzero(x, y)
    local nox = xs ~= ys
    return nox and ys == "-" or (not nox and master.equation.more(x, y))
end

function media.integerlen(x) -- Returns `INTEGER` length.
    local le = #x
    return #(tostring(x[le] or "") + ((media.convert(le) - 1):max(0) * x._size)):max(1)
end
function media.fractionlen(x) -- Returns `FRACTION` length.
    local le = math.abs((x._dlen or 1) - 1)
    return #tostring(x[le] or "") + ((media.convert(le) - 1):max(0) * x._size)
end
function media.fdigitlen(x) -- Returns `INTEGER + FRACTION` length.
    return media.integerlen(x) + media.fractionlen(x)
end

function media.tonumber(x) -- Deconvert table to number. *not recommend*
    return tonumber(media.tostring(x))
end

function assets.vtype(...) -- This function make table can mix a number and string. *return table*
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
    return table.unpack(assets.vtype(...))
end

function media.cdiv(x, y, f, l) -- Custom division function. (`f` The maxiumum number of fraction, `l` The maximum number of iterations to perform.)
    assert(x and y, "[CDIV] INPUT_VOID")
    x, y = media.vtype(x, y)
    local raw = master.calculate:div(x, y, x._size, f, l)
    local x_sign, y_sign = x.sign or "+", y.sign or "+"
    raw.sign = (#x_sign == 1 and x_sign or "+") == (#y_sign == 1 and y_sign or "+") and "+" or "-"
    return setmetatable(raw, master._metatable)
end

function media.sign(x) -- Returns -1 if x < 0, 0 if x == 0, or 1 if x > 0.
    assert(x, "[SIGN] INPUT_VOID")
    local siz = x._size or 1
    local zeo = media.convert(0, siz)
    local reg, req = media.more(x, zeo), media.equal(x, zeo)
    local t = req and zeo or media.convert(1, siz)
    t.sign = reg or req and "+" or "-"
    return t
end

function media.max(x, ...) -- Returns the argument with the maximum value, according to the Lua operator `<`.
    local result
    for _, x in ipairs(assets.vtype(x, ...)) do
        result = result and (media.more(result, x) and result) or x
    end
    return result and setmetatable(result, master._metatable)
end

function media.min(x, ...) -- Returns the argument with the minimum value, according to the Lua operator `>`.
    local result
    for _, x in ipairs(assets.vtype(x, ...)) do
        result = result and (media.less(result, x) and result) or x
    end
    return result and setmetatable(result, master._metatable)
end

function media.ln(x, l) -- Returns the Natural logarithm of `x` in the given base. `l` The maximum number of iterations to perform.
    x = media.vtype(x) or error("[IN] INPUT_VOID")
    if tostring(x) <= "0" then
        assert(tostring(x) ~= "0", "[IN] INPUT_VALIDATION_FAILED | Natural logarithm function return inf-positive value.")
        error("[IN] INPUT_VALIDATION_FAILED | Natural logarithm function return non-positive value.")
    end
    local result = Cmaster(0, x._size)
    result.sign = "+"
    -- taylor series of logarithms --
    local X1 = (x - 1) / (x + 1)
    for n = 1, 1 + (2 * (l or ACCURACY_LIMIT.MEDIA_DEFAULT_NATURAL_LOGARITHM_MAXITERATIONS)), 2 do
        result = result + ((1 / n) * (X1 ^ n))
    end
    return setmetatable(objfloor:cfloor(result * 2, 15), master._metatable)
end

function media.exp(x, l) -- Exponential function. `l` The maximum number of iterations to perform.
    x = media.vtype(x) or error("[EXP] INPUT_VOID")
    local result = setmetatable(Cmaster(0, x._size), master._metatable)
    result.sign = "+"
    for n = 0, (l or ACCURACY_LIMIT.MEDIA_DEFAULT_EXPONENTIAL_MAXITERATIONS) - 1 do
        result = result + ((x ^ n) / media.fact(n, x._size))
    end
    return objfloor:cfloor(result, l or ACCURACY_LIMIT.MEDIA_DEFAULT_EXPONENTIAL_MAXITERATIONS)
end

function media.modf(x) -- Returns the integral part of `x` and the fractional part of `x`.
    x = media.vtype(x or error("[MODF] INPUT_VOID"))
    local frac = {sign = x.sign or "+", _dlen = x._dlen or 1, _size = x._size}
    for i = frac._dlen, 0 do
        frac[i] = x[i]
    end
    frac[1] = 0
    return setmetatable(objfloor.floor(x), master._metatable), setmetatable(frac, master._metatable)
end

function media.fmod(x, y) -- Returns the remainder of the division of `x` by `y` that rounds the quotient towards zero.
    assert(x and y, "[FMOD] INPUT_VOID")
    x, y = media.vtype(x, y)
    return x - (media.floor(x / y) * y)
end

function assets.vpow(self, x, y, l) -- pow function assets. `y >= 0`
    assert(x and y, "[VPOW] INPUT_VOID")
    assert(tostring(y) >= "0", ("[VPOW] FUNCTION_NOT_SUPPORT | y (%s) is less then 0."):format(tostring(y)))
    if tostring(y % 1) == "0" then
        local st = tostring(y)
        if st == "0" then
            return tostring(x) == "0" and error("[VPOW] INPUT_VALIDATION_FAILED | cannot divide itself by zero.") or media.convert(1, x._size)
        elseif st == "1" then
            return objfloor:cfloor(x, l)
        elseif tostring(y % 2) == "0" then
            local half_power = self:vpow(x, media.cdiv(y, 2, 0, l), l)
            return half_power * half_power
        end
        local half_power = self:vpow(x, media.cdiv((y - 1), 2, 0, l), l)
        return x * half_power * half_power
    end
    return media.exp(y * media.ln(x))
end

function media.pow(x, y, f, l) -- Returns `x ^ y`. (`f` The maxiumum number of fraction, `l` The maximum number of iterations to perform.)
    assert(x and y, "[POW] INPUT_VOID")
    x, y = media.vtype(x, y)
    local ysign = y.sign
    y.sign, l = "+", l or ACCURACY_LIMIT.MEDIA_DEFAULT_POWER_ACCURATE_LIMIT
    return ysign == "-" and media.cdiv(1, assets:vpow(x, y, l), f or ACCURACY_LIMIT.MEDIA_DEFAULT_POWER_FRACT_LIMIT, l) or objfloor:cfloor(assets:vpow(x, y, l), l)
end

function media.sqrt(x, f, l) -- Returns the square root of `x`. (`f` The maxiumum number of fraction, `l` The maximum number of iterations to perform.)
    x = media.vtype(x or error("[SQRT] INPUT_VOID"))
    -- Newton's Method --
    assert(tostring(x) >= "0", "[SQRT] INPUT_VALIDATION_FAILED | Cannot compute the square root of a negative number.")
    local res = x / 2
    local TOLERANCE = f or ACCURACY_LIMIT.MEDIA_DEFAULT_SQRTROOT_TOLERANCE
    for _ = 1, l or ACCURACY_LIMIT.MEDIA_DEFAULT_SQRTROOT_MAXITERATIONS do
        local nes = 0.5 * (res + (x / res))
        if media.fractionlen(nes - res) >= TOLERANCE then
            return objfloor:cround(nes, TOLERANCE)
        end
        res = nes
    end
    return objfloor:cround(res, TOLERANCE)
end

function media.unm(x)
    x.sign = x.sign == "-" and "+" or "-"
    return x
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

    sign = media.sign,  fact = media.fact,  pow = media.pow,
    max = media.max,    ln = media.ln,      floor = media.floor,
    min = media.min,    exp = media.exp,    cround = media.cround,

    ceil = media.ceil,  fmod = media.fmod,  unm = media.unm,
    modf = media.modf,  sqrt = media.sqrt,

    integerlen = media.integerlen,
    fractionlen = media.fractionlen,
    fdigitlen = media.fdigitlen,
}

do
    -- Build ENV --
    local _ENV = {
        smul = function(x, y)
            local x_sign, y_sign = x.sign or "+", y.sign or "+"
            return (#x_sign == 1 and x_sign or "+") == (#y_sign == 1 and y_sign or "+") and "+" or "-"
        end,
        vtype = media.vtype,
        modf = media.modf,

        cal = master.calculate,
        div = media.cdiv,
        unm = media.unm,

        equal = master.equation.equal,
        less = master.equation.less,
        more = master.equation.more,
        
        setmetatable = setmetatable,
        print = print
    }

    -- Build metatable --
    master._metatable = {

        -- Calculation operators --
        __add = function(x, y)
            x, y = _ENV.vtype(x, y)
            if x.sign == y.sign then
                local raw = _ENV.cal:add(x, y)
                raw.sign = x.sign or "+"
                return setmetatable(raw, master._metatable)
            end
            local reg = _ENV.more(x, y)
            local raw = _ENV.cal:sub(reg and x or y, reg and y or x)
            raw.sign = (reg and x or y).sign or "+"
            return setmetatable(raw, master._metatable)
        end,
        __sub = function (x, y)
            x, y = _ENV.vtype(x, y)
            local reg = _ENV.more(x, y)
            local raw = (x.sign == y.sign) and _ENV.cal:sub(reg and x or y, reg and y or x) or _ENV.cal:add(x, y)
            raw.sign = ((y.sign == "+" and reg) or (y.sign == "-" and not reg)) and "+" or "-"
            return setmetatable(raw, master._metatable)
        end,
        __mul = function(x, y)
            x, y = _ENV.vtype(x, y)
            local raw = _ENV.cal:mul(x, y)
            raw.sign = _ENV.smul(x, y)
            return setmetatable(raw, master._metatable)
        end,
        __div = _ENV.div,
        __unm = _ENV.unm,
        __mod = media.fmod,
        __pow = media.pow,
        __idiv = function(x, y)
            x, y = _ENV.vtype(x, y)
            local d, f = _ENV.modf(_ENV.div(x, y))
            local sign = _ENV.smul(x, y)
            local raw = sign == "-" and _ENV.more(f, _ENV.vtype(0)) and _ENV.cal:add(d, _ENV.vtype(1)) or d
            raw.sign = sign
            return setmetatable(raw, master._metatable)
        end,

        -- Equation operators --
        __eq = function(x, y)
            return _ENV.equal(_ENV.vtype(x, y))
        end,
        __lt = function(x, y)
            return _ENV.less(_ENV.vtype(x, y))
        end,
        __le = function(x, y)
            x, y = _ENV.vtype(x, y)
            return _ENV.equal(x, y) or _ENV.less(x, y)
        end,

        -- Misc --
        __tostring = media.tostring,
        __mode = "v",
        __name = "int object",

        -- Index --
        __index = mediaobj,
    }
end

local int = setmetatable({

    _defaultsize = master._config.SETINTEGER_PERBLOCK.DEFAULT,
    _VERSION = master._VERSION
}, {
    -- metatable --
    __index = mediaobj
})

int.new = function(...) -- (string|number) For only create. alway use default size! **BLOCK SIZE SHOULD BE SAME WHEN CALCULATE**
    local stack, em = {}, false
    for i, s in ipairs({...}) do
        stack[i], em = media.convert(s, int._defaultsize), true
    end
    if not em then
        return media.convert(0, int._defaultsize)
    end
    return table.unpack(stack)
end

int.cnew = function(number, size) -- (number:string|number, size:string|number) For setting a size per block. **BLOCK SIZE SHOULD BE SAME WHEN CALCULATE**
    return media.convert(number or 0, size and (tonumber(size) or master._config.SETINTEGER_PERBLOCK[size:upper()]) or int._defaultsize)
end

int.maxinteger = master._config.MAXIMUM_DIGIT_PERTABLE.INTEGER
int.maxfraction = master._config.MAXIMUM_DIGIT_PERTABLE.FRACTION

-- print(("MODULE LOADED\nMEMORY USAGE: %.0d B (%s KB)"):format(collectgarbage("count") * 1024, collectgarbage("count")))
return int