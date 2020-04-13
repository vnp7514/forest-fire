#
# FILE:         $Files
# AUTHOR:       Van Pham vnp7514@rit.edu
# Section:      3 MWF 11am
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
#       For each generation, print out the grid that is modified by the 
#         previous state of the grid
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
        .asciiz "012345678901234567890123456789\n"
gen_beg:
        .asciiz "==== #"
gen_end:
        .asciiz " ====\n"

        .align  2
gen:
        .word   0

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
        .globl  insert_arr2
        .globl  view_arr        # external reference
        .globl  print_arr       # external reference
        .globl  print_arr2
        .globl  copy2to1
        .globl  copy1to2
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
        la      $s0, grid_size_err  # s0 is reserved for error outputs
        beq     $t0, $zero, err_main_done
        slti    $t1, $s7, 4         # t1 = 1 if size < 4. t1 = 0 if size >= 4
        bne     $t1, $zero, err_main_done
        move    $a0, $s7
        jal     create_arr          # Initialize a dimXdim array


        li      $v0, READ_INT
        syscall                     # read the number of Generations
        move    $s6, $v0            # s6 = generation
        slti    $t0, $s6, 21        # t0 = 1 if gen <= 20
        la      $s0, gen_err        # s0 is reserved for errors
        beq     $t0, $zero, err_main_done
        slti    $t0, $s6, 0         # t0 = 1 if gen < 0. t0 = 0 if gen >=0
        bne     $t0, $zero, err_main_done


        li      $v0, READ_STRING    # read the Wind Direction as a string
        la      $a0, str_in         # place to store the char read in
        addi    $a1, $zero, 3       # the number of char to read in
        syscall
        la      $s0, wind_err       # s0 is reserved for error
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


#
# Beginning of grid checking
# 
        move    $s1, $zero          # s1 is for row idx
        move    $s2, $zero          # s2 is for col idx
        la      $s0, char_err       # s0 is reserved for error
grid_checking:
        li      $v0, READ_STRING
        la      $a0, str_in
        addi    $a1, $s7, 2         # maximum chars to read = dimension+2
        syscall
        move    $s3, $a0            # s3 now holds the addr of the str_in
        la      $t0, newline
        lbu     $t0, 0($t0)         # t0 = '\n'
        lbu     $t1, 0($a0)         # t1 = first char in str_in
        beq     $t1, $t0, g_c_done  # if first char == '\n' then done

grid_loop:
                                    # t1 is the next char in the line

        beq     $s2, $s7, g_l_done  # if col idx == dimension, then
                                    # we have read enough characters from the
                                    # line
        la      $t0, burn
        lbu     $t0, 0($t0)         # t0 = 'B'
        beq     $t0, $t1, g_l_next
        la      $t0, grass
        lbu     $t0, 0($t0)         # t0 = '.'
        beq     $t0, $t1, g_l_next
        la      $t0, tree
        lbu     $t0, 0($t0)         # t0 = 't'
        beq     $t0, $t1, g_l_next
        j       err_main_done       # the char is not any of the above
 
g_l_next:
        move    $a0, $s1
        move    $a1, $s2
        move    $a3, $t1
        jal     insert_arr

        addi    $s2, $s2, 1         # col idx ++
        addi    $s3, $s3, 1         # s3 = addr of next char
        lbu     $t1, 0($s3)         # t1 = next char
        j       grid_loop
g_l_done:
        move    $s2, $zero          # reset row idx
        addi    $s1, $s1, 1         # row idx++
                                  
        beq     $s1, $s7, g_c_done  # if row idx == dimension, we have read
                                    # enough lines
        j       grid_checking       

g_c_done:

        jal     print_banner

forest_beg:
        move    $s3, $zero          # s3 = row idx = 0
        move    $s4, $zero          # s4 = col idx = 0
        la      $s1, gen
        lw      $s1, 0($s1)         # s1 = current gen number
        jal     print_gen           # modifies the current gen number
        beq     $s1, $s6, forest_ed # if current gen = max gen then done

frt_lp:                             # forest loop
        bne     $s4, $s7, frt_nxt   # if col idx != dimension then go next
        move    $s4, $zero          # Otherwise, reset col idx and 
        addi    $s3, $s3, 1         # add 1 to row idx
        beq     $s3, $s7, frt_l_ed  # if row idx == dimension then finish

frt_nxt:                            # forest next
        move    $a0, $s3
        move    $a1, $s4
        jal     check_burn
        move    $a0, $s3
        move    $a1, $s4
        move    $a2, $s7
        jal     check_tree_burn
        move    $a0, $s3
        move    $a1, $s4
        move    $a2, $s5
        move    $a3, $s7
        jal     check_wind

        addi    $s4, $s4, 1
        j       frt_lp

frt_l_ed:                           # forest loop end
        jal     copy2to1            # Copy the updated array to the old array
        j       forest_beg
forest_ed:

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


# Name:         print_gen
# Description:  Print out a generation of the forest
#
#
# Arguments:    None
# 
# Returns:      none
# Destroys:     t0, t1, t2
#
print_gen:
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
# Start of print_gen routine
#
        la      $t2, gen
        lw      $t0, 0($t2)         # t0 = current gen
        addi    $t1, $t0, 1         # current gen ++
        sw      $t1, 0($t2)
        la      $a0, gen_beg
        li      $v0, PRINT_STRING   # print the beginning of the gen header
        syscall
        move    $a0, $t0
        li      $v0, PRINT_INT      # print the generation number
        syscall
        la      $a0, gen_end        
        li      $v0, PRINT_STRING   # print the end of the gen header
        syscall
        jal     print_arr
        jal     copy1to2
        la      $a0, newline
        li      $v0, PRINT_STRING   # print a new line
        syscall
        

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
# End of print_gen routine
#

# Name:         check_burn
# Description:  A burning cell from the previous generation turns into
#                 an empty grass cell in the current generation
#
#
# Arguments:    a0  the row idx of the cell
#               a1  the col idx of the cell 
#               
# 
# Returns:      none
# Destroys:     t0, t1, t2
#
check_burn:
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
# Start of check_burn routine
#
        move    $s0, $a0
        move    $s1, $a1
        jal     view_arr
        move    $s2, $v0            # s2 = arr[row][col]
        la      $t0, burn
        lbu     $t0, 0($t0)         # t0 = 'B'
        bne     $t0, $s2, c_b_done  # if s2 != 'B' then no need to change
        move    $a0, $s0
        move    $a1, $s1
        la      $t0, grass          # t0 = '.'
        lbu     $t0, 0($t0)
        move    $a3, $t0
        jal     insert_arr2
c_b_done:

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
# End of check_burn routine
#

# Name:         check_tree_burn
# Description:  A tree in the previous generation will burn (turn into 
#                 a burning cell) if at least one of its cardinal direction 
#                 (north, south, east, or west) neighbors in the previous 
#                 generation is burning. Otherwise it will stay a tree in 
#                 the current generation.
#
#
# Arguments:    a0  the row idx of the cell
#               a1  the col idx of the cell 
#               a2  the dimension of the array
# 
# Returns:      none
# Destroys:     t0, t1, t2
#
check_tree_burn:
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
# Start of check_tree_burn routine
#
        move    $s0, $a0            # s0 = row idx of the cell
        move    $s1, $a1            # s1 = col idx of the cell
        addi    $s2, $a2, -1        # s2 = dimension-1
 
        la      $s6, tree
        lbu     $s6, 0($s6)         # s6 = 't'
        move    $a0, $s0
        move    $a1, $s1
        jal     view_arr
        move    $t0, $v0            # t0 = arr[row][col]
        bne     $t0, $s6, ctb_done  # if arr[row][col] != 't' then no check
        
        la      $s7, burn
        lbu     $s7, 0($s7)         # s7 = 'B' 

        beq     $s0, $zero, sth_ctb
        addi    $a0, $s0, -1        # North cell has original row - 1
        move    $a1, $s1            # it has same col idx
        jal     view_arr            
        move    $s3, $v0            # s3 = arr[row-1][col]
        bne     $s7, $s3, sth_ctb   # if North is not burning, check other
        move    $a0, $s0
        move    $a1, $s1
        move    $a3, $s7
        jal     insert_arr2
        j       ctb_done

sth_ctb:                            # south check tree burn
        beq     $s0, $s2, wst_ctb
        addi    $a0, $s0, 1         # South cell has original row + 1
        move    $a1, $s1            # it has same col idx
        jal     view_arr            
        move    $s3, $v0            # s3 = arr[row+1][col]
        bne     $s7, $s3, wst_ctb   # if South is not burning, check other
        move    $a0, $s0
        move    $a1, $s1
        move    $a3, $s7
        jal     insert_arr2
        j       ctb_done

wst_ctb:                            # west check tree burn
        beq     $s1, $zero, est_ctb
        addi    $a1, $s1, -1        # West cell has original col - 1
        move    $a0, $s0            # it has same row idx
        jal     view_arr            
        move    $s3, $v0            # s3 = arr[row][col-1]
        bne     $s7, $s3, est_ctb   # if West is not burning, check other
        move    $a0, $s0
        move    $a1, $s1
        move    $a3, $s7
        jal     insert_arr2
        j       ctb_done


est_ctb:                            # east check tree burn
        beq     $s1, $s2, ctb_done
        addi    $a1, $s1, 1         # East cell has original col + 1
        move    $a0, $s0            # it has same row idx
        jal     view_arr            
        move    $s3, $v0            # s3 = arr[row][col+1]
        bne     $s7, $s3, ctb_done  # if East is not burning, done
        move    $a0, $s0
        move    $a1, $s1
        move    $a3, $s7
        jal     insert_arr2

ctb_done:
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
# End of check_tree_burn routine
#

# Name:         check_wind
# Description:  A previous generation tree will turn an adjacent 
#                 empty (grass) cell into a current generation tree if 
#                 that empty cell is in the given wind direction.
#
#
# Arguments:    a0  the row idx of the cell
#               a1  the col idx of the cell 
#               a2  the wind direction
#               a3  the dimension
# 
# Returns:      none
# Destroys:     t0, t1, t2
#
check_wind:
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
# Start of check_wind routine
#
        move    $s0, $a0            # s0 = row idx
        move    $s1, $a1            # s1 = col idx
        move    $s2, $a2            # s2 = the wind
        addi    $s3, $a3, -1        # s3 = dimension -1

        la      $s5, grass
        lbu     $s5, 0($s5)         # s5 = '.'
        la      $s6, tree
        lbu     $s6, 0($s6)         # s6 = 't'
        move    $a0, $s0
        move    $a1, $s1
        jal     view_arr
        move    $t0, $v0            # t0 = arr[row][col]
        bne     $t0, $s6, cw_done  # if arr[row][col] != 't' then no check

        la      $t0, north
        lbu     $t0, 0($t0)         # t0 = 'N'
        la      $t1, south
        lbu     $t1, 0($t1)         # t1 = 'S' 
        la      $t2, west  
        lbu     $t2, 0($t2)         # t2 = 'W'
        beq     $s2, $t2, west_cw
        beq     $s2, $t1, suth_cw
        beq     $s2, $t0, nrth_cw

        beq     $s1, $s3, cw_done   # if col = dimension -1, cannot go east
        addi    $a1, $s1, 1         # east cell has col + 1
        move    $a0, $s0            # has same row
        jal     view_arr
        bne     $v0, $s5, cw_done   # if east cell is not grass, then done
        addi    $a1, $s1, 1         # east cell has col + 1
        move    $a0, $s0            # has same row
        move    $a3, $s6            # value will be 't'
        jal     insert_arr2
        j       cw_done

west_cw:
        beq     $s1, $zero, cw_done # if col = 0, cannot go west
        addi    $a1, $s1, -1        # west cell has col - 1
        move    $a0, $s0            # has same row
        jal     view_arr
        bne     $v0, $s5, cw_done   # if west cell is not grass, then done
        addi    $a1, $s1, -1        # west cell has col - 1
        move    $a0, $s0            # has same row
        move    $a3, $s6            # value will be 't'
        jal     insert_arr2
        j       cw_done

suth_cw:
        beq     $s0, $s3, cw_done   # if row = dimension -1, cannot go south
        addi    $a0, $s0, 1         # south cell has row + 1
        move    $a1, $s1            # has same col
        jal     view_arr
        bne     $v0, $s5, cw_done   # if south cell is not grass, then done
        addi    $a0, $s0, 1         # south cell has row + 1
        move    $a1, $s1            # has same col
        move    $a3, $s6            # value will be 't'
        jal     insert_arr2
        j       cw_done

nrth_cw:
        beq     $s0, $zero, cw_done # if row = 0, cannot go north
        addi    $a0, $s0, -1        # north cell has row- 1
        move    $a1, $s1            # has same col
        jal     view_arr
        bne     $v0, $s5, cw_done   # if north cell is not grass, then done
        addi    $a0, $s0, -1        # north cell has row- 1
        move    $a1, $s1            # has same col
        move    $a3, $s6            # value will be 't'
        jal     insert_arr2
        j       cw_done

cw_done:
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
# End of check_wind routine
#


