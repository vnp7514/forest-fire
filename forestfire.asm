#
# FILE:         $Files
# AUTHOR:       Van Pham vnp7514@rit.edu
#
# DESCRIPTION: 
#       This runs the Forest Fire program aka cellular automaton.
#
# ARGUMENTS:
#       None
#
# INPUT:
#       Grid Size (4 <= size <= 30)
#       Generations (0 <= generations <= 20)
#       Wind Direction (N, S, E, W)
#       Initial Grid (B, t, .)
#
# OUTPUT:
#       None
#
# CONSTANTS
#
PRINT_INT =     1
PRINT_STRING =  4
READ_INT =      5
READ_STRING =   8

        .data 
        .align  0
grid_size_err:
        .asciiz "ERROR: invalid grid size\n"
gen_err:
        .asciiz "ERROR: invalid number of generations\n"
wind_err:
        .asciiz "ERROR: invalid wind direction\n"
char_err:
        .asciiz "ERROR: invalid character in grid\n"
north:
        .ascii  "N"
south: 
        .ascii  "S"
east:
        .ascii  "E"
west:
        .ascii  "W"
burn:
        .ascii  "B"
tree:
        .ascii  "t"
grass:
        .ascii  "."
banner:
        .asciiz "| FOREST FIRE |"
dash:
        .asciiz "+-------------+"
newline:
        .asciiz "\n"
str_in:
        .asciiz "012345678901234567890123456789"

#
#----------------------------------
#

#
#CODE AREAS
#
        .text                   # this is program code
        .align  2               # instructions must be on word boundaries
    
        .globl  create_arr      # external reference
        .globl  insert_arr      # external reference
        .globl  view_arr        # external reference
        .globl  print_arr       # external reference
        .globl  main            # external definition of main routine

#
# EXECUTION BEGINS HERE 
#
main:

#
# Save registers ra and s0-s7 on the stack
#
        addi    $sp, $sp, -36
        sw      $ra, 0($sp)
        sw      $s7, 32($sp)
        sw      $s6, 28($sp)
        sw      $s5, 24($sp)
        sw      $s4, 20($sp)
        sw      $s3, 16($sp)
        sw      $s2, 12($sp)
        sw      $s1, 8($sp)
        sw      $s0, 4($sp)

#
# Start of main routine
#

        li      $v0, READ_INT
        syscall                     # read the Grid Size
        move    $s7, $v0            # s7 = grid size
        slti    $t0, $s7, 31        # t0 = 1 if size < 31
        la      $s0, grid_size_err
        beq     $t0, $zero, err_main_done
        slti    $t1, $s7, 4         # t1 = 1 if size < 4. t1 = 0 if size >= 4
        bne     $t1, $zero, err_main_done

        li      $v0, READ_INT
        syscall                     # read the number of Generations
        move    $s6, $v0            # s6 = generation
        slti    $t0, $s6, 21        # t0 = 1 if gen <= 20
        la      $s0, gen_err        
        beq     $t0, $zero, err_main_done
        slti    $t0, $s6, 0         # t0 = 1 if gen < 0. t0 = 0 if gen >=0
        bne     $t0, $zero, err_main_done

        li      $v0, READ_STRING    # read the Wind Direction as a string
        la      $a0, str_in         # place to store the char read in
        addi    $a1, $zero, 3       # the number of char to read in
        syscall
        la      $s0, wind_err
        lbu     $s2, 0($a0)         # s2 = the char that was read
        la      $s1, north
        lbu     $s1, 0($s1)
        sub     $s1, $s1, $s2       # s1 = 0 if the char = N. Then no error
        beq     $s1, $zero, afterwind
        la      $s1, south
        lbu     $s1, 0($s1)
        sub     $s1, $s1, $s2       # s1 = 0 if the char = S. Then no error
        beq     $s1, $zero, afterwind
        la      $s1, west
        lbu     $s1, 0($s1)
        sub     $s1, $s1, $s2       # s1 = 0 if the char = W. Then no error
        beq     $s1, $zero, afterwind
        la      $s1, east
        lbu     $s1, 0($s1)
        sub     $s1, $s1, $s2       # s1 = 0 if the char = E. Then no error
        beq     $s1, $zero, afterwind
        j       err_main_done       # char is not Wind. ERROR
afterwind:
        move    $s5, $s2            # s5 = wind direction

        # TODO Initial Grid checking

        jal     print_banner

        j       main_done

err_main_done:                      # Print out the error
        li      $v0, PRINT_STRING
        move    $a0, $s0
        syscall

main_done:

#
# Restore registers ra and s0-s7 on the stack
#
        lw      $ra, 0($sp)
        lw      $s7, 32($sp)
        lw      $s6, 28($sp)
        lw      $s5, 24($sp)
        lw      $s4, 20($sp)
        lw      $s3, 16($sp)
        lw      $s2, 12($sp)
        lw      $s1, 8($sp)
        lw      $s0, 4($sp)
        addi    $sp, $sp, 36
        jr      $ra

#
# End of main routine
#

#
# Name:         print_banner
# Description:  Print out the program banner
# Arguments:    None
# Returns:      None
# Destroys:     a0, v0
#
print_banner:

#
# Save registers ra on the stack
# 
        addi    $sp, $sp, -4
        sw      $ra, 0($sp)

#
# Beginning of print banner routine
#
        li      $v0, PRINT_STRING   # Printing the program banner
        la      $a0, dash           # Printing +-------------+
        syscall
        li      $v0, PRINT_STRING 
        la      $a0, newline        # Printing newline
        syscall
        li      $v0, PRINT_STRING 
        la      $a0, banner         # Printing | FOREST FIRE |
        syscall
        li      $v0, PRINT_STRING 
        la      $a0, newline        # Printing newline
        syscall
        li      $v0, PRINT_STRING 
        la      $a0, dash           # Printing +-------------+
        syscall
        li      $v0, PRINT_STRING 
        la      $a0, newline        # Printing newline 
        syscall 


#
# Restore registers ra from the stack
#
        lw      $ra, 0($sp)
        addi    $sp, $sp, 4
        jr      $ra

#
# End of print banner routine
#
