module parse_signbits_ec
(
input [127:0] suffix,
input [6:0]m_signBitValid,
output [2:0] signBitVld_num,
output [6:0] signBit
);
wire [2:0] signBitVld_num_2 =m_signBitValid[0] + m_signBitValid[1]; 
wire [2:0] signBitVld_num_3 =m_signBitValid[0] + m_signBitValid[1]+m_signBitValid[2]; 
wire [2:0] signBitVld_num_4 =m_signBitValid[0] + m_signBitValid[1]+m_signBitValid[2] +m_signBitValid[3];
wire [2:0] signBitVld_num_5 =m_signBitValid[0] + m_signBitValid[1]+m_signBitValid[2] +m_signBitValid[3] +m_signBitValid[4]; 
wire [2:0] signBitVld_num_6 =m_signBitValid[0] + m_signBitValid[1]+m_signBitValid[2] +m_signBitValid[3] +m_signBitValid[4] +m_signBitValid[5]; 
assign signBitVld_num   =m_signBitValid[0] + m_signBitValid[1] +m_signBitValid[2] +m_signBitValid[3] +m_signBitValid[4]+m_signBitValid[5] +m_signBitValid[6]; 
assign signBit[0] = m_signBitValid[0]&suffix[127];
assign signBit[1] = m_signBitValid[1] ? (m_signBitValid[0] ? suffix[126] : suffix[127])
                                                 : 0;
assign signBit[2] = m_signBitValid[2] ? (signBitVld_num_2==2 ? suffix[127-2] :
                                                    signBitVld_num_2==1 ? suffix[127-1]:
                                                    suffix[127-0]
                                                    )
                                                 : 0;
assign signBit[3] = m_signBitValid[3] ? (signBitVld_num_3==3 ? suffix[127-3]:
                                                    signBitVld_num_3==2 ? suffix[127-2]:
                                                    signBitVld_num_3==1 ? suffix[127-1]:
                                                    suffix[127-0]
                                                    )
                                                 : 0;
assign signBit[4] = m_signBitValid[4] ? (signBitVld_num_4==4 ? suffix[127-4]:
                                                    signBitVld_num_4==3 ? suffix[127-3]:
                                                    signBitVld_num_4==2 ? suffix[127-2]:
                                                    signBitVld_num_4==1 ? suffix[127-1]:
                                                    suffix[127-0]
                                                    )
                                                 : 0;
assign signBit[5] = m_signBitValid[5] ? (signBitVld_num_5==5 ? suffix[127-5]:
                                                    signBitVld_num_5==4 ? suffix[127-4]:
                                                    signBitVld_num_5==3 ? suffix[127-3]:
                                                    signBitVld_num_5==2 ? suffix[127-2]:
                                                    signBitVld_num_5==1 ? suffix[127-1]:
                                                    suffix[127-0]
                                                    )
                                                 : 0;
assign signBit[6] = m_signBitValid[6] ? (signBitVld_num_6==6 ? suffix[127-6]:
                                                    signBitVld_num_6==5 ? suffix[127-5]:
                                                    signBitVld_num_6==4 ? suffix[127-4]:
                                                    signBitVld_num_6==3 ? suffix[127-3]:
                                                    signBitVld_num_6==2 ? suffix[127-2]:
                                                    signBitVld_num_6==1 ? suffix[127-1]:
                                                    suffix[127-0]
                                                    )
                                                 : 0;


endmodule
