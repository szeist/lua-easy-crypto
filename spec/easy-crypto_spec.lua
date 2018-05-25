require 'luarocks.loader'
local base64 = require "base64"
local EasyCrypto = require "easy-crypto"

SALT_SIZE = 12
IV_SIZE = 12

describe("easy-crypto", function()

  describe("#encrypt", function()

    it("uses different salt on each encryption call", function()
      ecrypto = EasyCrypto:new({
        saltSize = SALT_SIZE
      })
      local first_ciphertext = base64.decode(ecrypto:encrypt("password", "plain text"))
      local second_ciphertext = base64.decode(ecrypto:encrypt("password", "plain text"))
      local first_salt = first_ciphertext:sub(0, SALT_SIZE)
      local second_salt = second_ciphertext:sub(0, SALT_SIZE)
      assert.are_not.equal(first_salt, second_salt)
    end)

    it("uses different iv on each encryption call", function()
      ecrypto = EasyCrypto:new({
        saltSize = 12
      })
      local first_ciphertext = base64.decode(ecrypto:encrypt("password", "plain text"))
      local second_ciphertext = base64.decode(ecrypto:encrypt("password", "plain text"))
      local first_iv = first_ciphertext:sub(SALT_SIZE + 1, SALT_SIZE + IV_SIZE)
      local second_iv = second_ciphertext:sub(SALT_SIZE + 1, SALT_SIZE + IV_SIZE)
      assert.are_not.equal(first_iv, second_iv)
    end)
  end)

  describe("#decrypt", function()

    it("successfully decrypts the encrypted data with the correct password", function()
      ecrypto = EasyCrypto:new()
      local ciphertext = ecrypto:encrypt("password", "plain text")
      local decrypted = ecrypto:decrypt("password", ciphertext)
      assert.is_equal("plain text", decrypted)
    end)

    -- it("returns error with wrong password", function()
    --   ecrypto = EasyCrypto:new()
    --   local ciphertext = ecrypto:encrypt("password", "plain text")
    --   local decrypted, err = ecrypto:decrypt("wrong password", ciphertext)
    --   assert.is_nil(decrypted)
    --   assert.is_equal("authentication error", err)
    -- end)

    -- it("returns error with tampered message", function()
    --   ecrypto = EasyCrypto:new()
    --   local ciphertext = ecrypto:encrypt("password", "plain text")
    --   local ciphertext_start = SALT_SIZE + IV_SIZE + 1
    --   local tampered_ciphertext = ciphertext:sub(0, ciphertext_start) .. '000' .. ciphertext:sub(ciphertext_start + 3 + 1)
    --   local decrypted, err = ecrypto:decrypt("password", tampered_ciphertext)
    --   assert.is_nil(decrypted)
    --   assert.is_equal("authentication error", err)
    -- end)

  end)

end)