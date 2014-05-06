BITS 32
  ; receives control from JMP NEAR at hook offset
  db '$ORIGINAL_BYTES$' ; to be replaced with original bytes, padd with NOP's
  pusha

push 0x000a214f
push 0x4c4c4548
mov ebx,1
mov eax,4
mov ecx,esp
mov edx,8

int 80h
add esp,8h
  popa
  mov esp, 0aa55aa55h   ; to be replaced with jmp (hook_offset + 5)
