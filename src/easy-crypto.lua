local stringutils = require "stringutils"
local knuth  = require "resty.nettle.knuth-lfib"
local yarrow = require "resty.nettle.yarrow"
local pbkdf2 = require "resty.nettle.pbkdf2"
local aes = require "resty.nettle.aes"

local KEY_BYTES = 32

local randomGen = yarrow.new(knuth.new(os.time()):random(32))

local EasyCrypto = {
  saltSize = 12,
  ivSize = 12,
  iterationCount = 10000
}

local function createEncryptedString(salt, iv, ciphertext, authTag)
  return salt .. iv .. stringutils.toHex(ciphertext) .. stringutils.toHex(authTag)
end

local function parseEncryptedString(encrypted, saltSize, ivSize)
  local salt = encrypted:sub(0, saltSize)
  local iv = encrypted:sub(saltSize + 1, saltSize + ivSize)
  local ciphertext = stringutils.fromHex(encrypted:sub(saltSize + ivSize + 1, encrypted:len() - KEY_BYTES))
  local authTag = stringutils.fromHex(encrypted:sub(encrypted:len() - KEY_BYTES + 1))

  return salt, iv, ciphertext, authTag
end

function EasyCrypto:new(config)
  ecrypto = ecrypto or {}
  setmetatable(ecrypto, self)
  self.__index = self
  return ecrypto
end

function EasyCrypto:encrypt(password, data)
  local salt = stringutils.toHex(randomGen:random(self.saltSize / 2))
  local hmac = stringutils.toHex(pbkdf2.hmac_sha256(password, self.iterationCount, salt, KEY_BYTES / 2))
  local iv = stringutils.toHex(randomGen:random(self.ivSize / 2))

  local aes256 = aes.new(hmac, "gcm", iv)
  local ciphertext, authTag = aes256:encrypt(data)

  return createEncryptedString(salt, iv, ciphertext, authTag), nil
end

function EasyCrypto:decrypt(password, encrypted)
  local salt, iv, ciphertext, authTag = parseEncryptedString(encrypted, self.saltSize, self.ivSize)

  local hmac = stringutils.toHex(pbkdf2.hmac_sha256(password, self.iterationCount, salt, KEY_BYTES / 2))
  local aes256 = aes.new(hmac, "gcm", iv)
  local decrypted, digest  = aes256:decrypt(ciphertext)

  if authTag == digest then
    return decrypted, nil
  else
    return nil, "authentication error"
  end
end

return EasyCrypto