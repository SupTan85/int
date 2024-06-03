local int = require("int")

os.execute("cls")
print(("\n>> Hello!\nUSING MODULE VERSION: %s (%s)"):format(int._VERSION, _VERSION))

local MAXLOOP = 2500
local start = os.clock()
for i = 1, MAXLOOP do
    local n, c = "", ""
    for _ = 1, 100 do
        n = n..math.random(9)
        c = c..math.random(9)
    end
    local x, y = int.new(n, c)
    local result = x % y
    -- loading bar --
    local cdelay = os.clock()
    local bar = ("|"):rep(math.floor((i / MAXLOOP) * 100))
    io.write("\r"..bar..(" "):rep(((5 - bar:len()) % 5) + 3), ("[%s] %.2f %% | using: %s"):format(i == MAXLOOP and "/" or ("/-\\|"):sub((((math.floor((i / MAXLOOP) * 500))) % 4) + 1, ((math.floor((i / MAXLOOP) * 500)) % 4) + 1), (i / MAXLOOP) * 100, math.floor(collectgarbage("count") * 1024).." Byte"))

    if result:eqmore(c) then
        print(n, c)
        break
    end
end

print(("\n\nModule load/Setup time: %.3f s\nOperation time: %.3f s\nGoodbye! <<"):format(start, os.clock() - start))