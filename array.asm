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
ROW_LENGTH =    31                  # the length of 1 row in the array

        .data
        .align  0
array:
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "
        .asciiz "                              "

horizontal_border:
        .asciiz "+                               "

box:
        .asciiz "+                               "

        .align  2
dimension:
        .word   n

#
#------------------------------
#

# CODE AREAS
        .text                   # this is program code
        .align 2                # instructions must be on word boundaries

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
# Save registers ra
#
        addi    $sp, $sp, -4
        sw      $ra, 0($sp)

#
# Begining of create_arr routine
#

        la      $t0, dimension
        sw      $a0, 0($t0)         # Store the dimension

#
# Restore register ra
#
        lw      $ra, 0($sp)
        addi    $sp, $sp, 4
        jr      $ra

#
# End of create_arr routine
#


#
# Name:         view_arr
# Description:  View the array at the specified row index and column index.
#               Print it out and return the value of the array
#              
#     
# Arguments:    a0      the row index of the element
#               a1      the col index of the element  
#   
# Returns:      v0      the value of the array
# Destroys:     t0, t1
#

view_arr:

#
# Save registers ra
#
        addi    $sp, $sp, -4
        sw      $ra, 0($sp)

#
# Start of view_arr routine
#

        la      $t0, array
        mul     $t1, $a0, ROW_LENGTH
        add     $t0, $t0, $t1
        add     $t0, $t0, $a1
        lw      $a0, 0($t0)             # a0 = array[row][col]
        li      $v0, PRINT_INT
        syscall
        
        lw      $v0, 0($t0)             # return v0 as array[row][col]

#
# Restore register ra
#
        lw      $ra, 0($sp)
        addi    $sp, $sp, 4
        jr      $ra

#
# End of view_arr routine
#


