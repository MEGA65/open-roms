
;
; Z80 Virtual Machine jumptables
;


!word ZVM ; entry point


;
; Vector table for executing Z80 instructions
;

Z80_vectab_0:

	!word Z80_instr_00, Z80_instr_01, Z80_instr_02, Z80_instr_03, Z80_instr_04, Z80_instr_05, Z80_instr_06, Z80_instr_07
	!word Z80_instr_08, Z80_instr_09, Z80_instr_0A, Z80_instr_0B, Z80_instr_0C, Z80_instr_0D, Z80_instr_0E, Z80_instr_0F

	!word Z80_instr_10, Z80_instr_11, Z80_instr_12, Z80_instr_13, Z80_instr_14, Z80_instr_15, Z80_instr_16, Z80_instr_17
	!word Z80_instr_18, Z80_instr_19, Z80_instr_1A, Z80_instr_1B, Z80_instr_1C, Z80_instr_1D, Z80_instr_1E, Z80_instr_1F

	!word Z80_instr_20, Z80_instr_21, Z80_instr_22, Z80_instr_23, Z80_instr_24, Z80_instr_25, Z80_instr_26, Z80_instr_27
	!word Z80_instr_28, Z80_instr_29, Z80_instr_2A, Z80_instr_2B, Z80_instr_2C, Z80_instr_2D, Z80_instr_2E, Z80_instr_2F

	!word Z80_instr_30, Z80_instr_31, Z80_instr_32, Z80_instr_33, Z80_instr_34, Z80_instr_35, Z80_instr_36, Z80_instr_37
	!word Z80_instr_38, Z80_instr_39, Z80_instr_3A, Z80_instr_3B, Z80_instr_3C, Z80_instr_3D, Z80_instr_3E, Z80_instr_3F

	!word Z80_instr_40, Z80_instr_41, Z80_instr_42, Z80_instr_43, Z80_instr_44, Z80_instr_45, Z80_instr_46, Z80_instr_47
	!word Z80_instr_48, Z80_instr_49, Z80_instr_4A, Z80_instr_4B, Z80_instr_4C, Z80_instr_4D, Z80_instr_4E, Z80_instr_4F

	!word Z80_instr_50, Z80_instr_51, Z80_instr_52, Z80_instr_53, Z80_instr_54, Z80_instr_55, Z80_instr_56, Z80_instr_57
	!word Z80_instr_58, Z80_instr_59, Z80_instr_5A, Z80_instr_5B, Z80_instr_5C, Z80_instr_5D, Z80_instr_5E, Z80_instr_5F

	!word Z80_instr_60, Z80_instr_61, Z80_instr_62, Z80_instr_63, Z80_instr_64, Z80_instr_65, Z80_instr_66, Z80_instr_67
	!word Z80_instr_68, Z80_instr_69, Z80_instr_6A, Z80_instr_6B, Z80_instr_6C, Z80_instr_6D, Z80_instr_6E, Z80_instr_6F

	!word Z80_instr_70, Z80_instr_71, Z80_instr_72, Z80_instr_73, Z80_instr_74, Z80_instr_75, Z80_instr_76, Z80_instr_77
	!word Z80_instr_78, Z80_instr_79, Z80_instr_7A, Z80_instr_7B, Z80_instr_7C, Z80_instr_7D, Z80_instr_7E, Z80_instr_7F

Z80_vectab_1:

	!word Z80_instr_80, Z80_instr_81, Z80_instr_82, Z80_instr_83, Z80_instr_84, Z80_instr_85, Z80_instr_86, Z80_instr_87
	!word Z80_instr_88, Z80_instr_89, Z80_instr_8A, Z80_instr_8B, Z80_instr_8C, Z80_instr_8D, Z80_instr_8E, Z80_instr_8F

	!word Z80_instr_90, Z80_instr_91, Z80_instr_92, Z80_instr_93, Z80_instr_94, Z80_instr_95, Z80_instr_96, Z80_instr_97
	!word Z80_instr_98, Z80_instr_99, Z80_instr_9A, Z80_instr_9B, Z80_instr_9C, Z80_instr_9D, Z80_instr_9E, Z80_instr_9F

	!word Z80_instr_A0, Z80_instr_A1, Z80_instr_A2, Z80_instr_A3, Z80_instr_A4, Z80_instr_A5, Z80_instr_A6, Z80_instr_A7
	!word Z80_instr_A8, Z80_instr_A9, Z80_instr_AA, Z80_instr_AB, Z80_instr_AC, Z80_instr_AD, Z80_instr_AE, Z80_instr_AF

	!word Z80_instr_B0, Z80_instr_B1, Z80_instr_B2, Z80_instr_B3, Z80_instr_B4, Z80_instr_B5, Z80_instr_B6, Z80_instr_B7
	!word Z80_instr_B8, Z80_instr_B9, Z80_instr_BA, Z80_instr_BB, Z80_instr_BC, Z80_instr_BD, Z80_instr_BE, Z80_instr_BF

	!word Z80_instr_C0, Z80_instr_C1, Z80_instr_C2, Z80_instr_C3, Z80_instr_C4, Z80_instr_C5, Z80_instr_C6, Z80_instr_C7
	!word Z80_instr_C8, Z80_instr_C9, Z80_instr_CA, Z80_instr_CB, Z80_instr_CC, Z80_instr_CD, Z80_instr_CE, Z80_instr_CF

	!word Z80_instr_D0, Z80_instr_D1, Z80_instr_D2, Z80_instr_D3, Z80_instr_D4, Z80_instr_D5, Z80_instr_D6, Z80_instr_D7
	!word Z80_instr_D8, Z80_instr_D9, Z80_instr_DA, Z80_instr_DB, Z80_instr_DC, Z80_instr_DD, Z80_instr_DE, Z80_instr_DF

	!word Z80_instr_E0, Z80_instr_E1, Z80_instr_E2, Z80_instr_E3, Z80_instr_E4, Z80_instr_E5, Z80_instr_E6, Z80_instr_E7
	!word Z80_instr_E8, Z80_instr_E9, Z80_instr_EA, Z80_instr_EB, Z80_instr_EC, Z80_instr_ED, Z80_instr_EE, Z80_instr_EF

	!word Z80_instr_F0, Z80_instr_F1, Z80_instr_F2, Z80_instr_F3, Z80_instr_F4, Z80_instr_F5, Z80_instr_F6, Z80_instr_F7
	!word Z80_instr_F8, Z80_instr_F9, Z80_instr_FA, Z80_instr_FB, Z80_instr_FC, Z80_instr_FD, Z80_instr_FE, Z80_instr_FF

Z80_vectab_CB_0:

	!word Z80_instr_CB_00, Z80_instr_CB_01, Z80_instr_CB_02, Z80_instr_CB_03, Z80_instr_CB_04, Z80_instr_CB_05, Z80_instr_CB_06, Z80_instr_CB_07
	!word Z80_instr_CB_08, Z80_instr_CB_09, Z80_instr_CB_0A, Z80_instr_CB_0B, Z80_instr_CB_0C, Z80_instr_CB_0D, Z80_instr_CB_0E, Z80_instr_CB_0F

	!word Z80_instr_CB_10, Z80_instr_CB_11, Z80_instr_CB_12, Z80_instr_CB_13, Z80_instr_CB_14, Z80_instr_CB_15, Z80_instr_CB_16, Z80_instr_CB_17
	!word Z80_instr_CB_18, Z80_instr_CB_19, Z80_instr_CB_1A, Z80_instr_CB_1B, Z80_instr_CB_1C, Z80_instr_CB_1D, Z80_instr_CB_1E, Z80_instr_CB_1F

	!word Z80_instr_CB_20, Z80_instr_CB_21, Z80_instr_CB_22, Z80_instr_CB_23, Z80_instr_CB_24, Z80_instr_CB_25, Z80_instr_CB_26, Z80_instr_CB_27
	!word Z80_instr_CB_28, Z80_instr_CB_29, Z80_instr_CB_2A, Z80_instr_CB_2B, Z80_instr_CB_2C, Z80_instr_CB_2D, Z80_instr_CB_2E, Z80_instr_CB_2F

	!word Z80_illeg_CB_30, Z80_illeg_CB_31, Z80_illeg_CB_32, Z80_illeg_CB_33, Z80_illeg_CB_34, Z80_illeg_CB_35, Z80_illeg_CB_36, Z80_illeg_CB_37
	!word Z80_instr_CB_38, Z80_instr_CB_39, Z80_instr_CB_3A, Z80_instr_CB_3B, Z80_instr_CB_3C, Z80_instr_CB_3D, Z80_instr_CB_3E, Z80_instr_CB_3F

	!word Z80_instr_CB_40, Z80_instr_CB_41, Z80_instr_CB_42, Z80_instr_CB_43, Z80_instr_CB_44, Z80_instr_CB_45, Z80_instr_CB_46, Z80_instr_CB_47
	!word Z80_instr_CB_48, Z80_instr_CB_49, Z80_instr_CB_4A, Z80_instr_CB_4B, Z80_instr_CB_4C, Z80_instr_CB_4D, Z80_instr_CB_4E, Z80_instr_CB_4F

	!word Z80_instr_CB_50, Z80_instr_CB_51, Z80_instr_CB_52, Z80_instr_CB_53, Z80_instr_CB_54, Z80_instr_CB_55, Z80_instr_CB_56, Z80_instr_CB_57
	!word Z80_instr_CB_58, Z80_instr_CB_59, Z80_instr_CB_5A, Z80_instr_CB_5B, Z80_instr_CB_5C, Z80_instr_CB_5D, Z80_instr_CB_5E, Z80_instr_CB_5F

	!word Z80_instr_CB_60, Z80_instr_CB_61, Z80_instr_CB_62, Z80_instr_CB_63, Z80_instr_CB_64, Z80_instr_CB_65, Z80_instr_CB_66, Z80_instr_CB_67
	!word Z80_instr_CB_68, Z80_instr_CB_69, Z80_instr_CB_6A, Z80_instr_CB_6B, Z80_instr_CB_6C, Z80_instr_CB_6D, Z80_instr_CB_6E, Z80_instr_CB_6F

	!word Z80_instr_CB_70, Z80_instr_CB_71, Z80_instr_CB_72, Z80_instr_CB_73, Z80_instr_CB_74, Z80_instr_CB_75, Z80_instr_CB_76, Z80_instr_CB_77
	!word Z80_instr_CB_78, Z80_instr_CB_79, Z80_instr_CB_7A, Z80_instr_CB_7B, Z80_instr_CB_7C, Z80_instr_CB_7D, Z80_instr_CB_7E, Z80_instr_CB_7F

Z80_vectab_CB_1:

	!word Z80_instr_CB_80, Z80_instr_CB_81, Z80_instr_CB_82, Z80_instr_CB_83, Z80_instr_CB_84, Z80_instr_CB_85, Z80_instr_CB_86, Z80_instr_CB_87
	!word Z80_instr_CB_88, Z80_instr_CB_89, Z80_instr_CB_8A, Z80_instr_CB_8B, Z80_instr_CB_8C, Z80_instr_CB_8D, Z80_instr_CB_8E, Z80_instr_CB_8F

	!word Z80_instr_CB_90, Z80_instr_CB_91, Z80_instr_CB_92, Z80_instr_CB_93, Z80_instr_CB_94, Z80_instr_CB_95, Z80_instr_CB_96, Z80_instr_CB_97
	!word Z80_instr_CB_98, Z80_instr_CB_99, Z80_instr_CB_9A, Z80_instr_CB_9B, Z80_instr_CB_9C, Z80_instr_CB_9D, Z80_instr_CB_9E, Z80_instr_CB_9F

	!word Z80_instr_CB_A0, Z80_instr_CB_A1, Z80_instr_CB_A2, Z80_instr_CB_A3, Z80_instr_CB_A4, Z80_instr_CB_A5, Z80_instr_CB_A6, Z80_instr_CB_A7
	!word Z80_instr_CB_A8, Z80_instr_CB_A9, Z80_instr_CB_AA, Z80_instr_CB_AB, Z80_instr_CB_AC, Z80_instr_CB_AD, Z80_instr_CB_AE, Z80_instr_CB_AF

	!word Z80_instr_CB_B0, Z80_instr_CB_B1, Z80_instr_CB_B2, Z80_instr_CB_B3, Z80_instr_CB_B4, Z80_instr_CB_B5, Z80_instr_CB_B6, Z80_instr_CB_B7
	!word Z80_instr_CB_B8, Z80_instr_CB_B9, Z80_instr_CB_BA, Z80_instr_CB_BB, Z80_instr_CB_BC, Z80_instr_CB_BD, Z80_instr_CB_BE, Z80_instr_CB_BF

	!word Z80_instr_CB_C0, Z80_instr_CB_C1, Z80_instr_CB_C2, Z80_instr_CB_C3, Z80_instr_CB_C4, Z80_instr_CB_C5, Z80_instr_CB_C6, Z80_instr_CB_C7
	!word Z80_instr_CB_C8, Z80_instr_CB_C9, Z80_instr_CB_CA, Z80_instr_CB_CB, Z80_instr_CB_CC, Z80_instr_CB_CD, Z80_instr_CB_CE, Z80_instr_CB_CF

	!word Z80_instr_CB_D0, Z80_instr_CB_D1, Z80_instr_CB_D2, Z80_instr_CB_D3, Z80_instr_CB_D4, Z80_instr_CB_D5, Z80_instr_CB_D6, Z80_instr_CB_D7
	!word Z80_instr_CB_D8, Z80_instr_CB_D9, Z80_instr_CB_DA, Z80_instr_CB_DB, Z80_instr_CB_DC, Z80_instr_CB_DD, Z80_instr_CB_DE, Z80_instr_CB_DF

	!word Z80_instr_CB_E0, Z80_instr_CB_E1, Z80_instr_CB_E2, Z80_instr_CB_E3, Z80_instr_CB_E4, Z80_instr_CB_E5, Z80_instr_CB_E6, Z80_instr_CB_E7
	!word Z80_instr_CB_E8, Z80_instr_CB_E9, Z80_instr_CB_EA, Z80_instr_CB_EB, Z80_instr_CB_EC, Z80_instr_CB_ED, Z80_instr_CB_EE, Z80_instr_CB_EF

	!word Z80_instr_CB_F0, Z80_instr_CB_F1, Z80_instr_CB_F2, Z80_instr_CB_F3, Z80_instr_CB_F4, Z80_instr_CB_F5, Z80_instr_CB_F6, Z80_instr_CB_F7
	!word Z80_instr_CB_F8, Z80_instr_CB_F9, Z80_instr_CB_FA, Z80_instr_CB_FB, Z80_instr_CB_FC, Z80_instr_CB_FD, Z80_instr_CB_FE, Z80_instr_CB_FF

Z80_vectab_DD_0:

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported
	!word Z80_unsupported, Z80_instr_DD_09, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported
	!word Z80_unsupported, Z80_instr_DD_19, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported

	!word Z80_unsupported, Z80_instr_DD_21, Z80_instr_DD_22, Z80_instr_DD_23, Z80_illeg_DD_24, Z80_illeg_DD_25, Z80_illeg_DD_26, Z80_unsupported
	!word Z80_unsupported, Z80_instr_DD_29, Z80_instr_DD_2A, Z80_instr_DD_2B, Z80_illeg_DD_2C, Z80_illeg_DD_2D, Z80_illeg_DD_2E, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_instr_DD_34, Z80_instr_DD_35, Z80_unsupported, Z80_unsupported
	!word Z80_unsupported, Z80_instr_DD_39, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_illeg_DD_44, Z80_illeg_DD_45, Z80_instr_DD_46, Z80_unsupported
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_illeg_DD_4C, Z80_illeg_DD_4D, Z80_instr_DD_4E, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_illeg_DD_54, Z80_illeg_DD_55, Z80_instr_DD_56, Z80_unsupported
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_illeg_DD_5C, Z80_illeg_DD_5D, Z80_instr_DD_5E, Z80_unsupported

	!word Z80_illeg_DD_60, Z80_illeg_DD_61, Z80_illeg_DD_62, Z80_illeg_DD_63, Z80_illeg_DD_64, Z80_illeg_DD_65, Z80_instr_DD_66, Z80_illeg_DD_67
	!word Z80_illeg_DD_68, Z80_illeg_DD_69, Z80_illeg_DD_6A, Z80_illeg_DD_6B, Z80_illeg_DD_6C, Z80_illeg_DD_6D, Z80_instr_DD_6E, Z80_illeg_DD_6F

	!word Z80_instr_DD_70, Z80_instr_DD_71, Z80_instr_DD_72, Z80_instr_DD_73, Z80_instr_DD_74, Z80_instr_DD_75, Z80_unsupported, Z80_instr_DD_77
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_illeg_DD_7C, Z80_illeg_DD_7D, Z80_instr_DD_7E, Z80_unsupported

Z80_vectab_DD_1:

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_illeg_DD_84, Z80_illeg_DD_85, Z80_instr_DD_86, Z80_unsupported
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_illeg_DD_8C, Z80_illeg_DD_8D, Z80_instr_DD_8E, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_illeg_DD_94, Z80_illeg_DD_95, Z80_instr_DD_96, Z80_unsupported
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_illeg_DD_9C, Z80_illeg_DD_9D, Z80_instr_DD_9E, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_illeg_DD_A4, Z80_illeg_DD_A5, Z80_instr_DD_A6, Z80_unsupported
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_illeg_DD_AC, Z80_illeg_DD_AD, Z80_instr_DD_AE, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_illeg_DD_B4, Z80_illeg_DD_B5, Z80_instr_DD_B6, Z80_unsupported
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_illeg_DD_BC, Z80_illeg_DD_BD, Z80_instr_DD_BE, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_instr_DD_CB, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported

	!word Z80_unsupported, Z80_instr_DD_E1, Z80_unsupported, Z80_instr_DD_E3, Z80_unsupported, Z80_instr_DD_E5, Z80_unsupported, Z80_unsupported
	!word Z80_unsupported, Z80_instr_DD_E9, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported
	!word Z80_unsupported, Z80_instr_DD_F9, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported

Z80_vectab_ED_0:

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported

	!word Z80_instr_ED_40, Z80_instr_ED_41, Z80_instr_ED_42, Z80_instr_ED_43, Z80_instr_ED_44, Z80_instr_ED_45, Z80_instr_ED_46, Z80_instr_ED_47
	!word Z80_instr_ED_48, Z80_instr_ED_49, Z80_instr_ED_4A, Z80_instr_ED_4B, Z80_illeg_ED_4C, Z80_instr_ED_4D, Z80_illeg_ED_4E, Z80_instr_ED_4F

	!word Z80_instr_ED_50, Z80_instr_ED_51, Z80_instr_ED_52, Z80_instr_ED_53, Z80_illeg_ED_54, Z80_illeg_ED_55, Z80_instr_ED_56, Z80_instr_ED_57
	!word Z80_instr_ED_58, Z80_instr_ED_59, Z80_instr_ED_5A, Z80_instr_ED_5B, Z80_illeg_ED_5C, Z80_illeg_ED_5D, Z80_instr_ED_5E, Z80_instr_ED_5F

	!word Z80_instr_ED_60, Z80_instr_ED_61, Z80_instr_ED_62, Z80_illeg_ED_63, Z80_illeg_ED_64, Z80_illeg_ED_65, Z80_illeg_ED_66, Z80_instr_ED_67
	!word Z80_instr_ED_68, Z80_instr_ED_69, Z80_instr_ED_6A, Z80_illeg_ED_6B, Z80_illeg_ED_6C, Z80_illeg_ED_6D, Z80_illeg_ED_6E, Z80_instr_ED_6F

	!word Z80_illeg_ED_70, Z80_illeg_ED_71, Z80_instr_ED_72, Z80_instr_ED_73, Z80_illeg_ED_74, Z80_illeg_ED_75, Z80_illeg_ED_76, Z80_illeg_ED_77
	!word Z80_instr_ED_78, Z80_instr_ED_79, Z80_instr_ED_7A, Z80_instr_ED_7B, Z80_illeg_ED_7C, Z80_illeg_ED_7D, Z80_illeg_ED_7E, Z80_illeg_ED_7F

Z80_vectab_ED_1:

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported

	!word Z80_instr_ED_A0, Z80_instr_ED_A1, Z80_instr_ED_A2, Z80_instr_ED_A3, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported
	!word Z80_instr_ED_A8, Z80_instr_ED_A9, Z80_instr_ED_AA, Z80_instr_ED_AB, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported

	!word Z80_instr_ED_B0, Z80_instr_ED_B1, Z80_instr_ED_B2, Z80_instr_ED_B3, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported
	!word Z80_instr_ED_B8, Z80_instr_ED_B9, Z80_instr_ED_BA, Z80_instr_ED_BB, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported

Z80_vectab_FD_0:

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported
	!word Z80_unsupported, Z80_instr_FD_09, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported
	!word Z80_unsupported, Z80_instr_FD_19, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported

	!word Z80_unsupported, Z80_instr_FD_21, Z80_instr_FD_22, Z80_instr_FD_23, Z80_illeg_FD_24, Z80_illeg_FD_25, Z80_illeg_FD_26, Z80_unsupported
	!word Z80_unsupported, Z80_instr_FD_29, Z80_instr_FD_2A, Z80_instr_FD_2B, Z80_illeg_FD_2C, Z80_illeg_FD_2D, Z80_illeg_FD_2E, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_instr_FD_34, Z80_instr_FD_35, Z80_unsupported, Z80_unsupported
	!word Z80_unsupported, Z80_instr_FD_39, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_illeg_FD_44, Z80_illeg_FD_45, Z80_unsupported, Z80_unsupported
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_illeg_FD_4C, Z80_illeg_FD_4D, Z80_instr_FD_4E, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_illeg_FD_54, Z80_illeg_FD_55, Z80_unsupported, Z80_unsupported
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_illeg_FD_5C, Z80_illeg_FD_5D, Z80_instr_FD_5E, Z80_unsupported

	!word Z80_illeg_FD_60, Z80_illeg_FD_61, Z80_illeg_FD_62, Z80_illeg_FD_63, Z80_illeg_FD_64, Z80_illeg_FD_65, Z80_instr_FD_66, Z80_illeg_FD_67
	!word Z80_illeg_FD_68, Z80_illeg_FD_69, Z80_illeg_FD_6A, Z80_illeg_FD_6B, Z80_illeg_FD_6C, Z80_illeg_FD_6D, Z80_instr_FD_6E, Z80_illeg_FD_6F

	!word Z80_instr_FD_70, Z80_instr_FD_71, Z80_instr_FD_72, Z80_instr_FD_73, Z80_instr_FD_74, Z80_instr_FD_75, Z80_unsupported, Z80_instr_FD_77
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_illeg_FD_7C, Z80_illeg_FD_7D, Z80_instr_FD_7E, Z80_unsupported

Z80_vectab_FD_1:

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_illeg_FD_84, Z80_illeg_FD_85, Z80_instr_FD_86, Z80_unsupported
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_illeg_FD_8C, Z80_illeg_FD_8D, Z80_instr_FD_8E, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_illeg_FD_94, Z80_illeg_FD_95, Z80_instr_FD_96, Z80_unsupported
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_illeg_FD_9C, Z80_illeg_FD_9D, Z80_instr_FD_9E, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_illeg_FD_A4, Z80_illeg_FD_A5, Z80_instr_FD_A6, Z80_unsupported
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_illeg_FD_AC, Z80_illeg_FD_AD, Z80_instr_FD_AE, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_illeg_FD_B4, Z80_illeg_FD_B5, Z80_instr_FD_B6, Z80_unsupported
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_illeg_FD_BC, Z80_illeg_FD_BD, Z80_instr_FD_BE, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_instr_FD_CB, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported
	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported

	!word Z80_unsupported, Z80_instr_FD_E1, Z80_unsupported, Z80_instr_FD_E3, Z80_unsupported, Z80_instr_FD_E5, Z80_unsupported, Z80_unsupported
	!word Z80_unsupported, Z80_instr_FD_E9, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported

	!word Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported
	!word Z80_unsupported, Z80_instr_FD_F9, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported, Z80_unsupported

Z80_vectab_xDCB_0:

	!word Z80_illeg_xDCB_00, Z80_illeg_xDCB_01, Z80_illeg_xDCB_02, Z80_illeg_xDCB_03, Z80_illeg_xDCB_04, Z80_illeg_xDCB_05, Z80_instr_xDCB_06, Z80_illeg_xDCB_07
	!word Z80_illeg_xDCB_08, Z80_illeg_xDCB_09, Z80_illeg_xDCB_0A, Z80_illeg_xDCB_0B, Z80_illeg_xDCB_0C, Z80_illeg_xDCB_0D, Z80_instr_xDCB_0E, Z80_illeg_xDCB_0F

	!word Z80_illeg_xDCB_10, Z80_illeg_xDCB_11, Z80_illeg_xDCB_12, Z80_illeg_xDCB_13, Z80_illeg_xDCB_14, Z80_illeg_xDCB_15, Z80_instr_xDCB_16, Z80_illeg_xDCB_17
	!word Z80_illeg_xDCB_18, Z80_illeg_xDCB_19, Z80_illeg_xDCB_1A, Z80_illeg_xDCB_1B, Z80_illeg_xDCB_1C, Z80_illeg_xDCB_1D, Z80_instr_xDCB_1E, Z80_illeg_xDCB_1F

	!word Z80_illeg_xDCB_20, Z80_illeg_xDCB_21, Z80_illeg_xDCB_22, Z80_illeg_xDCB_23, Z80_illeg_xDCB_24, Z80_illeg_xDCB_25, Z80_instr_xDCB_26, Z80_illeg_xDCB_27
	!word Z80_illeg_xDCB_28, Z80_illeg_xDCB_29, Z80_illeg_xDCB_2A, Z80_illeg_xDCB_2B, Z80_illeg_xDCB_2C, Z80_illeg_xDCB_2D, Z80_instr_xDCB_2E, Z80_illeg_xDCB_2F

	!word Z80_illeg_xDCB_30, Z80_illeg_xDCB_31, Z80_illeg_xDCB_32, Z80_illeg_xDCB_33, Z80_illeg_xDCB_34, Z80_illeg_xDCB_35, Z80_illeg_xDCB_36, Z80_illeg_xDCB_37
	!word Z80_illeg_xDCB_38, Z80_illeg_xDCB_39, Z80_illeg_xDCB_3A, Z80_illeg_xDCB_3B, Z80_illeg_xDCB_3C, Z80_illeg_xDCB_3D, Z80_instr_xDCB_3E, Z80_illeg_xDCB_3F

	!word Z80_illeg_xDCB_40, Z80_illeg_xDCB_41, Z80_illeg_xDCB_42, Z80_illeg_xDCB_43, Z80_illeg_xDCB_44, Z80_illeg_xDCB_45, Z80_instr_xDCB_46, Z80_illeg_xDCB_47
	!word Z80_illeg_xDCB_48, Z80_illeg_xDCB_49, Z80_illeg_xDCB_4A, Z80_illeg_xDCB_4B, Z80_illeg_xDCB_4C, Z80_illeg_xDCB_4D, Z80_instr_xDCB_4E, Z80_illeg_xDCB_4F

	!word Z80_illeg_xDCB_50, Z80_illeg_xDCB_51, Z80_illeg_xDCB_52, Z80_illeg_xDCB_53, Z80_illeg_xDCB_54, Z80_illeg_xDCB_55, Z80_instr_xDCB_56, Z80_illeg_xDCB_57
	!word Z80_illeg_xDCB_58, Z80_illeg_xDCB_59, Z80_illeg_xDCB_5A, Z80_illeg_xDCB_5B, Z80_illeg_xDCB_5C, Z80_illeg_xDCB_5D, Z80_instr_xDCB_5E, Z80_illeg_xDCB_5F

	!word Z80_illeg_xDCB_60, Z80_illeg_xDCB_61, Z80_illeg_xDCB_62, Z80_illeg_xDCB_63, Z80_illeg_xDCB_64, Z80_illeg_xDCB_65, Z80_instr_xDCB_66, Z80_illeg_xDCB_67
	!word Z80_illeg_xDCB_68, Z80_illeg_xDCB_69, Z80_illeg_xDCB_6A, Z80_illeg_xDCB_6B, Z80_illeg_xDCB_6C, Z80_illeg_xDCB_6D, Z80_instr_xDCB_6E, Z80_illeg_xDCB_6F

	!word Z80_illeg_xDCB_70, Z80_illeg_xDCB_71, Z80_illeg_xDCB_72, Z80_illeg_xDCB_73, Z80_illeg_xDCB_74, Z80_illeg_xDCB_75, Z80_instr_xDCB_76, Z80_illeg_xDCB_77
	!word Z80_illeg_xDCB_78, Z80_illeg_xDCB_79, Z80_illeg_xDCB_7A, Z80_illeg_xDCB_7B, Z80_illeg_xDCB_7C, Z80_illeg_xDCB_7D, Z80_instr_xDCB_7E, Z80_illeg_xDCB_7F

Z80_vectab_xDCB_1:

	!word Z80_illeg_xDCB_80, Z80_illeg_xDCB_81, Z80_illeg_xDCB_82, Z80_illeg_xDCB_83, Z80_illeg_xDCB_84, Z80_illeg_xDCB_85, Z80_instr_xDCB_86, Z80_illeg_xDCB_87
	!word Z80_illeg_xDCB_88, Z80_illeg_xDCB_89, Z80_illeg_xDCB_8A, Z80_illeg_xDCB_8B, Z80_illeg_xDCB_8C, Z80_illeg_xDCB_8D, Z80_instr_xDCB_8E, Z80_illeg_xDCB_8F

	!word Z80_illeg_xDCB_90, Z80_illeg_xDCB_91, Z80_illeg_xDCB_92, Z80_illeg_xDCB_93, Z80_illeg_xDCB_94, Z80_illeg_xDCB_95, Z80_instr_xDCB_96, Z80_illeg_xDCB_97
	!word Z80_illeg_xDCB_98, Z80_illeg_xDCB_99, Z80_illeg_xDCB_9A, Z80_illeg_xDCB_9B, Z80_illeg_xDCB_9C, Z80_illeg_xDCB_9D, Z80_instr_xDCB_9E, Z80_illeg_xDCB_9F

	!word Z80_illeg_xDCB_A0, Z80_illeg_xDCB_A1, Z80_illeg_xDCB_A2, Z80_illeg_xDCB_A3, Z80_illeg_xDCB_A4, Z80_illeg_xDCB_A5, Z80_instr_xDCB_A6, Z80_illeg_xDCB_A7
	!word Z80_illeg_xDCB_A8, Z80_illeg_xDCB_A9, Z80_illeg_xDCB_AA, Z80_illeg_xDCB_AB, Z80_illeg_xDCB_AC, Z80_illeg_xDCB_AD, Z80_instr_xDCB_AE, Z80_illeg_xDCB_AF

	!word Z80_illeg_xDCB_B0, Z80_illeg_xDCB_B1, Z80_illeg_xDCB_B2, Z80_illeg_xDCB_B3, Z80_illeg_xDCB_B4, Z80_illeg_xDCB_B5, Z80_instr_xDCB_B6, Z80_illeg_xDCB_B7
	!word Z80_illeg_xDCB_B8, Z80_illeg_xDCB_B9, Z80_illeg_xDCB_BA, Z80_illeg_xDCB_BB, Z80_illeg_xDCB_BC, Z80_illeg_xDCB_BD, Z80_instr_xDCB_BE, Z80_illeg_xDCB_BF

	!word Z80_illeg_xDCB_C0, Z80_illeg_xDCB_C1, Z80_illeg_xDCB_C2, Z80_illeg_xDCB_C3, Z80_illeg_xDCB_C4, Z80_illeg_xDCB_C5, Z80_instr_xDCB_C6, Z80_illeg_xDCB_C7
	!word Z80_illeg_xDCB_C8, Z80_illeg_xDCB_C9, Z80_illeg_xDCB_CA, Z80_illeg_xDCB_CB, Z80_illeg_xDCB_CC, Z80_illeg_xDCB_CD, Z80_instr_xDCB_CE, Z80_illeg_xDCB_CF

	!word Z80_illeg_xDCB_D0, Z80_illeg_xDCB_D1, Z80_illeg_xDCB_D2, Z80_illeg_xDCB_D3, Z80_illeg_xDCB_D4, Z80_illeg_xDCB_D5, Z80_instr_xDCB_D6, Z80_illeg_xDCB_D7
	!word Z80_illeg_xDCB_D8, Z80_illeg_xDCB_D9, Z80_illeg_xDCB_DA, Z80_illeg_xDCB_DB, Z80_illeg_xDCB_DC, Z80_illeg_xDCB_DD, Z80_instr_xDCB_DE, Z80_illeg_xDCB_DF

	!word Z80_illeg_xDCB_E0, Z80_illeg_xDCB_E1, Z80_illeg_xDCB_E2, Z80_illeg_xDCB_E3, Z80_illeg_xDCB_E4, Z80_illeg_xDCB_E5, Z80_instr_xDCB_E6, Z80_illeg_xDCB_E7
	!word Z80_illeg_xDCB_E8, Z80_illeg_xDCB_E9, Z80_illeg_xDCB_EA, Z80_illeg_xDCB_EB, Z80_illeg_xDCB_EC, Z80_illeg_xDCB_ED, Z80_instr_xDCB_EE, Z80_illeg_xDCB_EF

	!word Z80_illeg_xDCB_F0, Z80_illeg_xDCB_F1, Z80_illeg_xDCB_F2, Z80_illeg_xDCB_F3, Z80_illeg_xDCB_F4, Z80_illeg_xDCB_F5, Z80_instr_xDCB_F6, Z80_illeg_xDCB_F7
	!word Z80_illeg_xDCB_F8, Z80_illeg_xDCB_F9, Z80_illeg_xDCB_FA, Z80_illeg_xDCB_FB, Z80_illeg_xDCB_FC, Z80_illeg_xDCB_FD, Z80_instr_xDCB_FE, Z80_illeg_xDCB_FF
