package counter_pkg;

    // Transaction
    class counter_tx;
        bit en;
        bit up_dn;
        int cycles;

        function void display();
            $display("TX: en=%0b up_dn=%0b cycles=%0d", en, up_dn, cycles);
        endfunction
    endclass

    // Driver
    class counter_driver;
        virtual counter_if vif;

        function new(virtual counter_if vif);
            this.vif = vif;
        endfunction

        task drive(counter_tx tx);
            $display("Driver: Applying TX en=%0b up_dn=%0b cycles=%0d", tx.en, tx.up_dn, tx.cycles);
            vif.en = tx.en;
            vif.up_dn = tx.up_dn;
            repeat (tx.cycles) @(posedge vif.clk);
            vif.en = 0;
        endtask

        task drive_loop(mailbox gen2drv);
            counter_tx tx;
            forever begin
                gen2drv.get(tx);
                drive(tx);
            end
        endtask
    endclass

    // Generator
    class counter_gen;
        mailbox gen2drv;

        function new(mailbox gen2drv);
            this.gen2drv = gen2drv;
        endfunction

        task run();
            counter_tx tx;
            repeat (3) begin
                tx = new();
                tx.en     = 1;
                tx.up_dn  = $urandom_range(0,1);
                tx.cycles = $urandom_range(2,5);
                tx.display();
                gen2drv.put(tx);
            end
        endtask
    endclass

    // Monitor
    class counter_monitor;
        virtual counter_if vif;
        mailbox mon2sb;

        function new(virtual counter_if vif, mailbox mon2sb);
            this.vif = vif;
            this.mon2sb = mon2sb;
        endfunction

        task run();
            forever begin
                @(posedge vif.clk);
                $display("Monitor: count=%0d", vif.count);
                mon2sb.put(vif.count);
            end
        endtask
    endclass

    // Scoreboard
    class counter_sb;
        mailbox mon2sb;
        int expected;

        function new(mailbox mon2sb);
            this.mon2sb = mon2sb;
            expected = 0;
        endfunction

        task run();
            int observed;
            forever begin
                mon2sb.get(observed);
                $display("Scoreboard: Observed=%0d Expected=%0d", observed, expected);
                expected = observed; 
            end
        endtask
    endclass

    // Environment
    class counter_env;
        counter_driver drv;
        counter_gen gen;
        counter_monitor mon;
        counter_sb sb;

        mailbox gen2drv;
        mailbox mon2sb;

        function new(virtual counter_if vif);
            gen2drv = new();
            mon2sb = new();
            drv = new(vif);
            gen = new(gen2drv);
            mon = new(vif, mon2sb);
            sb = new(mon2sb);
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
