local fs = require("@lune/fs")
local stdio = require("@lune/stdio")
local process = require("@lune/process")

local args = process.args

local a = table.find(args, "-a")
local file = args[#args]

if a then
    if #args == a then
        file = "."
    end
else
    if #args == 0 then
        file = "."
    end
end

local function out(file: string, isH: any?)
    if a and isH then
        stdio.write(stdio.color "blue")
        print(file)
        stdio.write(stdio.color "white")
    
        return
    end

    print(file)
end

local function ls(file: string)
    local h = process.exec("attrib", { process.cwd .. file }).stdout:match("H")
    if a then
        out(file, h)
    else
        if h then
            return
        end
        out(file)
    end
end

if file == "." then
    local dir = fs.readDir "."

    for i=1, #dir do
        ls(dir[i])
    end
else
    ls(file)
end
