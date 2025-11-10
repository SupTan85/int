----------------------------------------------------
--                 ULTIMATE INT                   --
----------------------------------------------------
-- MODULE VERSION: 186
-- BUILD  VERSION: 186.5 (10/11/2025) dd:mm:yyyy
-- USER FEATURE: 08/11/2025
-- DEV  FEATURE: 08/11/2025
-- AUTHOR: SupTan85
-- LICENSE: MIT (the same license as Lua itself)
-- LINK: https://github.com/SupTan85/int.lua
-- 
----------------------------------------------------

local intcur =  -- 64 bit
                (string.format("%.0f", 2^63) == "9223372036854775808"   and     {9, "9223372036854775808"}) or -- Lua 5.2+
                (string.format("%.0f", 2^56) == "72057594037927936"     and     {8, "72057594037927936"})   or -- Lua 5.1
                -- 32 bit
                {4, "2147483648"}

local master = {
    _config = {
        SETINTEGER_PERCHUNK = {
            STABLE = 1,
            BALANCE = math.floor(intcur[1] / 2),
            FASTEST = intcur[1],

            DEFAULT = intcur[1], -- recommend
        },

        OPTION = {
            --[[ MASTER DIVISION | BYPASS GENERATE FLOATING POINT >>
                How dose it work :
                    Optimize the division process by reducing the number of loop iterations. However, this approach may not be effective for very large numbers.
                    note: Some version of lua is not support this feature.

                By SupTan85
            << BUILD-IN >>]]
            MASTER_CALCULATE_DIV_BYPASS_GEN_FLOATING_POINT = true,

            --[[ MASTER DIVISION | AUTO CONFIG ITERATIONS LIMIT >>
                How dose it work :
                    automatic setting a maxiumum of iterations in division function. *only when there is no self config value*
                    note: this option causes a division speed slow, but very powerful for high accuracy.

                // DISABLE : MASTER_CALCULATE_DIV_MAXITERATIONS
                By SupTan85
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
        MAXIMUM_SIZE_PERCHUNK = intcur[1], -- stable size is 9
        MAXIMUM_LUA_INTEGER = intcur[2] -- math.maxinteger
    },

    _VERSION = "186",
    _BUILD = "186.5"
}

local OPTION = master._config.OPTION
local ACCURACY_LIMIT = master._config.ACCURACY_LIMIT
local OBJECT_CODENAME = "int object"
local OBJECT_PROFILE = ({(OBJECT_CODENAME):gsub("%s+", "-")})[1] -- auto create profile

---@diagnostic disable-next-line: deprecated
table.unpack = table.unpack or unpack
local max, min, floor, ceil = math.max, math.min, math.floor, math.ceil

local function sign(number) -- Returns -1 if `x < 0`, 0 if `x == 0`, or 1 if `x > 0`.
    return (number == 0 and 0) or (number < 0 and -1 or 1)
end

local function istableobj(...) -- All value are table/int-object, else return false.
    for _, v in ipairs({...}) do
        local itype = type(v)
        if itype ~= "table" and itype ~= OBJECT_CODENAME then
            return false
        end
    end
    return true
end

master.convert = function(st, s)
    assert(type(st) == "string" or type(st) == "number", ("[CONVERT] INVALID_INPUT_TYPE | attempt to convert with a '%s'."):format(type(st)))
    st, s = tostring(st), s or 1
    assert(not (s <= 0), ("[CONVERT] SETTING_SIZE_ISSUE | size per chunk is less then one. (%s < 1)"):format(s))
    assert(not (s > master._config.MAXIMUM_SIZE_PERCHUNK), ("[CONVERT] INVALID_SIZE_PERCHUNK | size per chunk is more then maxiumum setting. (%s > %s)"):format(s, master._config.MAXIMUM_SIZE_PERCHUNK))
    local result, step = {_size = s}, 0
    local i, i2 = st:match("^0*(.-)%.(.-)0*$")
    i, i2 = (i or st):match("^0*(.-)$"):reverse(), (i2 or "")
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
    assert(istableobj(x or error("[DECONVERT] VOID_INPUT")), ("[DECONVERT] INVALID_INPUT_TYPE | attempt to deconvert with a '%s'."):format(type(x)))
    local em, sm, fm, s = false, {}, {}, x._size or 1
    for i = x._dlen or 1, 0 do
        local v = tostring(x[i] or error(("[DECONVERT] DAMAGED_OBJECT | missing decimal part value. index[%s]"):format(i)))
        assert(type(x[i]) == "number", ("[DECONVERT] DAMAGED_OBJECT | detected invalid type in decimal part data. index[%s]: integer (not %s)"):format(i, type(v)))
        if not em and x[i] <= 0 then
            x[i] = nil
        else
            sm[-i], em = tonumber(v) % 1 ~= 0 and error(("[DECONVERT] DAMAGED_OBJECT | data issue at decimal part value. index[%s]"):format(i)) or ("0"):rep(s - #v)..v, true
        end
    end
    em = false
    for i = #x, 1, -1 do
        local v = tostring(x[i] or error(("[DECONVERT] DAMAGED_OBJECT | missing integer path value. index[%s]"):format(i)))
        assert(type(x[i]) == "number", ("[DECONVERT] DAMAGED_OBJECT | detected invalid type in integer part data. index[%s]: integer (not %s)"):format(i, type(v)))
        if not em and x[i] <= 0 then
            x[i] = nil
        else
            fm[#fm+1], em = tonumber(v) % 1 ~= 0 and error(("[DECONVERT] DAMAGED_OBJECT | data issue at integer path value. index[%s]"):format(i)) or x[i+1] and ("0"):rep(s - #v)..v or v, true
        end
    end
    return (fm[1] and table.concat(fm) or "0")..(sm[0] and "."..table.concat(sm, "", 0):match("(%d-)0*$") or "")
end

master.copy = function(x)
    if type(x) == 'table' then
        local copy = {}
        for key, value in next, x, nil do
            copy[master.copy(key)] = master.copy(value)
        end
        setmetatable(copy, master.copy(getmetatable(x)))
        return copy
    end
    return x
end

local masterC, masterD = master.convert, master.deconvert
master.custom = {
    _cfloor = function(x, length, resultonly)
        local rev, dlen, prlen, s = length < 0, x._dlen or 1, nil, x._size or 1
        length = rev and math.abs(((dlen - 1) * s) + (s - #(tostring(x[dlen]):match("^(%d-)0*$") or ""))) + length or length
        local endp
        if rev or ceil(-length / s) > dlen - 1 then
            endp = ceil(-length / s)
            for i = dlen, min(endp, 0) do
                if i == endp then
                    local shift = tostring(x[i]):sub(1, length % s)
                    local hofu = tonumber(shift..("0"):rep(s - #shift))
                    prlen = prlen or #(tostring(x[i]):match("^(%d-)0*$") or "") - (length % s)
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
        if resultonly then
            return x
        end
        return x, endp or dlen, prlen
    end,

    _refresh = function(x, lu, endp) -- refresh all chunk that should to be, by fast `ADD` process.
        lu = lu or 0
        local s, endp = x._size or 1, endp or x._dlen or 1
        local re
        local ca, sl = tostring(x[endp]):match("(%d-)0*$"):sub(1, -2), floor(10 ^ s)
        re = tonumber(ca..("0"):rep(s - #ca)) + (lu * floor(10 ^ (s - #ca)))
        x[endp], lu = re % sl, floor(re / sl)
        if x[endp] == 0 then
            x._dlen, x[endp] = x._dlen + 1, nil
        end
        while lu ~= 0 do
            endp = endp + 1
            re = (x[endp] or 0) + lu
            x[endp], lu = re % sl, floor(re / sl)
            if x[endp] == 0 then
                x._dlen, x[endp] = x._dlen + 1, nil
            end
        end
        x._dlen = max(endp, x._dlen)
        return x
    end,

    _floor = function(x) -- Returns the largest integral value smaller than or equal to `x`.
        assert(istableobj(x or error("[FLOOR] VOID_INPUT")), ("[FLOOR] INVALID_INPUT_TYPE | x: table/%s (not %s)"):format(OBJECT_PROFILE, type(x)))
        for i = x._dlen or 1, 0 do
            x[i] = nil
        end
        x._dlen = 1
        return x
    end,

    cfloor = function(self, x, length) -- Custom a `x` decimal part. *use ":" to call a function*
        assert(type(length) == "number", ("[CFLOOR] INVALID_INPUT_TYPE | length: number (not %s)"):format(type(length)))
        assert(istableobj(x or error("[CFLOOR] VOID_INPUT")), ("[CFLOOR] INVALID_INPUT_TYPE | x: table/%s (not %s)"):format(OBJECT_PROFILE, type(x)))
        return self._cfloor(x, length, true)
    end,

    cround = function(self, x, length, center) -- Custom a `x` decimal part, with automatic round system. (`center` The number of rounding centers) *use ":" to call a function*
        assert(type(length) == "number", ("[CROUND] INVALID_INPUT_TYPE | length: number (not %s)"):format(type(length)))
        assert(istableobj(x or error("[CROUND] VOID_INPUT")), ("[CROUND] INVALID_INPUT_TYPE | x: table/%s (not %s)"):format(OBJECT_PROFILE, type(x)))
        local x, endp, prlen = table.unpack(length == -1 and {x, x._dlen or 1} or {self._cfloor(x, length + 1)})
        if prlen and prlen >= 0 then
            x = self._refresh(x, tostring(x[endp]):match("(%d)0*$") > (center and tostring(center) or "5") and 1 or 0, endp)
        end
        return x
    end
}

local custom = master.custom
master.equation = {
    equal = function(x, y) -- chunk size should be same
        assert((x._size or 1) == (y._size or 1), ("[EQUATION] INVALID_SIZE_PERCHUNK (%s, %s)"):format(x._size or 1, y._size or 1))
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
    less = function(x, y) -- chunk size should be same
        assert((x._size or 1) == (y._size or 1), ("[EQUATION] INVALID_SIZE_PERCHUNK (%s, %s)"):format(x._size or 1, y._size or 1))
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
    more = function(x, y) -- chunk size should be same
        return not master.equation.less(x, y) and not master.equation.equal(x, y)
    end
}

master.concat = {
    _creq = function(self, x, y, force)
        assert(type(self) == "table" and self._seek and self._deep, "[CONCAT] BAD_FUNCTIONCALL | can't include required function")
        assert(x and y, ("[CONCAT] VOID_INPUT |%s%s"):format(not x and " x: nil (input-required)" or "", not y and " y: nil (input-required)" or ""))
        assert(istableobj(x), ("[CONCAT] INVALID_INPUT_TYPE | x: table/%s (not %s)"):format(OBJECT_CODENAME, type(x)))
        assert(force or (istableobj(y) and (y._dlen or 1) >= 1) or (not istableobj(y) and tonumber(y) % 1 == 0), "[CONCAT] INVALID_INPUT | y: integer (not decimal)")
        return true
    end,

    _deep = function(var, reverse, dlen) -- Returns number of chunk, that are start first.
        -- BUILD 3
        local dlen = dlen or var._dlen or 1
        while var[dlen - 1] do
            dlen = dlen - 1
        end
        if reverse then
            for i = dlen, #var do
                if var[i] ~= 0 then
                    return i
                end
            end
        else
            for i = #var, dlen, -1 do
                if var[i] ~= 0 then
                    return i
                end
            end
        end
        var._dlen = dlen
        return 1
    end,

    _seek = function(var, reqsize, offset, reverse, ignore) -- set and gets number position.
        -- BUILD 3
        assert(var and reqsize, ("[SEEK] VOID_INPUT |%s%s"):format(not var and " var: nil (input-required)" or "", not reqsize and " reqsize: nil (input-required)" or ""))
        assert(tonumber(reqsize), ("[SEEK] INVALID_INPUT | reqsize: integer (not %s)"):format(type(reqsize)))
        reqsize = tonumber(reqsize)
        assert(reqsize % 1 == 0, "[SEEK] INVALID_INPUT | reqsize: integer (not decimal)")
        if reqsize <= 0 then
            return ""
        end
        offset = tonumber(offset) or 0
        assert(offset % 1 == 0, "[SEEK] INVALID_INPUT | offset: integer (not decimal)")
        if istableobj(var) then
            local result = {}
            local size, dlen = (var._size or 1), (var._dlen or 1)
            local shift, skip = offset % size, floor(offset / size)
            local index, pindex
            local lstart, vlen = dlen + skip, #var
            if offset > 0 and skip > 0 then
                if not reverse then
                    shift = (size - #tostring(var[vlen])) + shift
                elseif dlen < 1 then
                    local sel = tostring(var[dlen]):match("^.-(0*)$")
                    shift = #sel + shift
                end
            end
            for i = lstart, vlen do
                index = reverse and (index or 1) - 1 or (index or 0) + 1
                if reqsize < 1 then
                    break
                end
                local i = reverse and (dlen - i) + vlen or i
                local curr = tostring(var[i] or "")
                if i ~= vlen then
                    curr = ("0"):rep(size - #curr)..curr
                end
                if not ignore and i == dlen and dlen < 1 then
                    curr = curr:match("^(.-)0*$")
                end
                local bsize = #curr
                local include = curr:sub(reverse and -(shift + reqsize) or shift + 1, reverse and -(shift + 1) or shift + reqsize)
                if pindex or #include > 0 then
                    pindex = reverse and (pindex or 1) - 1 or (pindex or 0) + 1
                    result[pindex] = include
                end
                reqsize = reqsize - max(bsize - shift, 0)
                if shift > 0 then
                    shift = max(shift - bsize, 0)
                end
            end
            return table.concat(result, nil, reverse and pindex or nil)
        end
        local result = tostring(var)
        result = ignore and result:gsub("%.", "") or (result:match("^0*(%d+).?%d?") or "0")..(result:match("%d%.(%d*)0*$") or "")
        return result:sub(reverse and -(offset + reqsize) or offset + 1, reverse and -(offset + 1) or offset + reqsize)
    end,

    left = function(self, x, y, ignore, shift, copy, force)
        -- BUILD 3
        assert(type(self) == "table" and self._creq and self:_creq(x, y, force), "[CONCAT] BAD_FUNCTIONCALL | can't include required function")
        x = copy and master.copy(x) or x
        shift = max(tonumber(shift) or 0, 0)
        local i, istable = (not ignore and #x or self._deep(x)), istableobj(y)
        local size = x._size or 1
        local offset, ishift, skip = 0, shift % size, floor(shift / size)
        if shift > 0 and skip > 0 then
            if not ignore or (x._dlen or 1) >= 1 then
                ishift = (#tostring(x[i] or "") % size) + ishift
            elseif (x._dlen or 1) < 1 then
                ishift = (#tostring(x[(x._dlen or 1)]) % size) + ishift
            end
        end
        i = (#tostring(x[i]) >= size and i + 1 or i)
        for i = i, i + (skip - 1) do
            x[i] = x[i] or 0
        end
        i = i + skip
        repeat
            local curr = tostring(x[i] or "")
            if ignore and curr == "0" then
                curr = ""
            end
            if ishift > 0 then
                local zshift = min(size - #curr, ishift)
                curr = ("0"):rep(zshift)..curr
                ishift = max(ishift - zshift, 0)
            end
            local nreq = size - #curr - ishift
            local ireq = self._seek(y, nreq, offset, true, istable)
            x[i] = tonumber(ireq..curr) or 0
            i, offset = i + 1, offset + #ireq
        until #ireq ~= nreq and ishift <= 0
        return x
    end,

    right = function(self, x, y, ignore, shift, copy, force)
        -- BUILD 3
        assert(type(self) == "table" and self._creq and self:_creq(x, y, force), "[CONCAT] BAD_FUNCTIONCALL | can't include required function")
        x = copy and master.copy(x) or x
        shift = max(tonumber(shift) or 0, 0)
        local dlen = x._dlen or 1
        local i, istable = (not ignore and min(dlen, 0) or self._deep(x, true)), istableobj(y)
        local size, dhead, xlogic = x._size or 1, i, (dlen < 1 and #x <= 1)
        local offset, ishift, skip = 0, shift % size, floor(shift / size)
        if shift > 0 and skip > 0 then
            if ignore or xlogic then
                ishift = (size - #tostring(x[i]):match("^.-(0*)$")) + ishift
            end
        end
        for i = i, i - (skip - 1), -1 do
            x[i] = x[i] or 0
        end
        i = i - skip
        repeat
            local curr = tostring(x[i] or "")
            if i < dhead then
                curr = curr:match("^(.-)0*$")
            elseif ignore or xlogic then
                local raw = curr:match("^(.-)0*$")
                curr = ("0"):rep(size - #curr)..raw
            end
            if ishift > 0 then
                local zshift = min(size - #curr, ishift)
                curr = curr..("0"):rep(zshift)
                ishift = max(ishift - zshift, 0)
            end
            local nreq = size - #curr - ishift
            local ireq = self._seek(y, nreq, offset, false, istable)
            x[i] = tonumber(curr..ireq..("0"):rep(size - (#curr + #ireq))) or 0
            i, offset = i - 1, offset + #ireq
        until #ireq ~= nreq and ishift <= 0
        x._dlen = self._deep(x, true, i + 1)
        return x
    end,

    -- auto = function(self, x, y, ignore, force) -- *this function was update `x` not return new object*

    -- end
}

master.calculate = {
    _verify = function(a, b, MAXIUMUM_SIZE, CODE_NAME)
        assert(a and b, ("[%s] VOID_INPUT |%s%s"):format(CODE_NAME or "UNKNOW", not a and " a: nil (input-required)" or "", not b and " b: nil (input-required)" or ""))
        assert(istableobj(a, b), ("[%s] INVALID_INPUT |%s%s"):format(CODE_NAME or "UNKNOW", istableobj(a) and "" or (" a: table/%s (not %s)"):format(OBJECT_PROFILE, type(a)), istableobj(b) and "" or (" b: table/%s (not %s)"):format(OBJECT_PROFILE, type(b))))
        assert((a._size or 1) == (b._size or 1), ("[%s] INVALID_SIZE_PERCHUNK | _size: (%s != %s)"):format(CODE_NAME or "UNKNOW", a._size or 1, b._size or 1))
        assert(not ((a._size or 1) > MAXIUMUM_SIZE), ("[%s] INVALID_SIZE_PERCHUNK | _size: (%s > %s)"):format(CODE_NAME or "UNKNOW", a._size or 1, MAXIUMUM_SIZE))
    end,

    add = function(self, a, b, s)  -- _size maxiumum *2 **chunk size should be same**
        self._verify(a, b, master._config.MAXIMUM_SIZE_PERCHUNK * 2, "ADD")
        local result = {_size = a._size or s or 1}
        local s, c, d = floor(10 ^ (result._size)), false, false
        for i = min(a._dlen or 1, b._dlen or 1), max(#a, #b) do
            local chunk_result = (a[i] or 0) + (b[i] or 0)
            local next = floor(chunk_result / s)
            result[i + 1] = (next ~= 0 and next) or nil
            if i >= 1 or c == true or chunk_result ~= 0 then
                result[i], c = (chunk_result % s) + (result[i] or 0), true
                if d == false then
                    result._dlen = (i < 1 and i) or 1
                    d = true
                end
            end
        end
        return result
    end,
    sub = function(self, a, b, s)  -- _size maxiumum *2 (to use this function `a >= b` else result will been wrong!) **chunk size should be same**
        self._verify(a, b, master._config.MAXIMUM_SIZE_PERCHUNK * 2, "SUB")
        local result = {_size = a._size or s or 1}
        local s, d = floor(10 ^ (result._size)), false
        local bottom_trim = false
        for i = min(a._dlen or 1, b._dlen or 1), max(#a, #b) do
            local chunk_result = (a[i] or 0) - (b[i] or 0)
            local callback = (chunk_result % s) - (result[i] or 0)
            local chunk_data = callback % s
            bottom_trim = bottom_trim or chunk_data ~= 0
            result[i] = bottom_trim and chunk_data or nil
            if not d and bottom_trim then
                result._dlen, d = (i < 1 and i) or 1, true
            end
            result[i + 1] = (callback < 0 and (floor((callback % s) / s) + (((callback % s) ~= 0 and 1) or 0))) or nil
            result[i + 1] = (chunk_result < 0 and (result[i + 1] or 0) + (floor((chunk_result % s) / s) + (((chunk_result % s) ~= 0 and 1) or 0))) or result[i + 1]
        end
        for i = #result, 1, -1 do
            if result[i] == 0 then
                result[i] = nil
            else
                break
            end
        end
        result._dlen = result._dlen or 1
        return result
    end,
    mul = function(self, a, b, s, e) -- _size maxiumum *1 (`e` switch for division process.) **chunk size should be same**
        self._verify(a, b, master._config.MAXIMUM_SIZE_PERCHUNK, "MUL")
        local result = {_size = a._size or s or 1}
        local s, op = floor(10 ^ (result._size)), 1
        local cd
        for i = a._dlen or 1, #a do
            local BA = a[i]
            if BA and BA ~= 0 then
                for i2 = b._dlen or 1, #b do
                    local calcul, offset = BA * (b[i2] or 0), i + i2 - 1
                    local chunk_data = (calcul + (result[offset] or 0))
                    -- print(offset, ("%09d"):format(BA), ("%09d"):format(b[i2] or 0), "=", calcul, "+", result[offset] or 0, "=", chunk_data)
                    local next = floor(chunk_data / s)
                    chunk_data = chunk_data % s
                    if not cd then
                        cd = chunk_data ~= 0
                    end
                    result[offset] = (offset > 0 or cd) and chunk_data or nil
                    result[offset + 1], op = (next ~= 0 and (next + (result[offset + 1] or 0))) or ((offset > 0 or cd) and result[offset + 1] or 0) or result[offset + 1], result[offset] and min(op, offset) or op
                end
                if e and #result >= 1 then -- optimize zone for div function
                    if (#result == 1 and result[1] ~= 0) then
                        break
                    end
                    local inlogic = false
                    for i = #result, 2, -1 do
                        local curr = result[i]
                        if curr ~= 0 then
                            inlogic = true
                            break
                        else
                            result[i] = nil
                        end
                    end
                    if inlogic then
                        break
                    end
                end
            elseif i > 0 then
                result[i] = result[i] or 0
            end
        end
        for i = 0, op, -1 do
            if result[i] then
                break
            end
            result[i] = 0
        end
        for i = #result, 1, -1 do
            if result[i] == 0 then
                result[i] = nil
            else
                break
            end
        end
        result._dlen = op
        return result
    end,
    div = function(self, a, b, s, f, l) -- _size maxiumum *1 (`f` The maxiumum number of decimal part, `l` The maximum number of iterations to perform.) **chunk size should be same**
        self._verify(a, b, master._config.MAXIMUM_SIZE_PERCHUNK, "DIV")
        assert(not master.equation.equal(b, masterC(0, b._size or 1)), "[DIV] INVALID_INPUT | divisor cannot be zero.")
        local s, b_dlen, f = a._size or s or 1, b._dlen or 1, f or ACCURACY_LIMIT.MASTER_DEFAULT_FRACT_LIMIT_DIV
        local auto_acc, more, less, concat = not l and OPTION.MASTER_CALCULATE_DIV_AUTO_CONFIG_ITERATIONS, master.equation.more, master.equation.less, master.concat
        local one = masterC(1, s)
        local accuracy, uc = 0, 0
        local lastpoint, fin, mark
        b = self:mul(b, masterC("1"..("0"):rep(math.abs(b_dlen - 1)), b._size))
        local d = OPTION.MASTER_CALCULATE_DIV_BYPASS_GEN_FLOATING_POINT and (function(b)
            local p = b == "1" and "1.0" or tostring("1" / b)
            if p:find("e") then
                local L, R = p:match("^[-+]?(%d-%.?%d+)e"), p:match("e[-+]?(%d+)$")
                L, lastpoint = L:sub(1, -2), L:sub(-2, -2)
                local S = #L:match("^(%d+)%.")
                if R > master._config.MAXIMUM_LUA_INTEGER then
                    return {L:gsub("%.", ""), self.sub(masterC(R, s), masterC(S, s))}
                end
                return "0."..("0"):rep(tonumber(R) - S)..L:gsub("%.", ""):sub(1, -4)
            elseif p ~= "0.0" then
                lastpoint = p:sub(-1)
                if #p > 13 then
                    p = p:sub(1, -2)
                end
                lastpoint = #lastpoint == 1 and lastpoint
                return p
            end
        end)(masterD(b))
        if not d then
            local FLOAT = ((#b - 1) * s) + #tostring(b[#b]) - 2
            d = FLOAT > 0 and "0."..("0"):rep(FLOAT)
        end
        if auto_acc then
            local function HF(x)
                return (s - #tostring(x[#x])) + (x._dlen < 1 and s - #tostring(x[x._dlen] or "") or 0)
            end
            local AN, BN = (#a + math.abs((a._dlen or 1) - 1)) * s, (#b + math.abs(b_dlen - 1)) * s
            local NV = AN > BN
            if (NV and AN or BN) < tonumber(master._config.MAXIMUM_LUA_INTEGER) then
                accuracy, auto_acc = (NV and AN or BN) - HF(NV and a or b) + f + s, false
            else
                local AS, BS = self.add(masterC(#a, s), masterC(math.abs((a._dlen or 1) - 1), s)), self.add(masterC(#b, s), masterC(math.abs(b_dlen - 1), s))
                local MORE = more(AS, BS)
                accuracy = self.add(self.add(self.sub(self:mul((MORE and AS or BS), masterC(s, s)), masterC(HF(MORE and a or b), s)), masterC(f, s)), masterC(s, s))
            end
        else
            accuracy = (l or ACCURACY_LIMIT.MASTER_CALCULATE_DIV_MAXITERATIONS) + 1
        end
        local function check(n)
            local dc = d and setmetatable({}, {__index = d, __len = function() return #d end}) or masterC(n, s)
            local nc = self:mul(b, d and concat:right(dc, n, false, uc) or dc, s, true)
            -- print(n, masterD(nc))
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
                    map[i + 1] = (i % 2 ~= 0 and (c - ceil(i / 2)) or (c + ceil(i / 2))) % 10
                end
            else
                map = {0, 1, 9, 2, 8, 3, 7, 4, 6, 5}
            end
            local high, low, code
            for i = 1, 10 do
                local i = map[i]
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
            -- print(high, low, code)
            return false, low
        end
        if d then
            if istableobj(d) then
                local fp, bp = d[2], d[1]
                accuracy = auto_acc and self.sub(accuracy, bp) or accuracy - masterD(bp)
                d = {0, _size = s, _dlen = 1}
                local SIZE = masterC(s, s)
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
                d = d:sub(1, auto_acc and masterD(accuracy) or accuracy)
                accuracy = auto_acc and self.sub(accuracy, masterC(#d)) or accuracy - #d:match("%.(.+)$")
                d, lastpoint = masterC(d, s), lastpoint or d:match("(%d)0*$")
            end
        end
        while auto_acc and more(accuracy, masterC(0, s)) or not auto_acc and accuracy > 0 do
            local dv, lp = calcu(lastpoint)
            -- issue checker >>
            if not lp and master._config.OPTION.MASTER_CALCULATE_DIV_BYPASS_GEN_FLOATING_POINT then
                print(("[DIV] VALIDATION_FAILED | issues detected in division function, main process is unable to find the correct result.\n\tFUNCTION LOG >>\nprocess: (%s / %s)\nraw_data: %s\n"):format((a and masterD(a)) or "ERROR", (b and masterD(b)) or "ERROR", (d and masterD(d)) or "ERROR"))
                print("[DIV] VALIDATION_FAILED | issues detected in division function, main process is unable to find the correct result while using the option <MASTER_CALCULATE_DIV_BYPASS_GEN_FLOATING_POINT>.\nmodule will automatically disable this option permanent and recalculate the result again. some versions of Lua cannot using this option!\nset: master._config.OPTION.MASTER_CALCULATE_DIV_BYPASS_GEN_FLOATING_POINT = false\n")
                master._config.OPTION.MASTER_CALCULATE_DIV_BYPASS_GEN_FLOATING_POINT = false
                return master.calculate:div(a, b, s, f, l)
            end
            assert(lp, ("[DIV] VALIDATION_FAILED | issues detected in division function, main process is unable to find the correct result.\n\tFUNCTION LOG >>\nprocess: (%s / %s)\nraw_data: %s\n"):format((a and masterD(a)) or "ERROR", (b and masterD(b)) or "ERROR", (d and masterD(d)) or "ERROR"))
            -- print((d and masterD(d)) or "ERROR")
            -- issue checker <<
            d, lastpoint = d and concat:right(d, lp, false, uc) or not d and masterC(lp, s) or d, lp
            uc = lp == 0 and mark and (uc) + 1 or 0
            mark = mark or d ~= nil
            if dv then
                lastpoint = nil
                break
            end
            fin = fin or (masterD(d) or ""):match("^0*%.?0*$") == nil
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
            d = self:mul(d, masterC("1"..("0"):rep(math.abs(b_dlen - 1)), s))
        end
        local raw = self:mul(a, d)
        if lastpoint and -raw._dlen >= floor(f / s) then
            local shf = 0
            for i = 0, raw._dlen or 1, -1 do
                local sel = raw[i]
                if sel == 0 then
                    shf = shf + s
                else
                    shf = shf + s - #tostring(sel)
                    break
                end
            end
            raw = custom:cround(raw, shf + f)
        end
        return raw
    end,
}

local media = {
    assets = {
        FSZero = function(...) -- update sign to plus when number is zero, for fix issue *zero*
            local equal, pack, cahce = master.equation.equal, {...}, nil
            for i, v in ipairs(pack) do
                cahce = cahce or masterC(0, v._size)
                pack[i].sign = equal(v, cahce) and "+" or v.sign or "+"
            end
            return table.unpack(pack)
        end,
        EQMatch = function(n, e) -- check if n (int object) is equal e (number|string). *but not support decimal*
            if n._dlen < 1 then
                return false
            end
            e = tostring(e)
            local n_size = n._size
            local ipointer = 0
            local e_len = e:len()
            for i, v in ipairs(n) do
                local current_chunk = tostring(v)
                local current_cut = (i - 1) * n_size
                for i2 = 1, n_size do
                    ipointer = ipointer + 1
                    local cut_as = current_cut + i2
                    if ipointer > e_len or e:sub(ipointer, ipointer) ~= current_chunk:sub(cut_as, cut_as) then
                        return false
                    end
                end
            end
            return true
        end
    },

    convert = function(n, size) -- automatic setup a table.
        n = n or 0
        local n_type = type(n)
        assert(n_type == "string" or n_type == "number", ("[CONVERT] INVALID_INPUT_TYPE | n: string|number (not %s)"):format(n_type))
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
                local t = masterC(fs:match("^%s*[+-]?(%d+%.?%d*)%s*$"), size)
                t.sign = fs:match("^%s*([+-]?)") or "+"
                return setmetatable(t, master._metatable)
            end
            error(("[CONVERT] VALIDATION_FAILED | malformed number near '%s'"):format(n:match("^%s*(.-)%s*$")))
        end
        local t = masterC(n_type == "string" and n:match("^%s*[+-]?(%d+%.?%d*)%s*$") or math.abs(tonumber(n) or error(("[CONVERT] MALFORMED_NUMBER '%s'"):format(n))), size)
        t.sign = n_type == "string" and (n:match("^%s*([+-])") or "+") or sign(n) < 0 and "-" or "+"
        return setmetatable(t, master._metatable)
    end,
    tostring = function(int) -- Deconvert table to string.
        local str = masterD(int)
        return (int.sign == "-" and str ~= "0" and "-" or "")..str
    end,

    abs = function(x) -- Returns the absolute value of `x`.
        assert(istableobj(x), ("[ABS] INVALID_INPUT_TYPE | x: table/%s (not %s)"):format(OBJECT_PROFILE, type(x)))
        x.sign = "+"
        return setmetatable(x, master._metatable)
    end,

    fact = function(n, s) -- Factorial function
        local result
        if istableobj(n) then
            result = setmetatable(masterC("1", n._size), master._metatable)
            result.sign = "+"
        else
            n = setmetatable(masterC(n, s or master._config.SETINTEGER_PERCHUNK.DEFAULT), master._metatable)
            result = setmetatable(masterC("1", s or master._config.SETINTEGER_PERCHUNK.DEFAULT), master._metatable)
            n.sign, result.sign = "+", "+"
        end
        if n:eqmore(master._config.MAXIMUM_LUA_INTEGER) then
            while n > 0 do
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

    floor = function(x, length) -- Returns the largest integral value smaller than or equal to `x`, or Custom a `x` decimal part.
        if x.sign == "-" then
            if length then
                ---@diagnostic disable-next-line: param-type-mismatch
                return setmetatable(custom:cround(x, length, 0), master._metatable)
            end
            return -((x._dlen or 1) < 1 and 1 or 0) + setmetatable(custom._floor(x), master._metatable)
        end
        return setmetatable(length and custom:cfloor(x, length) or custom._floor(x), master._metatable)
    end,
    cround = function(x, length) -- Custom a `x` decimal part, with automatic round system.
        ---@diagnostic disable-next-line: param-type-mismatch
        return setmetatable(length and custom:cround(x, length) or custom._floor(x), master._metatable)
    end,

    ceil = function(x) -- Returns the smallest integral value larger than or equal to `x`.
        return ((x.sign or "+") == "+" and (x._dlen or 1) < 1 and 1 or 0) + setmetatable(custom._floor(x), master._metatable)
    end
}

local assets = media.assets
function media.equal(x, y) -- work same `equation.equal` but support sign config.
    local ze, equal = masterC(0, x._size), master.equation.equal
    return (equal(x, ze) and "+" or x.sign) == (equal(y, ze) and "+" or y.sign) and equal(x, y)
end
function media.less(x, y) -- work same `equation.less` but support sign config.
    local xs, ys = assets.FSZero(x, y)
    xs, ys = xs.sign, ys.sign
    local nox = xs ~= ys
    return nox and ys == "+" or (not nox and master.equation.less(x, y))
end
function media.more(x, y) -- work same `equation.more` but support sign config.
    local xs, ys = assets.FSZero(x, y)
    xs, ys = xs.sign, ys.sign
    local nox = xs ~= ys
    return nox and ys == "-" or (not nox and master.equation.more(x, y))
end

function media.integerlen(x) -- Returns number integer digits, that was in object.
    local le = #x
    return #tostring(x[le] or "") + ((media.convert(le, x._size) - 1):max(0) * x._size)
end
function media.decimallen(x) -- Returns number decimal digits, that was in object.
    local le = x._dlen or 1
    return le < 1 and #tostring(x[le] or ""):match("^(%d-)0*$") + ((media.convert(math.abs(le), x._size) - 1):max(0) * x._size) or media.convert(0, x._size)
end
function media.fdigitlen(x) -- Returns sum of number integer digits and number decimal digits.
    return media.integerlen(x) + media.decimallen(x)
end

function media.tonumber(x) -- Deconvert table to number. *not recommend*
    return tonumber(media.tostring(x))
end

function assets.vtype(...) -- asset for vtype function.
    local stack, v = {...}, {...}
    local SOFT, INTEGER = {table = 1}, master._config.SETINTEGER_PERCHUNK.DEFAULT
    table.sort(v, function(a, b) return (SOFT[type(a)] or 0) > (SOFT[type(b)] or 0) end)
    for _, s in ipairs(v) do
        if istableobj(s) then
            INTEGER = s._size or INTEGER
        else
            break
        end
    end
    for i, s in ipairs(stack) do
        local ty = type(s)
        if ty == "string" or ty =="number" then
            stack[i] = media.convert(s, INTEGER)
        elseif istableobj(s) then
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

function media.cdiv(x, y, f, l) -- Custom division function. (`f` The maxiumum number of decimal part, `l` The maximum number of iterations to perform.)
    assert(x and y, "[CDIV] VOID_INPUT")
    x, y = media.vtype(x, y)
    local raw = master.calculate:div(x, y, x._size, f, l)
    local x_sign, y_sign = x.sign or "+", y.sign or "+"
    raw.sign = (#x_sign == 1 and x_sign or "+") == (#y_sign == 1 and y_sign or "+") and "+" or "-"
    ---@diagnostic disable-next-line: param-type-mismatch
    return setmetatable(raw, master._metatable)
end

function media.sign(x) -- Returns -1 if x < 0, 0 if x == 0, or 1 if x > 0.
    assert(x, "[SIGN] VOID_INPUT")
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
    x = media.vtype(x) or error("[IN] VOID_INPUT")
    if tostring(x) <= "0" then
        assert(tostring(x) ~= "0", "[IN] INVALID_INPUT | Natural logarithm function return inf-positive value.")
        error("[IN] INVALID_INPUT | Natural logarithm function return non-positive value.")
    end
    local result = masterC(0, x._size)
    result.sign = "+"
    -- taylor series of logarithms --
    local X1 = (x - 1) / (x + 1)
    for n = 1, 1 + (2 * (l or ACCURACY_LIMIT.MEDIA_DEFAULT_NATURAL_LOGARITHM_MAXITERATIONS)), 2 do
        result = result + ((1 / n) * (X1 ^ n))
    end
    return setmetatable(custom:cfloor(result * 2, 15), master._metatable)
end

function media.exp(x, l) -- Exponential function. `l` The maximum number of iterations to perform.
    x = media.vtype(x) or error("[EXP] VOID_INPUT")
    local result = setmetatable(masterC(0, x._size), master._metatable)
    result.sign = "+"
    for n = 0, (l or ACCURACY_LIMIT.MEDIA_DEFAULT_EXPONENTIAL_MAXITERATIONS) - 1 do
        result = result + ((x ^ n) / media.fact(n, x._size))
    end
    return custom:cfloor(result, l or ACCURACY_LIMIT.MEDIA_DEFAULT_EXPONENTIAL_MAXITERATIONS)
end

function media.modf(x) -- Returns the integral part of `x` and the decimal part of `x`.
    x = media.vtype(x or error("[MODF] VOID_INPUT"))
    local frac = {sign = x.sign or "+", _dlen = x._dlen or 1, _size = x._size}
    for i = frac._dlen, 0 do
        frac[i] = x[i]
    end
    frac[1] = 0
    return setmetatable(custom._floor(x), master._metatable), setmetatable(frac, master._metatable)
end

function media.fmod(x, y) -- Returns the remainder of the division of `x` by `y` that rounds the quotient towards zero.
    assert(x and y, "[FMOD] VOID_INPUT")
    x, y = media.vtype(x, y)
    return x - (media.floor(x / y) * y)
end

function assets.vpow(self, x, y, l) -- pow function assets. `y >= 0`
    assert(x and y, "[VPOW] VOID_INPUT")
    assert(y.sign == "+" or (y._dlen >= 1 and #y <= 1 and (y[1] or 0) == 0), ("[VPOW] FUNCTION_NOT_SUPPORT | y (%s) is less then 0."):format(tostring(y)))
    if y._dlen >= 1 then
        if self.EQMatch(y, 0) then
            return media.convert(1, x._size)
        elseif self.EQMatch(y, 1) then
            return custom:cfloor(x, l)
        end
        local result = media.convert(1, x._size)
        local exp = y
        while master.equation.more(exp, masterC(0, x._size)) do
            if (exp[1] or 0) % 2 == 1 then
                result = result * x
            end
            x = x * x
            exp = master.custom._floor(exp / 2)
        end
        return result
    end
    return media.exp(y * media.ln(x))
end

function media.pow(x, y, f, l) -- Returns `x ^ y`. (`f` The maxiumum number of decimal part, `l` The maximum number of iterations to perform.)
    assert(x and y, "[POW] VOID_INPUT")
    x, y = media.vtype(x, y)
    if x.sign == "-" then
        assert(y._dlen >= 1, ("[POW] INVALID_INPUT | A negative base can only be raised to an integer exponent. (%s)"):format(tostring(y)))
        if (y[1] or 0) % 2 == 0 then
            x = media.unm(x)
        end
    end
    local y_sign = y.sign
    y.sign, l = "+", l or ACCURACY_LIMIT.MEDIA_DEFAULT_POWER_ACCURATE_LIMIT
    return y_sign == "-" and media.cdiv(1, assets:vpow(x, y, l), f or ACCURACY_LIMIT.MEDIA_DEFAULT_POWER_FRACT_LIMIT, l) or custom:cfloor(assets:vpow(x, y, l), l)
end

function media.sqrt(x, f, l) -- Returns the Square root of `x`. (`f` The maxiumum number of decimal part, `l` The maximum number of iterations to perform.)
    x = media.vtype(x or error("[SQRT] VOID_INPUT"))
    -- Newton's Method --
    assert(tostring(x) >= "0", "[SQRT] INVALID_INPUT | Cannot compute the square root of a negative number.")
    assert(not f or type(f) == "number", ("[SQRT] INVALID_INPUT_TYPE | Type of maxiumum number of decimal part should be integer (not %s)"):format(type(f)))
    local res = x / 2
    local TOLERANCE = f or ACCURACY_LIMIT.MEDIA_DEFAULT_SQRTROOT_TOLERANCE
    for _ = 1, l or ACCURACY_LIMIT.MEDIA_DEFAULT_SQRTROOT_MAXITERATIONS do
        local nes = 0.5 * (res + (x / res))
        local dl, tl = media.vtype(media.decimallen(nes - res), TOLERANCE)
        if dl >= tl then
            return custom:cround(nes, TOLERANCE)
        end
        res = nes
    end
    return custom:cround(res, TOLERANCE)
end

function media.unm(x) -- negation
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
    decimallen = media.decimallen,
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
        
        setmetatable = setmetatable
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
        __name = OBJECT_CODENAME,

        -- Index --
        __index = mediaobj,
    }
end

local int = setmetatable({

    _defaultsize = master._config.SETINTEGER_PERCHUNK.DEFAULT,
    _VERSION = master._VERSION
}, {
    -- metatable --
    __index = mediaobj
})

int.new = function(...) -- (string|number) For only create. alway use default size! **CHUNK SIZE SHOULD BE SAME WHEN CALCULATE**
    local stack, em = {}, false
    for i, s in ipairs({...}) do
        stack[i], em = media.convert(s, int._defaultsize), true
    end
    if not em then
        return media.convert(0, int._defaultsize)
    end
    return table.unpack(stack)
end

int.cnew = function(number, size) -- (number:string|number, size:string|number) For setting a size per chunk. **CHUNK SIZE SHOULD BE SAME WHEN CALCULATE**
    return media.convert(number or 0, size and (tonumber(size) or master._config.SETINTEGER_PERCHUNK[size:upper()]) or int._defaultsize)
end

-- print(("MODULE LOADED\nMEMORY USAGE: %.0d B (%s KB)"):format(collectgarbage("count") * 1024, collectgarbage("count")))
return int