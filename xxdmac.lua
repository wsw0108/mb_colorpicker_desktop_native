-- https://gist.github.com/cuhsat/cfa118f4398cae9e543b25cb5e19ecb6
local function xxd(input, outdir, name, ext)
    local HEADER = 'unsigned char %s[] = {\n'
    local FOOTER = '};\n'
    local LENGTH = 'unsigned int %s_len = %s;\n'

    -- Normalize filename
    local filename = name:gsub('%W', '_')

    -- Read file data
    local file = assert(io.open(input, 'rb'), 'File not found')
    local data = file:read('*all')
    file:close()

    local output = path.join(outdir, name .. ext)
    local ofile = assert(io.open(output, 'w'), "Can not write")

    -- Generate "xxd -i" compatible output
    ofile:write(HEADER:format(filename))

    for v = 1, #data do
      local b = string.format('0x%02x', data:byte(v))

      -- Indent block
      if v % 12 == 1 then
        b = '  ' .. b
      end

      -- Ignore comma for last byte
      if v < #data then
        b = b .. ', '
      end

      -- Add line break to line end
      if (v % 12 == 0) or (v == #data) then
        b = b .. '\n'
      end

      ofile:write(b)
    end

    ofile:write(FOOTER)
    ofile:write(LENGTH:format(filename, #data))
    ofile:close()

    return output
end

function main(target)
    local infile = "res/Mask@2+s.png"
    local name = "RES_Circle_Mask"
    local outfile = xxd(infile, "build", name, ".cxx")
    target:add("files", outfile)
end
