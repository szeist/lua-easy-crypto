package = "lua-easy-crypto"
version = "0.0.1-1"
source = {
   url = "https://github.com/szeist/lua-easy-crypto",
   tag = "v0.0.1"
}
description = {
   summary = "Simple interface for password based AES-256-GCM encryption and decryption.",
   homepage = "https://github.com/szeist/lua-easy-crypto",
   license = "MIT"
}
dependencies = {
  "lua >= 5.1",
  "lua-resty-nettle == 0.105"
}
build = {
   type = "builtin",
   modules = {
     ["resty.easy-crypto"] = "src/easy-crypto.lua"
   }
}
