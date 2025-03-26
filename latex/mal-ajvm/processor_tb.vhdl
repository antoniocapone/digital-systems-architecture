-- Waveform generation
wavegen_proc: process
begin
    wait until clk = '1';
    wait for 2 ns;

    reset <= '1';
    wait for 10 ns;
    reset <= '0';

    wait until mem_instr_addr = x"0000000B" and mem_data_we = '1';
    assert mem_data_out = x"0000001C" report "Bad calculated value: " & integer'image(to_integer(unsigned(mem_data_out))) severity failure;

    wait until mem_instr_addr = x"0000000C";
    end_run := true;
    wait;
end process wavegen_proc;