package array_multiplier_pkg;

    // Transaction
    class mult_tx;
        rand bit [7:0] A;
        rand bit [7:0] B;
        bit [15:0] P_exp;

        function void calc_expected();
            P_exp = A * B;
        endfunction

        function void display();
            $display("TX: A=%0d B=%0d Expected=%0d", A, B, P_exp);
        endfunction
    endclass

    // Driver
    class mult_driver;
        virtual array_if vif;   

        function new(virtual array_if vif);
            this.vif = vif;
        endfunction

        task drive(mult_tx tx);
            @(posedge vif.clk);
            vif.data_in_A <= tx.A;
            vif.data_in_B <= tx.B;
            $display("Driver: Applied A=%0d B=%0d", tx.A, tx.B);
        endtask

        task drive_loop(mailbox gen2drv);
            mult_tx tx;
            forever begin
                gen2drv.get(tx);
                drive(tx);
            end
        endtask
    endclass

    // Generator
    class mult_gen;
        mailbox gen2drv;

        function new(mailbox gen2drv);
            this.gen2drv = gen2drv;
        endfunction

        task run();
            mult_tx tx;
            repeat (5) begin
                tx = new();
                // Starter Edition: use $urandom_range instead of randomize()
                tx.A = $urandom_range(0, 255);
                tx.B = $urandom_range(0, 255);
                tx.calc_expected();
                tx.display();
                if (gen2drv == null) $fatal("Mailbox gen2drv not constructed!");
                gen2drv.put(tx);
            end
        endtask
    endclass

    // Monitor
    class mult_monitor;
        virtual array_if vif;   // aligned with array_if
        mailbox mon2sb;

        function new(virtual array_if vif, mailbox mon2sb);
            this.vif = vif;
            this.mon2sb = mon2sb;
        endfunction

        task run();
            forever begin
                @(posedge vif.clk);
                mon2sb.put(vif.P);
                $display("Monitor: DUT Output=%0d", vif.P);
            end
        endtask
    endclass

    // Scoreboard
    class mult_sb;
        mailbox mon2sb;
        int expected;

        function new(mailbox mon2sb);
            this.mon2sb = mon2sb;
        endfunction

        task run();
            int observed;
            forever begin
                mon2sb.get(observed);
                $display("Scoreboard: Observed=%0d", observed);
            end
        endtask
    endclass

endpackage
