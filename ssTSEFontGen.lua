package.path = package.path .. ";libs/?.lua"

local json = require("json")
local struct = require("struct")

local textureName = "Display3-normal"
local texturePath = "Fonts\\" .. textureName .. ".tex"
local maxCharW = 17
local maxCharH = 16
local inFilePath = textureName .. ".json"
local outFilePath = textureName .. ".fnt"

local texturePathLen = #texturePath
local inFile = io.open(inFilePath, "r")
local encodedCharsData = inFile:read("*a")

inFile:close()

local charsData = json.decode(encodedCharsData)
local headerFmtStr = string.format("<c8Ic%dII", texturePathLen)
local packedHeader = struct.pack(
  headerFmtStr,
  "FTTFDFNM",
  texturePathLen,
  texturePath,
  maxCharW,
  maxCharH
)
local outFile = io.open(outFilePath, "wb")

outFile:write(packedHeader)

for _, charData in ipairs(charsData) do
  local x = charData["x"]
  local y = charData["y"]
  local w = charData["w"]
  local packedCharData = struct.pack("<IIII", x, y, 0, w)

  outFile:write(packedCharData)
end

outFile:close()
