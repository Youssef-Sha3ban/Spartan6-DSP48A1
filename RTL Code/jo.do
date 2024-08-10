.main clear

vlib work

vlog DSP.v TB_DSP.v reg_mux_pair.v

vsim -voptargs=+acc work.TB_DSP


#add wave *

add wave -radix decimal -position insertpoint  \
sim:/TB_DSP/CARRYIN \
sim:/TB_DSP/RSTCARRYIN \
sim:/TB_DSP/RSTOPMODE \
sim:/TB_DSP/RSTA \
sim:/TB_DSP/RSTB \
sim:/TB_DSP/RSTC \
sim:/TB_DSP/RSTD \
sim:/TB_DSP/RSTM \
sim:/TB_DSP/RSTP \
sim:/TB_DSP/CEA \
sim:/TB_DSP/CEB \
sim:/TB_DSP/CEM \
sim:/TB_DSP/CEP \
sim:/TB_DSP/CEC \
sim:/TB_DSP/CED \
sim:/TB_DSP/CECARRYIN \
sim:/TB_DSP/CEOPMODE \
sim:/TB_DSP/PCIN \
sim:/TB_DSP/BCIN \
sim:/TB_DSP/OPMODE \
sim:/TB_DSP/C \
sim:/TB_DSP/B \
sim:/TB_DSP/D \
sim:/TB_DSP/A \
{sim:/TB_DSP/OPMODE[5]}

add wave -color magenta -position insertpoint  \
sim:/TB_DSP/clk

add wave -radix decimal -color red -position insertpoint  \
sim:/TB_DSP/EXPECTED

add wave -radix decimal -color cyan -position insertpoint  \
sim:/TB_DSP/P \
sim:/TB_DSP/CARRYOUT \
sim:/TB_DSP/CARRYOUTF \
sim:/TB_DSP/BCOUT \
sim:/TB_DSP/M \
sim:/TB_DSP/PCOUT


add wave -radix decimal -color orange -position insertpoint  \
sim:/TB_DSP/DUT/opmode_r \
sim:/TB_DSP/DUT/a0_out \
sim:/TB_DSP/DUT/b0_out \
sim:/TB_DSP/DUT/d_out \
sim:/TB_DSP/DUT/b_in \
sim:/TB_DSP/DUT/pre_adder_out \
sim:/TB_DSP/DUT/bypass_b \
sim:/TB_DSP/DUT/c_out \
sim:/TB_DSP/DUT/a1_out \
sim:/TB_DSP/DUT/b1_out \
sim:/TB_DSP/DUT/multiplier_out \
sim:/TB_DSP/DUT/m_out \
sim:/TB_DSP/DUT/x_out \
sim:/TB_DSP/DUT/z_out \
sim:/TB_DSP/DUT/carry_cascade_out \
sim:/TB_DSP/DUT/COUT \
sim:/TB_DSP/DUT/CIN \
sim:/TB_DSP/DUT/post_adder_out

run -all

#quit -sim
