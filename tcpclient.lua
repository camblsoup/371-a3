local socket = require("socket")
local ffi = require("ffi")

ffi.cdef [[
typedef long BOOL;
typedef long long LARGE_INT;
BOOL QueryPerformanceCounter(LARGE_INT *lpPerformanceCount);
BOOL QueryPerformanceFrequency(LARGE_INT *lpFrequency);
]]

local freq = ffi.new("LARGE_INT[1]")
ffi.C.QueryPerformanceFrequency(freq)
local function get_time()
    local counter = ffi.new("LARGE_INT[1]")
    ffi.C.QueryPerformanceCounter(counter)
    return tonumber(counter[0]) / tonumber(freq[0])
end

local client = assert(socket.tcp())
assert(client:connect("127.0.0.1", 53333))

local function queryOnce()
    local startTime = get_time()
    client:send("hello TCP\n")
    local line, err = client:receive()
    local endTime = get_time()
    print("Round Trip Time: " .. (endTime - startTime) * 1000 .. "ms")
    if client then
        client:close()
    end
    if not err then
        print(line)
    else
        print(err)
    end
end

local function quereyThousand()
    local startTime = get_time()
    for i = 0, 1000, 1 do
        client:send("hello TCP\n")
    end
    local line, err = client:receive()
    local endTime = get_time()
    print("Round Trip Time: " .. (endTime - startTime) * 1000 .. "ms")
    if client then
        client:close()
    end
    if not err then
        print(line)
    else
        print(err)
    end
end

-- queryOnce()
quereyThousand()
