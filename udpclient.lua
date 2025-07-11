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


local function queryOnce()
    local udp = socket.udp()
    udp:setpeername("127.0.0.1", 53444)

    local startTime = get_time()
    udp:send("hello UDP")
    local line, err = udp:receive()
    local endTime = get_time()
    print(line)
    if not err then
        print("Round Trip Time: " .. (endTime - startTime) * 1000 .. "ms")
    else
        print(err)
    end
end

local function queryThousand()
    local udp = socket.udp()
    udp:setpeername("127.0.0.1", 53444)

    local startTime = get_time()
    for i = 0, 1000, 1 do
        udp:send("hello UDP")
    end
    local line, err = udp:receive()
    local endTime = get_time()
    print(line)
    if not err then
        print("Round Trip Time: " .. (endTime - startTime) * 1000 .. "ms")
    else
        print(err)
    end
end


--queryOnce()
queryThousand()
