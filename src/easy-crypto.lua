local rand = require "openssl.rand"
local cipher = require "openssl.cipher"
local sha256 = require "bgcrypto.sha256"
local base64 = require "base64"
local algo = 'aes-256-ctr'

local KEY_BYTES = 32

local EasyCrypto = {
  cipher = 'AES-256-CTR',
  saltSize = 12,
  ivSize = 16,
  iterationCount = 10000
}

local function createEncryptedString(salt, iv, ciphertext)
  return base64.encode(salt .. iv .. ciphertext)
end

local function parseEncryptedString(encryptedBase64, saltSize, ivSize)
  local encrypted = base64.decode(encryptedBase64)
  local salt = encrypted:sub(0, saltSize)
  local iv = encrypted:sub(saltSize + 1, saltSize + ivSize)
  local ciphertext = encrypted:sub(saltSize + ivSize + 1)

  return salt, iv, ciphertext
end

local ecrypto

function EasyCrypto:new(config)
  ecrypto = ecrypto or {}
  setmetatable(ecrypto, self)
  self.__index = self
  return ecrypto
end

function EasyCrypto:encrypt(password, data)
  local salt = rand.bytes(self.saltSize)
  local key = sha256.pbkdf2(password, salt, self.iterationCount, KEY_BYTES)
  local iv = rand.bytes(self.ivSize)

  local encrypted = cipher.new(self.cipher):encrypt(key, iv):final(data)

  return createEncryptedString(salt, iv, encrypted), nil
end

function EasyCrypto:decrypt(password, encrypted)
  local salt, iv, ciphertext = parseEncryptedString(encrypted, self.saltSize, self.ivSize)

  local key = sha256.pbkdf2(password, salt, self.iterationCount, KEY_BYTES)
  local decrypted = cipher.new(self.cipher):decrypt(key, iv):final(ciphertext)

  return decrypted, nil
end

return EasyCrypto