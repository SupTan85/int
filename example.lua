local int = require("int")
local loaded = os.clock()

os.execute("cls")
print(("\n>> Hello!\nUSING MODULE VERSION: %s (%s)"):format(int._VERSION, _VERSION))
local MAXLOOP = arg[1] and tonumber(arg[1]:match("(%d+)$")) or 1000
local ALLSAME = false
local n, c = {}, {}

local avg = {i = 0, avg = 0}
for i = 1, MAXLOOP do
    if not ALLSAME or not n or not c then
        if not ALLSAME then
            n, c = {}, {}
        end
        for _ = 1, arg[2] and tonumber(arg[2]:match("(%d+)$")) or 1000 do
            n[#n + 1] = math.random(0, 9)
            c[#c + 1] = math.random(0, 9)
        end
    end
    local x, y = int.new(table.concat(n), table.concat(c))
    local start = os.clock()
    local result = x / y
    -- loading bar --
    local bar, res = ("|"):rep(math.floor((i / MAXLOOP) * 100)), os.clock() - start
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

for _, v in ipairs(avg) do
    avg.avg = avg.avg + v
end

local per = math.floor((avg.avg / #avg) * 1000)
print(("\n\nModule load/Setup time: %.3fs\nOperation time: %.3fs (%s per time)\nGoodbye! <<"):format(loaded, avg.avg, tostring(per) == "inf" and "> 1ms" or per.."ms"))
os.execute("pause")