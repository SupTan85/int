local int = require("int")
local loaded = os.clock()

os.execute("cls")
print(("\n>> Hello!\nUSING MODULE VERSION: %s (%s)"):format(int._VERSION, _VERSION))
local MAXLOOP = arg[1] and tonumber(arg[1]:match("(%d+)$")) or 2500
local ALLSAME = false
local n, c

local start = os.clock()
for i = 1, MAXLOOP do
    if not ALLSAME or not n or not c then
        if not ALLSAME then
            n, c = nil, nil
        end
        for _ = 1, 100 do
            n = (n or "")..math.random(9)
            c = (c or "")..math.random(9)
        end
    end
    local x, y = int.new(n, c)
    local result = x % y
    -- loading bar --
    local bar = ("|"):rep(math.floor((i / MAXLOOP) * 100))
    io.write("\r"..bar..(" "):rep(((5 - bar:len()) % 5) + 3), ("[%s] %.2f %% | using: %s"):format(i == MAXLOOP and "/" or ("/-\\|"):sub((((math.floor((i / MAXLOOP) * 500))) % 4) + 1, ((math.floor((i / MAXLOOP) * 500)) % 4) + 1), (i / MAXLOOP) * 100, math.floor(collectgarbage("count") * 1024).." Byte"))

    if result:eqmore(c) then
        print(n, c)
        break
    end
end

print(("\n\nModule load/Setup time: %.3fs\nOperation time: %.3fs (%d)\nGoodbye! <<"):format(loaded, os.clock() - start, MAXLOOP))
os.execute("pause")