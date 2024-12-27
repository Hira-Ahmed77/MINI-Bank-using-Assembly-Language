org 100h
.model large
.stack 1000h
.data
    ;define variables
    m1  db 10,13,"         *******----WELCOME TO MINI BANK----******* $"
    m2  db 10,13,"                  PLEASE CHOOSE YOUR ROLE: $" 
    m3  db 10,13,"                  1.USER $"
    m4  db 10,13,"                  2.BANK EMPLOYEE $"
    m5  db 10,13,"         *******----------CUSTOMER----------******* $" 
    m6  db 10,13,"         *******--------BANK EMPLOYEE-------******* $"
    m7  db 10,13,"                  PLEASE ENTER YOUR ID: $"
    m8  db 10,13,"                  PLEASE ENTER YOUR PASSWORD: $"
    m9  db 10,13,"                  WE FOUND YOUR ACCOUNT$"
    m10 db 10,13,"                  INCORRECT INFORMATION$"
    m11 db 10,13,"                  ENTER USER ID TO KNOW THEIR BANK BALANCE $"
    m12 db 10,13,"                  1. WITHDRAW      2. CHECK BALANCE $"
    m13 db 10,13,"                  3. EXIT $"
    m14 db 10,13,"                  INSUFFICIENT AMOUNT$"
    m15 db 10,13,"                  CURRENT BALANCE IS --> $"
    m16 db 10,13,"                  ENTER YOUR AMOUNT $"
    m17 db 10,13,"                  DO YOU WANT TO CONTINUE ?  1.YES   2.NO $"
    m18 db 10,13,"                  Invalid Input !! Enter a Valid one....$"
    UID      db 1,2,3,4,5
    UPASS    db 1,2,3,4,5
    EID      db 6,7,8,9
    EPASS    db 6,7,8,9 
    BALANCE  db 2,4,6,8,0
    
    
.code
    main proc
        mov ax,@data
        mov ds,ax
        
        MAIN_FUNC:
        mov ah,2
        mov dl,10
        int 21h
        mov dl,13
        int 21h
        
        lea dx,m1
        mov ah,9
        int 21h
        
        lea dx,m2
        mov ah,9
        int 21h 
        
        lea dx,m3
        mov ah,9
        int 21h
        
        lea dx,m4
        mov ah,9
        int 21h
        
        ;role choosing             
        mov ah,1           
        int 21h
        sub al,48
        
        cmp al,1
        je USER         
        cmp al,2
        je EMP
        jmp INVALID
       
        ;customer   
        USER:
        mov ah,2
        mov dl,10
        int 21h
        mov dl,13
        int 21h 
                      
        lea dx,m5
        mov ah,9
        int 21h
    
        lea dx,m7
        mov ah,9
        int 21h  
       
        ;input
        mov ah,1           
        int 21h
        sub al,48
        mov bh,al 
        
        mov cx,5
        mov SI,0
       
        ;Finding user in array
        START1:           
        cmp bh,UID[SI]
        je FOUNDID
        add SI,1
        loop START1
        jmp ERRORID
       
        ;after finding the id
        FOUNDID:          
        lea dx,m8
        mov ah,9
        int 21h
        
        mov ah,1
        int 21h
        sub al,48
        mov ch,al
        
        cmp ch,UPASS[SI]
        je ACCOUNT
        jmp ERRORID
        
        ; 1.WITHDRAW   2.CHECK BALANCE
        ACCOUNT:
        lea dx,m12   
        mov ah,9
        int 21h
                                    
        lea dx,m13   ;EXIT
        mov ah,9
        int 21h
        
        ;input from ui
        mov ah,1
        int 21h
        sub al,48
        mov bh,al
        
        cmp bh,1
        je WITHDRAW
        cmp bh,2
        je BALANCEINFO_USER
        cmp bh,3
        je MAIN_FUNC
        jmp ACCOUNT   ;incorrect input from ui 
        
        ;entering amount to withdraw
        WITHDRAW:             
        lea dx,m16
        mov ah,9
        int 21h
        mov ah,1
        int 21h
        sub al,48
        mov bh,al
        
        cmp BALANCE[SI],bh
        jl INSUFF
        
        ;updating balance
        mov cl,BALANCE[SI]
        sub cl,bh
        mov BALANCE[SI],cl
        
        ;output
        lea dx,m15
        mov ah,9
        int 21h
        
        mov dl,BALANCE[SI]
        add dl,48
        mov ah,2
        int 21h
        jmp ACTION_USER
        
        ;to know balance
        BALANCEINFO_USER:  
        lea dx,m15
        mov ah,9
        int 21h
        
        mov dl,BALANCE[SI]
        add dl,48
        mov ah,2
        int 21h
        jmp ACTION_USER
        
        INSUFF:
        lea dx,m14
        mov ah,9
        int 21h
        jmp ACTION_USER
        
        ;bank employee
        EMP:
        mov ah,2
        mov dl,10
        int 21h
        mov dl,13
        int 21h 
                
        lea dx,m6
        mov ah,9
        int 21h
        
        ;enter your id
        lea dx,m7   
        mov ah,9
        int 21h
        
        mov ah,1
        int 21h
        sub al,48
        mov bh,al
        mov cx,5
        mov SI,0
        
        ;finding employee id in array
        START2:     
        cmp bh,EID[SI]
        je FOUNDID2
        add SI,1
        loop START2
        jmp ERRORID
        
        ;after finding the id
        FOUNDID2:   
        lea dx,m8
        mov ah,9
        int 21h
        
        mov ah,1
        int 21h
        sub al,48
        mov ch,al
        
        cmp ch,EPASS[SI]
        je FOUNDEMP
        jmp ERRORID
        
        ;enter user id to know their bb
        FOUNDEMP:
        lea dx,m11  
        mov ah,9
        int 21h
        
        mov ah,1
        int 21h
        sub al,48
        mov bh,al
        
        mov cx,5
        mov SI,0
        
        ;finding user id in array
        START3:     
        cmp bh,UID[SI]
        je BALANCEINFO_EMP
        add SI,1
        loop START3
        jmp ERRORID
        
        BALANCEINFO_EMP:
        lea dx,m15
        mov ah,9
        int 21h
        
        mov dl,BALANCE[SI]
        add dl,48
        mov ah,2
        int 21h
        jmp ACTION_EMP
        
        ;error handling for id
        ERRORID:    
        lea dx,m10
        mov ah,9
        int 21h
        jmp ACTION_ERROR
                                               
        ;wanna cont after error
        ACTION_ERROR: 
        lea dx,m17
        mov ah,9
        int 21h
        
        mov ah,1
        int 21h
        sub al,48
        mov bh,al
        
        cmp bh,1
        je MAIN_FUNC
        cmp bh,2
        je EXIT
        
        ;wanna cont for employee
        ACTION_EMP: 
        lea dx,m17
        mov ah,9
        int 21h
        
        mov ah,1
        int 21h
        sub al,48
        mov bh,al
        
        cmp bh,1
        je FOUNDEMP
        cmp bh,2
        je MAIN_FUNC
        
        ;wanna cont for user
        ACTION_USER:    
        lea dx,m17
        mov ah,9
        int 21h
        
        mov ah,1
        int 21h
        sub al,48
        mov bh,al
        
        cmp bh,1
        je ACCOUNT
        cmp bh,2
        je MAIN_FUNC 
        
        INVALID:
        lea dx,m18
        mov ah,9
        int 21h
        
        jmp MAIN_FUNC
        
        EXIT:
        mov ah,4ch
        int 21h
        main endp
    end main            