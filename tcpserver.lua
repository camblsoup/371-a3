local socket = require("socket")
local server = assert(socket.bind("*", 53333))
local ip, port = server:getsockname()

local function respondOnHello()
    while true do
        local client = server:accept()
        client:settimeout(10)
        local line, err = client:receive()
        if err then
            print(err)
            goto continue
        else
            print(line)
            if line == "hello TCP" then
                client:send("back at you TCP\n")
            end
        end
        ::continue::
        if client then
            client:close()
        end
    end
end

local function respondAfterThousand()
    local messageCount = 0
    local client = nil
    while not client do
        client = server:accept()
    end
    client:settimeout(20)
    while true do
        local line, err = client:receive()
        if not err then
            if messageCount == 1000 and line == "hello TCP" then
                client:send("back at you TCP\n")
                break
            elseif line == "hello TCP" then
                messageCount = messageCount + 1
                print(messageCount .. ": " .. line)
            end
        else
            print(err)
            break
        end
    end
    if client then
        client:close()
    end
end

respondAfterThousand()
-- respondOnHello()
