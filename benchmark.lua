local log = io.open("benchmark.log", "w")
local print = function(...)
    if log then
        for _, v in ipairs({...}) do
            local value = tostring(v)
            local shift = 8 - (#value % 8)
            log:write(value..(" "):rep(shift))
        end
        log:write("\n")
    end
    print(...)
end

local int = require("int")
local loaded = os.clock()

os.execute("cls")
print(("\nUsing Benchmark.\nUsing module version: %s (%s)"):format(int._VERSION or "UNKNOW", _VERSION))
local MAXLOOP = arg[1] and tonumber(arg[1]:match("(%d+)$")) or 700
local ALLSAME = false
local n, c = {}, {}

local example_result = {}
local avg = {i = 0, avg = 0}
local operation_start = os.clock()
for i = 1, MAXLOOP do
    if not ALLSAME or not n or not c then
        if not ALLSAME then
            n, c = {}, {}
        end
        for _ = 1, arg[2] and tonumber(arg[2]:match("(%d+)$")) or 300 do
            n[#n + 1] = math.random(0, 9)
            c[#c + 1] = math.random(0, 9)
        end
    end
    local start = os.clock()
    local x, y = int.new(table.concat(n), table.concat(c))
    example_result[(#example_result % 10) + 1] = x % y
    -- loading bar --
    local bar, res = ("|"):rep(math.floor((i / MAXLOOP) * 50)), os.clock() - start
    if avg.i >= 10 then
        avg.i = 0
    end
    avg[avg.i + 1], avg.i = res, avg.i + 1
    io.write("\r"..bar..(" "):rep(((5 - bar:len()) % 5) + 3), ("[%s] %.2f %% (%d ms) | using: %s"):format(i == MAXLOOP and "/" or ("/-\\|"):sub((((math.floor((i / MAXLOOP) * 500))) % 4) + 1, ((math.floor((i / MAXLOOP) * 500)) % 4) + 1), (i / MAXLOOP) * 100, math.floor(res * 1000), math.floor(collectgarbage("count") * 1024).." Byte"))
    --[[
    if result:eqmore(c) then
        print(n, c)
        break
    end
    ]]
end
local operation_time = os.clock() - operation_start
for _, v in ipairs(avg) do
    avg.avg = avg.avg + v
end
local per = math.floor((avg.avg / #avg) * 1000)
print(("\n\nModule load/Setup time: %.3fs\nOperation time: %.3fs (%s per time)\nExample Result:\nindex\tvalue"):format(loaded, operation_time, tostring(per) == "inf" and "> 1ms" or per.."ms"))
for i, v in ipairs(example_result) do
    print(i, #v > 29 and tostring(v):sub(1, 29).."..." or v)
end
