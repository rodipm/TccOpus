import hashlib
import os

salt = os.urandom(32)

hex_str_salt = salt.hex()

res_salt = bytes.fromhex(hex_str_salt)


print(salt)
print(res_salt)
