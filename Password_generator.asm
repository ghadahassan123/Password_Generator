.model small
.data                   
; Welcome page
a1 db 10,13,'                   ******************************************$'
a2 db 10,13,'                   **                 Welcome              **$'
a3 db 10,13,'                   **                    To                **$'
a4 db 10,13,'                   **            Password generation       **$'
a5 db 10,13,'                   **                  System              **$'
a6 db 10,13,'                   ******************************************$'

password db 256 dup(?)                        
prompt_msg db 10, 10, '                    Enter the length of the password: ', '$'
seed dw 0
choice db 10, "                          Your choice is : " ,'$'
pss_msg db 10,10,"                          Your Password is: ","$"
Regenerate db 10,10,'                   1.Regenerate password : $'
Exi db 10,10,'                   2.Exit: $'
.386
.code
main proc far
    .startup 

    ; Welcome page  
    mov ah, 9
    lea dx, a1
    int 21h
    lea dx, a2
    int 21h
    lea dx, a3
    int 21h
    lea dx, a4
    int 21h
    lea dx, a5
    int 21h
    lea dx, a6
    int 21h

    ; Set seed value
    mov ah, 2Ch     
    int 21h         
    mov [seed], dx 

    ; Input password length
    Mssg:
    mov ah, 09h                 
    lea dx, prompt_msg          
    int 21h
    
    mov ah, 01h                 
    int 21h                     
    sub al, '0' 
    movzx cx, al   ; Use movzx to zero-extend AL into CX

    ; Generate password
    lea si, password
    B:  
        call generate
        mov [si], dl
        inc si
        loop B
    
    mov byte ptr [si], '$'
    
    ; Display password
    lea dx, pss_msg
    mov ah, 09h
    int 21h
    
    lea dx, password
    mov ah, 09h
    int 21h
    
    ; User options
    mov ah, 09h
    lea dx, Regenerate
    int 21h

    mov ah, 09h
    lea dx, Exi
    int 21h

    mov ah, 09h
    lea dx, choice
    int 21h

    ; User choice
    mov ah, 01h
    int 21h
    sub al, '0'

    cmp al, 1
    je Mssg

    cmp al, 2
    je Exit

Exit:
    mov ah, 4Ch
    int 21h
  main endp

generate proc near
    mov ax, [seed]
    mov bx, 3         
    cwd  
    div bx
    mov dl, ah                  

    ; Select a character based on the remainder
    cmp dl, 0
    je generate_uppercase
    cmp dl, 1
    je generate_lowercase
    jmp generate_digit

generate_uppercase: 
    mov ax, [seed]
    mov bx, 26        
    cwd  
    div bx
    add ah, 'A'
    mov dl, ah
    mov dl, ah
    mul dl 
    mul bl 
    mov [seed], ax
    ret

generate_lowercase: 
    mov ax, [seed]
    mov bx, 26        
    cwd  
    div bx
    add ah, 'a'
    mov dl, ah
    mul dl
    mul bl
    mov [seed], ax
    ret

generate_digit: 
    mov ax, [seed]
    mov bx, 10        
    cwd  
    div bx
    add ah, '0'
    mov dl, ah
    mul dl
    mul bl
    mov [seed], ax
    ret

generate endp
end main
