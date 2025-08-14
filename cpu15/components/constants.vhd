----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2025/08/12 01:01:25
-- Design Name:
-- Module Name: constants - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package constants_pkg is
    constant MACHINE_CODE_WIDTH : integer := 15;
    constant PC_WIDTH : integer := 8;
    constant INSTRUCTION_WIDTH : integer := 4;
    constant OPERAND_WIDTH : integer := 16;
    constant REGISTER_ADDRESS_WIDTH : integer := 3;
    constant RAM_ADDRESS_WIDTH : integer := 8;
    constant DOWNCLOCK_WIDTH : integer := 21;
end package;

package body constants_pkg is
end package body;
