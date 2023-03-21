.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem msvcrt.lib, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern printf: proc
extern scanf: proc
extern fscanf: proc
extern fprintf: proc
extern fclose: proc
extern strchr: proc
extern strstr: proc
extern fopen: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
aux dd 0
MatrixA DD 100 dup(0)
MatrixB DD 100 dup(0)
MatrixAux1 DD 100 dup(0)
MatrixAux2 DD 100 dup(0)
DimA DD 0
DimB DD 0

TextOP DB "Introduceti o operatie cu matrici",10,13,0

TextA DB "A=",10,13,0
FisierA DB "12345689101112",0
TextB DB "B=",10,13,0
FisierB DB "12345689101112",0
OPRIRE DD 1
FORMAT DB "%s",0
rezultat DB "Rezultat: rezultat.txt",10,13,0
FORMATINT DB "%d",0

Inceput1 db "..............................................................",10,13,0
Inceput2 db "Pentru utilizarea programul se vor folosi urmatoarele notatii:",10,13,0
Inceput3 db "Adunare : A+B",10,13,0
Inceput4 db "Scadere : A-B",10,13,0
Inceput5 db "Transpusa: At",10,13,0
Inceput6 db "Determinantul: det(A)",10,13,0
Inceput7 db "Inmultire cu scalar : aA, valoare lui a se va tasta ulterior",10,13,0
TextFinal db "Doriti alta operatie? Apasati tasta 1 pentru a continua, tasta 0 pentru a opri aplicatia",10,13,0
Text_SCALAR DB "a=",0

PLUS dd 43
MINUS dd 45
sc dd 97
tr dd 116
det dd 100
scalar dd 0
rez_det dd 0

patru dd 4

REZ DD 0
mod_citire DB "r",0
mod_scriere DB "w",0
FORMATFLOAT DB "%f",0
FormatIntScriere DB"%d ",0 
fisier_final DB "rezultat.txt",0
IntEnd DB "%d",10,13,0
Endline DB 10,0
mesaj_eroare DB "EROARE",10,13,0
OPERATIE DB "0",0

.code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
citire MACRO Fisier, dimensiune, matrice,aux
local loop_for1,loop_for2
push offset mod_citire
push offset Fisier
call fopen
add esp,8

mov EBX,EAX
;pointer la file

push offset dimensiune
push offset FORMATINT
push EBX
call fscanf
add esp,12

mov ESI,0
loop_for1:
mov EDI,0
loop_for2:
push offset aux
push offset FORMATINT
push EBX
call fscanf
add esp,12

mov ecx,aux
mov eax,dimensiune
mul ESI
mul patru
mov edx,eax
mov matrice[EDX+4*EDI],ecx
;matrice[ESI*dimensiune*4+4*EDI]
;push matrice[EDX+4*EDI]
;push offset FormatIntScriere
;call printf
;add esp,8

inc EDI
cmp EDI,dimensiune
JNE loop_for2
inc esi
cmp ESI, dimensiune
JNE loop_for1

push EBX
call fclose
add esp,4

ENDM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
inmultire_scalar PROC
	push EBP
	mov EBP,ESP

	push offset mod_scriere
	push offset fisier_final
	call fopen
	add esp,8
	mov ebx,eax
	
	push DimA
	push offset FormatIntScriere
	push EBX
	call fprintf
	add esp,12
	
	mov EDI,0
for1:
	push offset Endline
	push EBX
	call fprintf
	add esp,8
	mov ESI,0
for2:
	mov eax,DimA
	mul EDI
	mul patru
	mov edx,eax
	mov EAX,MatrixA[EDX+4*ESI]
	mul scalar
	mov aux,eax
	
	;push MatrixA[EDX+4*EDI]
	;push offset FormatIntScriere
	;call printf
	;add esp,8
	
	push aux
	push offset FormatIntScriere
	push EBX
	call fprintf
	add esp,12
	
	inc ESI
	cmp ESI, DimA
	JNE for2
	inc EDI
	cmp EDI, DimA
	JNE for1
final_ad:
	mov ESP,EBP
	pop EBP
	ret
inmultire_scalar ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
transpusa PROC
	push EBP
	mov EBP,ESP

	push offset mod_scriere
	push offset fisier_final
	call fopen
	add esp,8
	mov ebx,eax
	
	push DimA
	push offset FormatIntScriere
	push EBX
	call fprintf
	add esp,12
	
	mov EDI,0
for1:
	push offset Endline
	push EBX
	call fprintf
	add esp,8
	mov ESI,0
for2:
	mov eax,DimA
	mul ESI
	mul patru
	mov edx,eax
	mov EAX,MatrixA[EDX+4*EDI]
	
	mov aux,eax
	
	;push MatrixA[EDX+4*EDI]
	;push offset FormatIntScriere
	;call printf
	;add esp,8
	
	push aux
	push offset FormatIntScriere
	push EBX
	call fprintf
	add esp,12
	
	inc ESI
	cmp ESI, DimA
	JNE for2
	inc EDI
	cmp EDI, DimA
	JNE for1
final_ad:
	mov ESP,EBP
	pop EBP
	ret
transpusa ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
adunare PROC
	push EBP
	mov EBP,ESP
	mov EDX,DimA
	cmp EDX,DimB
	JE continuare_ad
	push offset mesaj_eroare
	call printf
	add esp,4
	jmp final_ad

continuare_ad:
	push offset mod_scriere
	push offset fisier_final
	call fopen
	add esp,8
	mov ebx,eax
	
	push DimA
	push offset FormatIntScriere
	push EBX
	call fprintf
	add esp,12
	
	mov EDI,0
for1:
	push offset Endline
	push EBX
	call fprintf
	add esp,8
	mov ESI,0
for2:
	mov eax,DimA
	mul EDI
	mul patru
	mov edx,eax
	mov EAX,MatrixA[EDX+4*ESI]
	mov aux,EAX
	mov EAX,MatrixB[EDX+4*ESI]
	add aux,EAX
	
	
	;push MatrixA[EDX+4*EDI]
	;push offset FormatIntScriere
	;call printf
	;add esp,8
	
	;push MatrixB[EDX+4*EDI]
	;push offset FormatIntScriere
	;call printf
	;add esp,8
	
	push aux
	push offset FormatIntScriere
	push EBX
	call fprintf
	add esp,12
	
	inc ESI
	cmp ESI, DimA
	JNE for2
	inc EDI
	cmp EDI, DimA
	JNE for1
final_ad:
	mov ESP,EBP
	pop EBP
	ret
adunare ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scadere PROC
	push EBP
	mov EBP,ESP
	mov EDX,DimA
	cmp EDX,DimB
	JE continuare_ad
	push offset mesaj_eroare
	call printf
	add esp,4
	jmp final_ad

continuare_ad:
	push offset mod_scriere
	push offset fisier_final
	call fopen
	add esp,8
	mov ebx,eax
	
	push DimA
	push offset FormatIntScriere
	push EBX
	call fprintf
	add esp,12
	
	mov EDI,0
for1:
	push offset Endline
	push EBX
	call fprintf
	add esp,8
	mov ESI,0
for2:
	mov eax,DimA
	mul EDI
	mul patru
	mov edx,eax
	mov EAX,MatrixA[EDX+4*ESI]
	mov aux,EAX
	mov EAX,MatrixB[EDX+4*ESI]
	sub aux,EAX
	
	;push MatrixA[EDX+4*EDI]
	;push offset FormatIntScriere
	;call printf
	;add esp,8
	
	;push MatrixB[EDX+4*EDI]
	;push offset FormatIntScriere
	;call printf
	;add esp,8
	
	push aux
	push offset FormatIntScriere
	push EBX
	call fprintf
	add esp,12
	
	inc ESI
	cmp ESI, DimA
	JNE for2
	inc EDI
	cmp EDI, DimA
	JNE for1
final_ad:
	mov ESP,EBP
	pop EBP
	ret
scadere ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
determinant PROC
	push EBP
	mov EBP,ESP
	cmp dimA,2
	je det2
	cmp dimA,3
	je det3
	push offset mesaj_eroare
	call printf
	add esp,4
	jmp final
det2:
	push offset mod_scriere
	push offset fisier_final
	call fopen
	add esp,8
	mov ebx,eax

	mov eax,dimA
	mul patru
	mov edx,eax
	mov eax,MatrixA[EDX+4]
	mul MatrixA[0]
	mov rez,eax
	
	mov eax,dimA
	mul patru
	mov edx,eax
	mov eax,MatrixA[EDX]
	mul MatrixA[4]
	sub rez,eax
	
	push rez
	push offset FormatIntScriere
	push ebx
	call fprintf
	add esp,12
	
	jmp final
det3:
	push offset mod_scriere
	push offset fisier_final
	call fopen
	add esp,8
	mov ebx,eax
	;;;1
	mov EAX,0
	mul dimA
	mul patru
	mov ECX,EAX
	mov EDX,MatrixA[ECX+0]
	mov aux,EDX
	;
	mov EAX,1
	mul dimA
	mul patru
	mov ECX,EAX
	mov EDX,MatrixA[ECX+4]
	mov EAX,aux
	mul EDX
	mov aux,EAX
	;
	mov EAX,2
	mul dimA
	mul patru
	mov ECX,EAX
	mov EAX,MatrixA[ECX+8]
	mul aux
	;
	mov rez,eax
	;;;2
	mov EAX,0
	mul dimA
	mul patru
	mov ECX,EAX
	mov EDX,MatrixA[ECX+4]
	mov aux,EDX
	;
	mov EAX,1
	mul dimA
	mul patru
	mov ECX,EAX
	mov EDX,MatrixA[ECX+8]
	mov EAX,aux
	mul EDX
	mov aux,EAX
	;
	mov EAX,2
	mul dimA
	mul patru
	mov ECX,EAX
	mov EAX,MatrixA[ECX+0]
	mul aux
	;;
	add rez,eax
	;;;3
	mov EAX,1
	mul dimA
	mul patru
	mov ECX,EAX
	mov EDX,MatrixA[ECX+0]
	mov aux,EDX
	;
	mov EAX,2
	mul dimA
	mul patru
	mov ECX,EAX
	mov EDX,MatrixA[ECX+4]
	mov EAX,aux
	mul EDX
	mov aux,EAX
	;
	mov EAX,0
	mul dimA
	mul patru
	mov ECX,EAX
	mov EAX,MatrixA[ECX+8]
	mul aux
	;;
	add rez,eax
	;;;4
	mov EAX,0
	mul dimA
	mul patru
	mov ECX,EAX
	mov EDX,MatrixA[ECX+8]
	mov aux,EDX
	;
	mov EAX,1
	mul dimA
	mul patru
	mov ECX,EAX
	mov EDX,MatrixA[ECX+4]
	mov EAX,aux
	mul EDX
	mov aux,EAX
	;
	mov EAX,2
	mul dimA
	mul patru
	mov ECX,EAX
	mov EAX,MatrixA[ECX+0]
	mul aux
	;;
	sub rez,eax
	;;;5
	mov EAX,0
	mul dimA
	mul patru
	mov ECX,EAX
	mov EDX,MatrixA[ECX+4]
	mov aux,EDX
	;
	mov EAX,1
	mul dimA
	mul patru
	mov ECX,EAX
	mov EDX,MatrixA[ECX+0]
	mov EAX,aux
	mul EDX
	mov aux,EAX
	;
	mov EAX,2
	mul dimA
	mul patru
	mov ECX,EAX
	mov EAX,MatrixA[ECX+8]
	mul aux
	;;
	sub rez,eax
	;;;6
	mov EAX,2
	mul dimA
	mul patru
	mov ECX,EAX
	mov EDX,MatrixA[ECX+4]
	mov aux,EDX
	;
	mov EAX,1
	mul dimA
	mul patru
	mov ECX,EAX
	mov EDX,MatrixA[ECX+8]
	mov EAX,aux
	mul EDX
	mov aux,EAX
	;
	mov EAX,0
	mul dimA
	mul patru
	mov ECX,EAX
	mov EAX,MatrixA[ECX+0]
	mul aux
	;;
	sub rez,eax
	;;;
	push rez
	push offset FormatIntScriere
	push ebx
	call fprintf
	add esp,12
final:
	mov ESP,EBP
	pop EBP
	ret
determinant ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
start:
	
inceput:
	push offset Inceput1
	call printf
	add ESP,4
	push offset Inceput2
	call printf
	add ESP,4
	push offset Inceput3
	call printf
	add ESP,4
	push offset Inceput4
	call printf
	add ESP,4
	push offset Inceput5
	call printf
	add ESP,4
	push offset Inceput6
	call printf
	add ESP,4
	push offset Inceput7
	call printf
	add ESP,4
	push offset Inceput1
	call printf
	add ESP,4
	
bucla_while:
	push offset TextOP
	call printf
	add ESP,4
	;printf("Introduceti o operatie cu matrici")
	push offset OPERATIE
	push offset FORMAT
	call scanf
	add ESP,8
	;scanf("%s",operatie)
	
	push PLUS
	push offset operatie
	call strchr
	add ESP,8
	mov rez,eax
	cmp rez,0
	JNE j_adunare
	
	push MINUS
	push offset operatie
	call strchr
	add ESP,8
	mov rez,eax
	cmp rez,0
	JNE j_scadere
	
	push det
	push offset operatie
	call strchr
	add ESP,8
	mov rez,eax
	cmp rez,0
	JNE j_det
	
	push tr
	push offset operatie
	call strchr
	add ESP,8
	mov rez,eax
	cmp rez,0
	JNE j_transp
	
	push sc
	push offset operatie
	call strchr
	add ESP,8
	mov rez,eax
	cmp rez,0
	JNE j_scalar
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
j_adunare:
	push offset TextA
	call printf
	add ESP,4
	push offset FisierA
	push offset format
	call scanf
	add ESP,8
	citire FisierA, DimA, MatrixA,aux
	
	push offset TextB
	call printf
	add ESP,4
	;printf("B=")
	push offset FisierB
	push offset format
	call scanf
	add ESP,8
	citire FisierB, DimB, MatrixB,aux
	
	call adunare
	
	jmp final
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
j_scadere:
	push offset TextA
	call printf
	add ESP,4
	;printf("A=")
	push offset FisierA
	push offset format
	call scanf
	add ESP,8
	;scanf("%s",FisierA)
	citire FisierA, DimA, MatrixA,aux
	
	push offset TextB
	call printf
	add ESP,4
	;printf("B=")
	push offset FisierB
	push offset format
	call scanf
	add ESP,8
	citire FisierB, DimB, MatrixB,aux
	
	call scadere
	
	jmp final
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
j_det:
	push offset TextA
	call printf
	add ESP,4
	;printf("A=")
	push offset FisierA
	push offset format
	call scanf
	add ESP,8
	citire FisierA, DimA, MatrixA,aux
	
	call determinant
	
	jmp final
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
j_transp:
	push offset TextA
	call printf
	add ESP,4
	;printf("A=")
	push offset FisierA
	push offset format
	call scanf
	add ESP,8
	citire FisierA, DimA, MatrixA,aux
	call transpusa
	
	jmp final
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
j_scalar:
	push offset TextA
	call printf
	add ESP,4
	;printf("A=")
	push offset FisierA
	push offset format
	call scanf
	add ESP,8
	citire FisierA, DimA, MatrixA,aux
	
	push offset Text_SCALAR ; Text_SCALAR DB "a=",0
	call printf
	add esp,4
	
	push offset scalar
	push offset FORMATINT
	call scanf
	add esp,8
	
	call inmultire_scalar
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
final:
	push offset rezultat
	call printf
	add ESP,4
	;printf("Rezultat:\n rezultat.txt")
	push offset Inceput1
	call printf
	add ESP,4
	push offset TextFinal
	call printf
	add ESP,4
	push offset OPRIRE
	push offset FORMATINT
	call scanf
	add ESP,8
	CMP OPRIRE,0
	JNE bucla_while
	;apel functie exit
	sfarsit:
	push 0
	call exit
end start


