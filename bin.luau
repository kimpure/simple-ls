local fs = require("@lune/fs")
local stdio = require("@lune/stdio")
local process = require("@lune/process")

local function print(...) 
    local t = table.pack(...)
    for i=1, t.n do
        stdio.write(t[i] .. " ")
    end
end

local args = process.args

local a = table.find(args, "-a")
local s = table.find(args, "-s")

local file 

if a then
    if #args == a then
        file = "."
    end
end

if s then
    if #args == a then
        file = "."
    end
end

if #args == 0 then
    file = "."
end

if file ~= "." then
    file = ""

    local n = #args

    if s then
        n -= 1
    end

    if a then
        n -= 1
    end

    for i=1, n do
        file ..= args[(#args - n) + i] .. " "
    end
end

local function out(file: string, isH: any?)
    if a and isH then
        stdio.write(stdio.color "blue")
        print(file)
        stdio.write(stdio.color "white")
    
        return
    end

    if fs.isDir(file) then
        stdio.write(stdio.color "cyan")
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
elseif s then
    local dir = fs.readDir "."
    local files = string.split(file, " ")

    for i=1, #dir do
        for j=1, #files do
            local t = string.match(dir[i], files[j])
            if t and t ~= '' then
                ls(dir[i])
            end
        end
    end
else
    local files = string.split(file, " ")
    for i=1, #files do
        local file = files[i]

        if file == '' then
            continue
        end
        
        if not fs.isFile(file) then
            continue
        end

        ls(files[i])
    end
end

if process.cwd:match("\\") then
    ls ".."
end
