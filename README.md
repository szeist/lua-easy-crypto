# lua-easy-crypto

Simple interface for password based AES-256-GCM encryption and decryption using the [lua-resty-nettle](https://github.com/bungle/lua-resty-nettle) library.

## Usage

```lua
local EasyCrypto = require "resty.easy-crypto"

local ecrypto = EasyCrypto:new({ -- Initialize with default values
  saltSize = 12,
  ivSize = 12,
  iterationCount = 10000
})

-- local ecrypto = EasyCrypto:new() -- Same as above

local encrypted = ecrypto:encrypt("password", "plain text")
local decrypted = ecrypto:decrypt("password", encrypted)

assert(encrypted == decrypted)
```