local socket = require("socket")

local function respondOnHello()
    local udp = assert(socket.udp())
    assert(udp:setsockname("0.0.0.0", 53444))
    while true do
        local line, ip, port = udp:receivefrom()
        if line == "hello UDP" then
            udp:sendto("back at you UDP", ip, port)
            print(line)
            break
        end
    end
end

local function respondAfterThousand()
    local udp = assert(socket.udp())
    assert(udp:setsockname("0.0.0.0", 53444))

    local messageCount = 0
    while true do
        local line, ip, port = udp:receivefrom()
        if messageCount == 1000 and line == "hello UDP" then
            udp:sendto("back at you UDP", ip, port)
            break
        elseif line == "hello UDP" then
            messageCount = messageCount + 1
        end
    end
end

--respondOnHello()
respondAfterThousand()
