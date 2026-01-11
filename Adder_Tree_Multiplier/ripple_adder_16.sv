module ripple_adder_16(
    input  logic [15:0] a,
    input  logic [15:0] b,
    input  logic cin,
    output logic [15:0] sum,
    output logic cout
);
    logic [16:0] c;
    assign c[0] = cin;

    xor (sum[0], a[0], b[0], c[0]);
    and (w0, a[0], b[0]);
    and (w1, a[0], c[0]);
    and (w2, b[0], c[0]);
    or  (c[1], w0, w1, w2);

    xor (sum[1], a[1], b[1], c[1]);
    and (w3, a[1], b[1]);
    and (w4, a[1], c[1]);
    and (w5, b[1], c[1]);
    or  (c[2], w3, w4, w5);

    xor (sum[2], a[2], b[2], c[2]);
    and (w6, a[2], b[2]);
    and (w7, a[2], c[2]);
    and (w8, b[2], c[2]);
    or  (c[3], w6, w7, w8);

    xor (sum[3], a[3], b[3], c[3]);
    and (w9, a[3], b[3]);
    and (w10, a[3], c[3]);
    and (w11, b[3], c[3]);
    or  (c[4], w9, w10, w11);

    xor (sum[4], a[4], b[4], c[4]);
    and (w12, a[4], b[4]);
    and (w13, a[4], c[4]);
    and (w14, b[4], c[4]);
    or  (c[5], w12, w13, w14);

    xor (sum[5], a[5], b[5], c[5]);
    and (w15, a[5], b[5]);
    and (w16, a[5], c[5]);
    and (w17, b[5], c[5]);
    or  (c[6], w15, w16, w17);

    xor (sum[6], a[6], b[6], c[6]);
    and (w18, a[6], b[6]);
    and (w19, a[6], c[6]);
    and (w20, b[6], c[6]);
    or  (c[7], w18, w19, w20);

    xor (sum[7], a[7], b[7], c[7]);
    and (w21, a[7], b[7]);
    and (w22, a[7], c[7]);
    and (w23, b[7], c[7]);
    or  (c[8], w21, w22, w23);

    xor (sum[8], a[8], b[8], c[8]);
    and (w24, a[8], b[8]);
    and (w25, a[8], c[8]);
    and (w26, b[8], c[8]);
    or  (c[9], w24, w25, w26);

    xor (sum[9], a[9], b[9], c[9]);
    and (w27, a[9], b[9]);
    and (w28, a[9], c[9]);
    and (w29, b[9], c[9]);
    or  (c[10], w27, w28, w29);

    xor (sum[10], a[10], b[10], c[10]);
    and (w30, a[10], b[10]);
    and (w31, a[10], c[10]);
    and (w32, b[10], c[10]);
    or  (c[11], w30, w31, w32);

    xor (sum[11], a[11], b[11], c[11]);
    and (w33, a[11], b[11]);
    and (w34, a[11], c[11]);
    and (w35, b[11], c[11]);
    or  (c[12], w33, w34, w35);

    xor (sum[12], a[12], b[12], c[12]);
    and (w36, a[12], b[12]);
    and (w37, a[12], c[12]);
    and (w38, b[12], c[12]);
    or  (c[13], w36, w37, w38);

    xor (sum[13], a[13], b[13], c[13]);
    and (w39, a[13], b[13]);
    and (w40, a[13], c[13]);
    and (w41, b[13], c[13]);
    or  (c[14], w39, w40, w41);

    xor (sum[14], a[14], b[14], c[14]);
    and (w42, a[14], b[14]);
    and (w43, a[14], c[14]);
    and (w44, b[14], c[14]);
    or  (c[15], w42, w43, w44);

    xor (sum[15], a[15], b[15], c[15]);
    and (w45, a[15], b[15]);
    and (w46, a[15], c[15]);
    and (w47, b[15], c[15]);
    or  (c[16], w45, w46, w47);

    assign cout = c[16];
endmodule
