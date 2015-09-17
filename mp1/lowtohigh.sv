
import lc3b_types::*;

module lowtohigh
(
    input lc3b_word in,
    output lc3b_word out
);

always_comb
begin
    out = {in[7:0], in[7:0]};
end

endmodule : lowtohigh