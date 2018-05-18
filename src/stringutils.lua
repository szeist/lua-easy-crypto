local gsub = string.gsub
local byte = string.byte
local format = string.format

local stringutils = {}

function stringutils.toHex(str)
  return (str:gsub('.', function (c)
      return string.format('%02X', string.byte(c))
  end))
end

function stringutils.fromHex(str)
  return (str:gsub('..', function (cc)
      return string.char(tonumber(cc, 16))
  end))
end

return stringutils