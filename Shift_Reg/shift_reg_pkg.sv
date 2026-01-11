package shift_reg_pkg;

    // Transaction
    class shift_tx;
        bit shift_en;
        bit dir;
        bit d_in;
        int cycles;

        function void display();
            $display("TX: shift_en=%0b dir=%0b d_in=%0b cycles=%0d",
                      shift_en, dir, d_in, cycles);
        endfunction
    endclass

    // Driver
    class shift_driver;
        virtual shift_reg_if vif;

        function new(virtual shift_reg_if vif);
            this.vif = vif;
        endfunction

        task drive(shift_tx tx);
            $display("Driver: Applying TX dir=%0b d_in=%0b cycles=%0d",
                      tx.dir, tx.d_in, tx.cycles);
            vif.shift_en = tx.shift_en;
            vif.dir      = tx.dir;
            vif.d_in     = tx.d_in;
            repeat (tx.cycles) @(posedge vif.clk);
            vif.shift_en = 0;
        endtask

        task drive_loop(mailbox gen2drv);
            shift_tx tx;
            forever begin
                gen2drv.get(tx);
                drive(tx);
            end
        endtask
    endclass

    // Generator
    class shift_gen;
        mailbox gen2drv;

        function new(mailbox gen2drv);
            this.gen2drv = gen2drv;
        endfunction

        task run();
            shift_tx tx;
            repeat (4) begin
                tx = new();
                tx.shift_en = 1;
                tx.dir      = $urandom_range(0,1);
                tx.d_in     = $urandom_range(0,1);
                tx.cycles   = $urandom_range(2,5);
                tx.display();
                gen2drv.put(tx);
            end
        endtask
    endclass

    // Monitor
    class shift_monitor;
        virtual shift_reg_if vif;
        mailbox mon2sb;

        function new(virtual shift_reg_if vif, mailbox mon2sb);
            this.vif = vif;
            this.mon2sb = mon2sb;
        endfunction

        task run();
            forever begin
                @(posedge vif.clk);
                $display("Monitor: q_out=%b", vif.q_out);
                mon2sb.put(vif.q_out);
            end
        endtask
    endclass

    // Scoreboard
    class shift_sb;
        mailbox mon2sb;
        bit [7:0] expected;

        function new(mailbox mon2sb);
            this.mon2sb = mon2sb;
            expected = 0;
        endfunction

        task run();
            bit [7:0] observed;
            forever begin
                mon2sb.get(observed);
                $display("Scoreboard: Observed=%b Expected=%b", observed, expected);
                expected = observed; // simple update, can be extended with golden model
            end
        endtask
    endclass

    // Environment
    class shift_env;
        shift_driver drv;
        shift_gen gen;
        shift_monitor mon;
        shift_sb sb;

        mailbox gen2drv;
        mailbox mon2sb;

        function new(virtual shift_reg_if vif);
            gen2drv = new();
            mon2sb  = new();
            drv = new(vif);
            gen = new(gen2drv);
            mon = new(vif, mon2sb);
            sb  = new(mon2sb);
        endfunction

        task run();
            fork
                gen.run();
                drv.drive_loop(gen2drv);
                mon.run();
                sb.run();
            join
        endtask
    endclass

endpackage
