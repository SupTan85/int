local import_time = os.clock()
local int = require("int") -- import module

os.execute("cls")
print(("\nOpen TestSuite.\nUsing module version: %s (%s)"):format(int._VERSION or "UNKNOW", _VERSION))
print(("Import time: %ss"):format(tostring(os.clock() - import_time)))
local INT_LEN = arg[2] and tonumber(arg[2]:match("(%d+)$")) or 10
local DEC_LEN = arg[3] and tonumber(arg[3]:match("(%d+)$")) or 10
local SIMPLE_PERSUITE = arg[1] and tonumber(arg[1]:match("(%d+)$")) or 10

print(([[SETTING INFOMATION:
    << |INT_LEN| . |DEC_LEN| >>
    INT_LEN = %d,
    DEC_LEN = %d,

    SIMPLE_PERSUITE = %d]]):format(INT_LEN, DEC_LEN, SIMPLE_PERSUITE))

local function create_simple()
    local simple = {}
    for _ = 1, INT_LEN do
        local ran_num = math.random(0, 9)
        if #simple ~= 0 or ran_num ~= 0 then
            simple[#simple+1] = ran_num
        end
    end
    if DEC_LEN > 0 then
        simple[#simple+1] = "."
        for _ = 1, DEC_LEN do
            local ran_num = math.random(0, 9)
            if #simple ~= 0 or ran_num ~= 0 then
                simple[#simple+1] = ran_num
            end
        end
    end
    return int.new(table.concat(simple))
end

local function benchmark(head, function_call)
    print("SELECT FUNCTION: "..string.upper(head))
    local avg = {i = 0, avg = 0}
    local operation_start = os.clock()
    for i = 1, SIMPLE_PERSUITE do
        local x, y = create_simple(), create_simple()
        local start = os.clock()
        function_call(x, y)
        -- loading bar --
        local bar, res = ("|"):rep(math.floor((i / SIMPLE_PERSUITE) * 50)), os.clock() - start
        if avg.i >= 10 then
            avg.i = 0
        end
        avg[avg.i + 1], avg.i = res, avg.i + 1
        io.write("\r"..bar..(" "):rep(((5 - bar:len()) % 5) + 3), ("[%s] %.2f %% (%d ms) | using: %s"):format(i == SIMPLE_PERSUITE and "/" or ("/-\\|"):sub((((math.floor((i / SIMPLE_PERSUITE) * 500))) % 4) + 1, ((math.floor((i / SIMPLE_PERSUITE) * 500)) % 4) + 1), (i / SIMPLE_PERSUITE) * 100, math.floor(res * 1000), math.floor(collectgarbage("count") * 1024).." Byte"))
    end
    local operation_time = os.clock() - operation_start
    for _, v in ipairs(avg) do
        avg.avg = avg.avg + v
    end
    local per = math.floor((avg.avg / #avg) * 1000)
    print(("\nOperation time: %.3fs (%s per time)"):format(operation_time, (tostring(per) == "inf" and "> 1ms") or (tostring(per) == "0" and "< 1ms") or per.."ms"))
end

print("\nUsing Calculate-Suite")
benchmark("add", function(x, y)
    return x + y
end)
benchmark("sub", function(x, y)
    return x - y
end)
benchmark("mul", function(x, y)
    return x * y
end)
benchmark("div", function(x, y)
    return x / y
end)
benchmark("mod", function(x, y)
    return int.fmod(x, y)
end)
benchmark("pow", function(x, y)
    return x:pow(x.sign == "+" and y or y:floor())
end)
benchmark("sqrt", function(x, _)
    return x:sqrt()
end)
benchmark("ln", function(x, _)
    return x:ln()
end)
benchmark("exp", function(x, _)
    return x:exp()
end)

print("\nUsing Equation-Suite")
benchmark("equal", function(x, y)
    return x == y
end)
benchmark("less", function(x, y)
    return x < y
end)
benchmark("more", function(x, y)
    return x > y
end)
