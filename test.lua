local int = require("int")

for i = 1, 2500 do
    local n, c = "", ""
    for _ = 1, 100 do
        n = n..math.random(9)
        c = c..math.random(9)
    end
    local x, y = int.new(n, c)
    local result = x % y
    print(("|"):rep((i * 100) // 2500), math.floor(collectgarbage("count") * 1024).." Byte")
    if result:eqmore(c) then
        print(n, c)
        break
    end
end

print("Operation time: "..os.clock())