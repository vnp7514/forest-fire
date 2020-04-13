#
# FILE:         $File$
# AUTHOR:       Van Pham vnp7514@rit.edu
#
# DESCRIPTION:
#       This includes the functions to create and modify an array:
#       create_arr takes in a number to initialize the array
#       insert_arr takes in row index, column index, value respectively to
#                     modify the array
#       print_arr  prints out the array
#       view_arr   view the array element at the row index, column index
#
# ARGUMENTS:
#       None
#
# INPUT:
#       The number that represents the dimension of the array
#       Pre-conditions: the number is between 4 and 30
#
# OUTPUT:
#       None
#
#
#
#
# CONSTANTS
#
PRINT_INT =     1
PRINT_STRING =  4
READ_INT =      5
READ_STRING =   8

        .data
        .align  0
array:
        .space  900

horizontal_border:
        .asciiz "+                               "

plus: 
        .ascii "+"

v_bar:
        .ascii "|"

da:
        .ascii "-"

box:
        .asciiz "+                               "

newlin:
        .asciiz  "\n"

        .align  2
dimension:
        .word   0

#
#------------------------------
#

#
# CODE AREAS
#
        .text                   # this is program code
        .align  2               # instructions must be on word boundaries

        .globl  create_arr      # the extern. def. of array creating routine
        .globl  insert_arr      # the extern. def. of array inserting routine
        .globl  print_arr       # the extern. def. of array printing routine
        .globl  view_arr        # the extern. def. of array viewing routine

#
# Name:         create_arr
# Description:  takes in a number that represents the dimension of the array
#               then store it in dimension. The user can modify the array
#               using the insert_arr routine and print out the array using
#               print_arr routine.
#
# Arguments:    a0      the dimension of the array
# Returns:      none
# Destroys:     t0
#
create_arr:

#
# save registers
#
        addi    $sp, $sp, -36
        sw      $s7, 32($sp)
        sw      $s6, 28($sp)
        sw      $s5, 24($sp)
        sw      $s4, 20($sp)
        sw      $s3, 16($sp)
        sw      $s2, 12($sp)
        sw      $s1, 8($sp)
        sw      $s0, 4($sp)
        sw      $ra, 0($sp)

#
# Begining of create_arr routine
#

        la      $t0, dimension
        sw      $a0, 0($t0)         # Store the dimension

#
# Restore register
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
# End of create_arr routine
#


#
# name:         view_arr
# description:  view the array at the specified row index and column index.
#               print it out and return the value of the array
#              
#     
# arguments:    a0      the row index of the element
#               a1      the col index of the element  
#   
# returns:      v0      the value of the array
# destroys:     t0, t1
#

view_arr:

#
# save registers
#
        addi    $sp, $sp, -36
        sw      $s7, 32($sp)
        sw      $s6, 28($sp)
        sw      $s5, 24($sp)
        sw      $s4, 20($sp)
        sw      $s3, 16($sp)
        sw      $s2, 12($sp)
        sw      $s1, 8($sp)
        sw      $s0, 4($sp)
        sw      $ra, 0($sp)

#
# start of view_arr routine
#

        la      $t0, array              # t0 = &arr[0][0]
        la      $t1, dimension
        lw      $t1, 0($t1)             # t1 = dimension
        mult    $t1, $a0
        mflo    $t1                     # t1 = dimension * row
                                        # Using only low because max t1 = 870 
        add     $t0, $t0, $t1           # t0 = &array[row]
        add     $t0, $t0, $a1           # t0 = &array[row][col]
        lb      $a0, 0($t0)             # a0 = array[row][col]
        li      $v0, PRINT_INT
        syscall
        
        lb      $v0, 0($t0)             # return v0 as array[row][col]

#
# Restore register
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
# End of view_arr routine
#


#
# Name:         insert_arr
# Description:  Insert the value to the array at the specified 
#               row index and column index.
#        
#              
#     
# Arguments:    a0      the row index of the element
#               a1      the col index of the element
#               a3      the value to be inserted  
#   
# Returns:      none
# Destroys:     t0, t1
#

insert_arr:

#
# Save registers
#
        addi    $sp, $sp, -36
        sw      $s7, 32($sp)
        sw      $s6, 28($sp)
        sw      $s5, 24($sp)
        sw      $s4, 20($sp)
        sw      $s3, 16($sp)
        sw      $s2, 12($sp)
        sw      $s1, 8($sp)
        sw      $s0, 4($sp)
        sw      $ra, 0($sp)

#
# Start of insert_arr routine
#
        la      $t0, array              # t0 = &arr[0][0]
        la      $t1, dimension
        lw      $t1, 0($t1)             # t1 = dimension
        mult    $t1, $a0
        mflo    $t1                     # t1 = dimension * row
                                        # Using only low because max t1 = 870 
        add     $t0, $t0, $t1           # t0 = &array[row]
        add     $t0, $t0, $a1           # t0 = &array[row][col]
        sb      $a3, 0($t0)             # array[row][col] = the value


#
# Restore register
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
# End of insert_arr routine
#


#
# Name:         print_arr
# Description:  Print out the entire array according to the given
#               dimension
#        
#              
#     
# Arguments:    none  
#   
# Returns:      none
# Destroys:     t0, t1, t2
#

print_arr:

#
# Save registers
#
        addi    $sp, $sp, -36
        sw      $s7, 32($sp)
        sw      $s6, 28($sp)
        sw      $s5, 24($sp)
        sw      $s4, 20($sp)
        sw      $s3, 16($sp)
        sw      $s2, 12($sp)
        sw      $s1, 8($sp)
        sw      $s0, 4($sp)
        sw      $ra, 0($sp)

#
# Start of print_arr routine
#
        jal     make_border         # Print out the top border
        la      $s2, array          # s2 = &array
        la      $s1, dimension
        lw      $s1, 0($s1)         # s1 = dimension
        move    $s7, $zero          # s7 is the row idx

p_row_init:
        la      $t0, box            # t0 = &box
        la      $t1, v_bar          
        lbu     $t1, 0($t1)         # t1 = '|'
        sb      $t1, 0($t0)         # box[0] = '|'
        addi    $t0, $t0, 1         # t0 = addr of next char in box
        move    $s0, $zero          # s0 is a counter for number of
                                    #   char inserted, aka col idx
       
p_row_lp:
        beq     $s0, $s1, p_row_end # if dimension = col idx then done
        lbu     $t2, 0($s2)         # t2 = array[row][col]
        sb      $t2, 0($t0)
        addi    $t0, $t0, 1         # t0 = addr of next char in box
        addi    $s0, $s0, 1         # dashes++
        addi    $s2, $s2, 1         # s2 = addr of next char in array
        j       p_row_lp

p_row_end:
        la      $t1, v_bar
        lbu     $t1, 0($t1)         # t1 = '|'
        sb      $t1, 0($t0)         # box[dimension+1] = '|'
        move    $t1, $zero          # t1 = null terminator
        sb      $t1, 1($t0)         # box[dimension+2] = '\0'
        la      $a0, box
        li      $v0, PRINT_STRING
        syscall
        la      $a0, newlin
        li      $v0, PRINT_STRING
        syscall
        addi    $s7, $s7, 1         # row idx ++
        beq     $s7, $s1, p_a_done  # if row idx == dimension, then done
        j       p_row_init          # otherwise, print next row

p_a_done:
        jal     make_border         # Print out the bottom border
#
# Restore register
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
# End of print_arr routine
#

#
# Name:         make_border
# Description:  Print out a box dashing line. Ex: +-----+
#        
#              
#     
# Arguments:    none 
#   
# Returns:      none
# Destroys:     t0, t1
#

make_border:

#
# Save registers
#
        addi    $sp, $sp, -36
        sw      $s7, 32($sp)
        sw      $s6, 28($sp)
        sw      $s5, 24($sp)
        sw      $s4, 20($sp)
        sw      $s3, 16($sp)
        sw      $s2, 12($sp)
        sw      $s1, 8($sp)
        sw      $s0, 4($sp)
        sw      $ra, 0($sp)

#
# Start of make_border routine
# 
        la      $t0, box            # t0 = &box
        la      $t1, plus          
        lbu     $t1, 0($t1)         # t1 = '+'
        sb      $t1, 0($t0)         # box[0] = '+'
        addi    $t0, $t0, 1         # t0 = addr of next char in box
        move    $s0, $zero          # s0 is a counter for dashes
        la      $s1, dimension
        lw      $s1, 0($s1)         # s1 = dimension
m_b_loop:
        beq     $s0, $s1, m_b_done  # if dimension = counter then done
        la      $t2, da
        lbu     $t2, 0($t2)         # t2 = '-'
        sb      $t2, 0($t0)
        addi    $t0, $t0, 1         # t0 = addr of next char in box
        addi    $s0, $s0, 1         # dashes++
        j       m_b_loop

m_b_done:
        la      $t1, plus          
        lbu     $t1, 0($t1)         # t1 = '+'
        sb      $t1, 0($t0)         # box[dimension+1] = '+'
        la      $a0, box
        li      $v0, PRINT_STRING
        syscall
        la      $a0, newlin
        li      $v0, PRINT_STRING
        syscall

#
# Restore register
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
# End of make_border routine
#

