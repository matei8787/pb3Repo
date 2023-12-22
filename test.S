.data
infile: .asciz "in.txt"
outfile: .asciz "out.txt"
readmode: .asciz "r"
writemode: .asciz "w"
ifilepointer: .space 1000
ofilepointer: .space 1000
mat: .space 1605
cmat: .space 1605
n: .space 4
m: .space 4
mp1: .space 4 ;// m plus 1
mp2: .space 4 ;// m plus 2
p: .space 4
k: .space 4
x: .space 4
y: .space 4
dx: .long -1, -1, 0, 1, 1, 1, 0, -1
dy: .long 0, 1, 1, 1, 0, -1, -1, -1
sCitire: .asciz "%ld%ld%ld"
sCitireCelula: .asciz "%ld%ld"
sCitireK: .asciz "%ld"
sAfisElem: .asciz "%ld "
endl: .asciz "\n"
.text
alocare_mat:
    push %ebp
    mov %esp, %ebp

    mov $20, %ecx
    xor %eax, %eax
    mov 8(%ebp), %edi

et_loop_linie:
    cmp %ecx, %eax
    jge et_ret
    mov $0, %ebx

et_loop_coloane:
    cmp %ecx, %ebx
    jge et_inc_i
    push %eax
    mov $0, %edx
    ;// %eax = %eax * n + %ebx
    mull %ecx
    ;// %eax = %eax * n
    add %ebx, %eax
    movl $0, (%edi, %eax, 4)
    pop %eax
    add $1, %ebx
    jmp et_loop_coloane

et_inc_i:
    add $1, %eax
    jmp et_loop_linie

et_ret:
    pop %ebp
    ret


citiresys:

    ;// deschid fisierele mai intai

    pushl $readmode
    pushl $infile
    call fopen
    pop %ebx
    pop %ebx
    mov %eax, ifilepointer

    pushl $writemode
    pushl $outfile
    call fopen
    pop %ebx
    pop %ebx
    mov %eax, ofilepointer

am_deschis:

    pushl $p
    pushl $m
    pushl $n
    pushl $sCitire
    pushl ifilepointer
    call fscanf
    pop %eax
    pop %eax
    pop %eax
    pop %eax
    pop %eax

citire1:

    movl m, %eax
    add $1, %eax
    movl %eax, mp1
    add $1, %eax
    movl %eax, mp2
   
    lea mat, %edi
    xor %ecx, %ecx
et_loop:
    cmp p, %ecx
    jge et_dupa

et_prev_scan:
    push %ecx
    pushl $y
    pushl $x
    pushl $sCitireCelula
    pushl ifilepointer
    call fscanf
    pop %eax
    pop %eax
    pop %eax
    pop %eax
et_dupa_scan:
    pop %ecx
et_dupa_pop:

    mov x, %eax
    add $1, %eax
    mull mp2
    addl y, %eax
    add $1, %eax
    movl $1, (%edi, %eax, 4)

    add $1, %ecx
    jmp et_loop


et_dupa:
    pushl $k
    pushl $sCitireK
    pushl ifilepointer
    call fscanf
    pop %eax
    pop %eax
    pop %eax
    ret


afisare_mat:
    push %ebp
    mov %esp, %ebp

    mov $1, %eax
    mov 8(%ebp), %edi
    mov n, %ecx
    mov m, %edx

et_loop_liniea:
    cmp n, %eax
    jg et_reta
    mov $1, %ebx

et_loop_coloanea:
    cmp m, %ebx
    jg et_inc_ia

    push %eax
    push %edx

    mov $0, %edx
    ;// %eax = %eax * (m + 1) + %ebx
    mull mp2
    ;// %eax = %eax * m
    add %ebx, %eax

    mov (%edi, %eax, 4), %edx
    pushl %edx
    pushl $sAfisElem
    pushl ofilepointer
    call fprintf
    popl %edx
    popl %edx
    popl %edx

    pushl $0
    call fflush
    popl %edx


    pop %edx
    pop %eax
    add $1, %ebx
    jmp et_loop_coloanea

et_inc_ia:

    push %eax
    push $endl
    pushl ofilepointer
    call fprintf
    popl %eax
    popl %eax

    pop %eax
    add $1, %eax
    jmp et_loop_liniea

et_reta:
    pop %ebp
    ret

copoazam1m2:  ;//din m1 in m2
    push %ebp
    mov %esp, %ebp

    ;//%eax = i, %ebx = j, %ecx = m1, %edi = m2
    mov 8(%ebp), %ecx
    mov 12(%ebp), %edi
    mov $0, %eax

et_start_loop_i:
    cmp n, %eax
    jg et_retu
    mov $1, %ebx

et_start_loop_j:
    cmp m, %ebx
    jg et_fin_loop_i
    push %eax
    push %ebx
    ;// nr = (i + 1) * m + j = (%eax + 1) * m + %ebx
    xor %edx, %edx
    mull mp2
    add %ebx, %eax
    mov (%ecx, %eax, 4), %ebx
    mov %ebx, (%edi, %eax, 4)


et_fin_loop_j:
    pop %ebx
    pop %eax
    add $1, %ebx
    jmp et_start_loop_j


et_fin_loop_i:
    add $1, %eax
    jmp et_start_loop_i

et_retu:
    pop %ebp
    ret

da_pozxy: ;//%eax = adresa lui mat[x][y]

    push %ebp
    mov %esp, %ebp

    mov  8(%ebp), %eax
    mov 12(%ebp), %ebx
luatxy:
    ;// %eax = ( %eax + 1 ) * n + %ebx
    xor %edx, %edx
    mull mp2
    add %ebx, %eax

et_ret_poz:
    pop %ebp
    ret


genereaza_pas:
    ;// eax = i, ebx = j


    mov $1, %eax

et_start_i:
    cmp n, %eax
    jg et_retgen
    mov $1, %ebx

et_start_j:
    cmp m, %ebx
    jg et_stop_i

    push %eax
    push %ebx
    xor %edx, %edx
    mull mp2
    add %ebx, %eax
    lea cmat, %edi
    lea mat, %esi
    mov (%edi, %eax, 4), %ebx
et_pre_moare:
    cmp $2, %ebx
    jge nu_subpop

et_moare:
    xor %ebx, %ebx
    mov %ebx, (%esi, %eax, 4)
    push %eax
et_eax:
    mov (%esi, %eax, 4), %eax
    pop %eax
    jmp et_stop_j


nu_subpop:
    cmp $3, %ebx
    jg nu_continua
    jmp decide_soarta

decide_soarta:
    cmp $3, %ebx
    jne et_stop_j

egal3:
    mov (%esi, %eax, 4), %edx
    cmp $1, %edx
    je et_stop_j
    mov $1, %edx
    mov %edx, (%esi, %eax, 4)
    jmp et_stop_j

nu_continua:
    xor %edx, %edx
    mov %edx, (%esi, %eax, 4)
    jmp et_stop_j

et_stop_j:
    pop %ebx
    pop %eax
    add $1, %ebx
    jmp et_start_j

et_stop_i:
    add $1, %eax
    jmp et_start_i

et_retgen:
    ret

determina_nrvec_xy:
    push %ebp
    mov %esp, %ebp

    mov 8(%ebp), %eax
    mov 12(%ebp), %ebx
    lea mat, %edi
    xor %edx, %edx
    mull mp2
    add %ebx, %eax
    ;// aici eax este cat trebuie sa adaug
et_cat_sa_adaug:
    xor %ecx, %ecx
    push %esi
    xor %esi, %esi

et_for_dir:
    cmp $8, %ecx
    jge et_bf_ret_det
et_dupa_jmp:
    push %eax
    push %ebx
    push %ecx
    push %edx
    push %ebp
    mov %eax, %ebx
    lea dx, %ebp
    mov (%ebp, %ecx, 4), %eax
    xor %edx, %edx
    imull mp2
    lea dy, %ebp
    add (%ebp, %ecx, 4), %eax
et_dupa_calcule:
    add %eax, %ebx
    mov %ebx, %eax
    mov (%edi, %eax, 4), %ebx
    cmp $1, %ebx
    jne et_stop_for_dir
    add $1, %esi

et_stop_for_dir:
    pop %ebp
    pop %edx
    pop %ecx
    pop %ebx
    pop %eax
    add $1, %ecx
    jmp et_for_dir    

et_bf_ret_det:
    mov %esi, %eax
    pop %esi


et_ret_det:
    pop %ebp
    ret

simuleaza_unpas:

    pushl $cmat
    call alocare_mat
    popl %eax
    
    mov $1, %eax

et_for_i:
    cmp n, %eax
    jg et_ret_sim

    mov $1, %ebx
et_for_j:
    cmp m, %ebx
    jg et_fin_for_i
    push %eax
    push %ebx
    push %ebx
    push %eax
    call determina_nrvec_xy
    pop %ebx
    pop %ebx
    mov %eax, %ecx
    pop %ebx
    pop %eax

dupa_dete:
    push %eax
    push %ebx
    push %ecx

    push %ebx
    push %eax
    call da_pozxy
    pop %ebx
    pop %ebx

    pop %ecx
    pop %ebx
    
copiere:
    lea cmat, %edi
    mov %ecx, (%edi, %eax, 4)

et_inc_j:
    pop %eax
    add $1, %ebx
    jmp et_for_j

et_fin_for_i:
    add $1, %eax
    jmp et_for_i

et_ret_sim:
    call genereaza_pas
    ret

    




.global main
main:
citire:
    pushl $mat
    call alocare_mat
    popl %eax
    call citiresys

rez:
    mov $1, %eax
et_final_loop:
    cmp k, %eax
    jg afisare
    push %eax
    call simuleaza_unpas
    pop %eax
    add $1, %eax
    jmp et_final_loop

afisare:
    pushl $mat
    call afisare_mat
    pop %eax

et_exit:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80