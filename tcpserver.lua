local socket = require("socket")

local function respondOnHello()
    local server = assert(socket.bind("*", 53444))
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
                break
            end
        end
        ::continue::
        if client then
            client:close()
        end
    end
end

local function respondAfterThousand()
    local server = assert(socket.bind("*", 53333))
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

respondOnHello()
--respondAfterThousand()
