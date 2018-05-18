local stringutils = require "stringutils"

describe("stringutils", function()

  describe("#toHex", function()

    it("converts bytes to hex string", function()
      local binaryString = '\2\10\15\127\255'
      local hexString = stringutils.toHex(binaryString)
      assert.is_equal('020A0F7FFF', hexString)
    end)

  end)

  describe("#fromHex", function()

    it("converts hex string to bytes", function()
      local hexString = '050CDF2E'
      local binaryString = stringutils.fromHex(hexString)
      assert.is_equal('\5\12\223\46', binaryString)
    end)

  end)

end)

