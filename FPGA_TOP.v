// ============================================================================
// Copyright (c) 2014 by Terasic Technologies Inc.
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// ============================================================================
//           
//  Terasic Technologies Inc
//  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
//  
//  
//                     web: http://www.terasic.com/  
//                     email: support@terasic.com
//
// ============================================================================
//Date:  Tue Dec  2 09:28:38 2014
// ============================================================================

// GPIO_0 inout 
// input  GPIO_0[0]  -> from_GPIO_0_0_inout_to_wrapper
// output GPIO_0[0]  <- wrapper_gpio_0_0_inout
// input  GPIO_0[1]	 -> from_GPIO_0_1_in

// GPIO_1 output
// output GPIO_1[0]	 <- wrapper_to_gpio_1_0_out
// output GPIO_1[1]	 <- 1'b0
// output GPIO_1[2]	 <- 1'b1
// output GPIO_1[3]	 <- FPGA_CLK1_50 		****** TEST PINS ******
// output GPIO_1[4]	 <- HPS_UART_RX			****** SERIAL TEST PINS ******
// output GPIO_1[5]	 <- HPS_UART_TX			****** NOT AVAILABLE ******
// output GPIO_1[6]	 <- HPS_GSENSOR_INT		****** GSENSOR TEST PINS ******
// output GPIO_1[7]	 <- HPS_I2C0_SCLK 		****** GSENSOR TEST PINS ******
// output GPIO_1[8]  <- HPS_I2C0_SDAT		****** GSENSOR TEST PINS ******
	
`define ENABLE_HPS
//`define ENABLE_CLK

module FPGA_TOP (

      ///////// ADC /////////
      output             ADC_CONVST,
      output             ADC_SCK,
      output             ADC_SDI,
      input              ADC_SDO,

      ///////// ARDUINO /////////
      inout       [15:0] ARDUINO_IO,
      inout              ARDUINO_RESET_N,

`ifdef ENABLE_CLK
      ///////// CLK /////////
      output             CLK_I2C_SCL,
      inout              CLK_I2C_SDA,
`endif /*ENABLE_CLK*/

      ///////// FPGA /////////
      input              FPGA_CLK1_50,
      input              FPGA_CLK2_50,
      input              FPGA_CLK3_50,

      ///////// GPIO /////////
      inout       [35:0] GPIO_0,
      output      [35:0] GPIO_1,

`ifdef ENABLE_HPS
      ///////// HPS /////////
      inout              HPS_CONV_USB_N,
      output      [14:0] HPS_DDR3_ADDR,
      output      [2:0]  HPS_DDR3_BA,
      output             HPS_DDR3_CAS_N,
      output             HPS_DDR3_CKE,
      output             HPS_DDR3_CK_N,
      output             HPS_DDR3_CK_P,
      output             HPS_DDR3_CS_N,
      output      [3:0]  HPS_DDR3_DM,
      inout       [31:0] HPS_DDR3_DQ,
      inout       [3:0]  HPS_DDR3_DQS_N,
      inout       [3:0]  HPS_DDR3_DQS_P,
      output             HPS_DDR3_ODT,
      output             HPS_DDR3_RAS_N,
      output             HPS_DDR3_RESET_N,
      input              HPS_DDR3_RZQ,
      output             HPS_DDR3_WE_N,
      output             HPS_ENET_GTX_CLK,
      inout              HPS_ENET_INT_N,
      output             HPS_ENET_MDC,
      inout              HPS_ENET_MDIO,
      input              HPS_ENET_RX_CLK,
      input       [3:0]  HPS_ENET_RX_DATA,
      input              HPS_ENET_RX_DV,
      output      [3:0]  HPS_ENET_TX_DATA,
      output             HPS_ENET_TX_EN,
      inout              HPS_GSENSOR_INT,
      inout              HPS_I2C0_SCLK,
      inout              HPS_I2C0_SDAT,
      inout              HPS_I2C1_SCLK,
      inout              HPS_I2C1_SDAT,
      inout              HPS_KEY,
      inout              HPS_LED,
      inout              HPS_LTC_GPIO,
      output             HPS_SD_CLK,
      inout              HPS_SD_CMD,
      inout       [3:0]  HPS_SD_DATA,
      output             HPS_SPIM_CLK,
      input              HPS_SPIM_MISO,
      output             HPS_SPIM_MOSI,
      inout              HPS_SPIM_SS,
      input              HPS_UART_RX,
      output             HPS_UART_TX,
      input              HPS_USB_CLKOUT,
      inout       [7:0]  HPS_USB_DATA,
      input              HPS_USB_DIR,
      input              HPS_USB_NXT,
      output             HPS_USB_STP,
`endif /*ENABLE_HPS*/

      ///////// KEY /////////
      input       [1:0]  KEY,

      ///////// LED /////////
      output      [7:0]  LED,

      ///////// SW /////////
      input       [3:0]  SW
);

//=======================================================
//  REG/WIRE declarations
//=======================================================
wire  hps_fpga_reset_n;
wire [1:0] KEY_pio;
wire [1:0] KEY_wrapper;
wire [7:0] pio_LED;
wire [7:0] wrapper_LED;
wire [3:0] SW_pio;
wire [3:0] SW_wrapper;
	
wire [7:0] pio_reg_out_wrapper; // .pio_reg_out_external_connection_export     (<connected-to-pio_reg_out_external_connection_export>),     //   pio_regb_out_external_connection.export
wire [7:0] wrapper_pio_reg_inout; // .pio_reg_inout_external_connection_in_port  (<connected-to-pio_reg_inout_external_connection_in_port>),  // pio_regb_inout_external_connection.in_port
wire [7:0] pio_reg_inout_wrapper; // .pio_reg_inout_external_connection_out_port (<connected-to-pio_reg_inout_external_connection_out_port>), //                                   .out_port
wire [7:0] wrapper_pio_reg_in; // .pio_reg_in_external_connection_export      (<connected-to-pio_reg_in_external_connection_export>),      //    pio_rega_in_external_connection.export

wire wrapper_gpio_0_0_inout;
wire from_GPIO_0_1_in;
wire from_GPIO_0_0_inout;

wire from_HPS_GSENSOR_INT_to_GPIO_1_6;
wire from_HPS_I2C0_SCLK_to_GPIO_1_7;
wire from_HPS_I2C0_SDAT_to_GPIO_1_8;

wire CLK_50;	// 50 MHz clock

assign LED = pio_LED | wrapper_LED;
assign SW_pio = SW;
assign SW_wrapper = SW;
assign KEY_pio = KEY;
assign KEY_wrapper = KEY;

// GPIO_0 inout

assign from_GPIO_0_0_inout	= ( GPIO_0[0] == 1'b0 ) ? 1'b0 : 1'b1;
assign GPIO_0[0]			= ( wrapper_gpio_0_0_inout == 1'b0 ) ? 1'b0 : 1'bZ;

assign from_GPIO_0_1_in 	= ( GPIO_0[1] == 1'b0 ) ? 1'b0 : 1'b1;
assign GPIO_0[1]			= 1'bZ; // only input

assign GPIO_0[35:2] 		= 33'bZ; // open

// GPIO_1 output

assign GPIO_1[1]			= 1'b0;
assign GPIO_1[2]			= 1'b1;

assign CLK_50 				= FPGA_CLK1_50;
assign GPIO_1[3]			= CLK_50;

//assign from_HPS_GSENSOR_INT_to_GPIO_1_6 = ( HPS_GSENSOR_INT == 1'b0 ) ? 1'b0 : 1'b1;
//assign GPIO_1[6]						= from_HPS_GSENSOR_INT_to_GPIO_1_6;

//assign from_HPS_I2C0_SCLK_to_GPIO_1_7	= ( HPS_I2C0_SCLK == 1'b0 ) ? 1'b0 : 1'b1;
//assign GPIO_1[7]						= from_HPS_I2C0_SCLK_to_GPIO_1_7; 

//assign from_HPS_I2C0_SDAT_to_GPIO_1_8	= ( HPS_I2C0_SDAT == 1'b0 ) ? 1'b0 : 1'b1;
//assign GPIO_1[8]						= from_HPS_I2C0_SDAT_to_GPIO_1_8;	

// wrapper

wrapper I_wrapper (
	.CLK					( CLK_50 ),
	.RST					( 1'b0 ),
	.LED					( wrapper_LED ),
	.SW						( SW_wrapper ),
	.KEY					( KEY_wrapper ),
	.from_GPIO_0_1_in		( from_GPIO_0_1_in ),
	.from_GPIO_0_0_inout	( from_GPIO_0_0_inout ),	
	.to_GPIO_0_0_inout 		( wrapper_gpio_0_0_inout ),	
	.to_gpio_1_0_out		( GPIO_1[0] ),
	.from_pio_reg_out		( pio_reg_out_wrapper ),
	.from_pio_reg_inout		( pio_reg_inout_wrapper ),
	.to_pio_reg_in			( wrapper_pio_reg_in ),
	.to_pio_reg_inout		( wrapper_pio_reg_inout )
);

//=======================================================
//  Structural coding
//=======================================================

 soc_system u0 (
	.pio_reg_out_external_connection_export     ( pio_reg_out_wrapper ),		// .from_pio_reg_out
	.pio_reg_in_external_connection_export      ( wrapper_pio_reg_in ),		// .HPS_A_out
	.pio_reg_inout_external_connection_in_port  ( wrapper_pio_reg_inout ),	// .to_pio_reg_inout
	.pio_reg_inout_external_connection_out_port ( pio_reg_inout_wrapper ),	// .from_pio_reg_inout                                   .out_port
	.led_pio_external_connection_export    ( pio_LED ),    //    led_pio_external_connection.export
	.button_pio_external_connection_export ( KEY_pio ), // button_pio_external_connection.export
	.dipsw_pio_external_connection_export  ( SW_pio ),  //  dipsw_pio_external_connection.export
	//Clock&Reset
	.clk_clk                               ( FPGA_CLK1_50 ),                               //                            clk.clk
	.reset_reset_n                         ( 1'b1         ),                         //                          reset.reset_n
	//HPS ddr3
	.memory_mem_a                          ( HPS_DDR3_ADDR),                       //                memory.mem_a
	.memory_mem_ba                         ( HPS_DDR3_BA),                         //                .mem_ba
	.memory_mem_ck                         ( HPS_DDR3_CK_P),                       //                .mem_ck
	.memory_mem_ck_n                       ( HPS_DDR3_CK_N),                       //                .mem_ck_n
	.memory_mem_cke                        ( HPS_DDR3_CKE),                        //                .mem_cke
	.memory_mem_cs_n                       ( HPS_DDR3_CS_N),                       //                .mem_cs_n
	.memory_mem_ras_n                      ( HPS_DDR3_RAS_N),                      //                .mem_ras_n
	.memory_mem_cas_n                      ( HPS_DDR3_CAS_N),                      //                .mem_cas_n
	.memory_mem_we_n                       ( HPS_DDR3_WE_N),                       //                .mem_we_n
	.memory_mem_reset_n                    ( HPS_DDR3_RESET_N),                    //                .mem_reset_n
	.memory_mem_dq                         ( HPS_DDR3_DQ),                         //                .mem_dq
	.memory_mem_dqs                        ( HPS_DDR3_DQS_P),                      //                .mem_dqs
	.memory_mem_dqs_n                      ( HPS_DDR3_DQS_N),                      //                .mem_dqs_n
	.memory_mem_odt                        ( HPS_DDR3_ODT),                        //                .mem_odt
	.memory_mem_dm                         ( HPS_DDR3_DM),                         //                .mem_dm
	.memory_oct_rzqin                      ( HPS_DDR3_RZQ),                        //                .oct_rzqin                                  
	//HPS ethernet		
	.hps_0_hps_io_hps_io_emac1_inst_TX_CLK ( HPS_ENET_GTX_CLK ),       //                             hps_0_hps_io.hps_io_emac1_inst_TX_CLK
	.hps_0_hps_io_hps_io_emac1_inst_TXD0   ( HPS_ENET_TX_DATA[0] ),   //                             .hps_io_emac1_inst_TXD0
	.hps_0_hps_io_hps_io_emac1_inst_TXD1   ( HPS_ENET_TX_DATA[1] ),   //                             .hps_io_emac1_inst_TXD1
	.hps_0_hps_io_hps_io_emac1_inst_TXD2   ( HPS_ENET_TX_DATA[2] ),   //                             .hps_io_emac1_inst_TXD2
	.hps_0_hps_io_hps_io_emac1_inst_TXD3   ( HPS_ENET_TX_DATA[3] ),   //                             .hps_io_emac1_inst_TXD3
	.hps_0_hps_io_hps_io_emac1_inst_RXD0   ( HPS_ENET_RX_DATA[0] ),   //                             .hps_io_emac1_inst_RXD0
	.hps_0_hps_io_hps_io_emac1_inst_MDIO   ( HPS_ENET_MDIO   ),         //                             .hps_io_emac1_inst_MDIO
	.hps_0_hps_io_hps_io_emac1_inst_MDC    ( HPS_ENET_MDC    ),         //                             .hps_io_emac1_inst_MDC
	.hps_0_hps_io_hps_io_emac1_inst_RX_CTL ( HPS_ENET_RX_DV  ),         //                             .hps_io_emac1_inst_RX_CTL
	.hps_0_hps_io_hps_io_emac1_inst_TX_CTL ( HPS_ENET_TX_EN  ),         //                             .hps_io_emac1_inst_TX_CTL
	.hps_0_hps_io_hps_io_emac1_inst_RX_CLK ( HPS_ENET_RX_CLK ),        //                             .hps_io_emac1_inst_RX_CLK
	.hps_0_hps_io_hps_io_emac1_inst_RXD1   ( HPS_ENET_RX_DATA[1] ),   //                             .hps_io_emac1_inst_RXD1
	.hps_0_hps_io_hps_io_emac1_inst_RXD2   ( HPS_ENET_RX_DATA[2] ),   //                             .hps_io_emac1_inst_RXD2
	.hps_0_hps_io_hps_io_emac1_inst_RXD3   ( HPS_ENET_RX_DATA[3] ),   //                             .hps_io_emac1_inst_RXD3		  
	//HPS SD card 
	.hps_0_hps_io_hps_io_sdio_inst_CMD     ( HPS_SD_CMD    ),           //                               .hps_io_sdio_inst_CMD
	.hps_0_hps_io_hps_io_sdio_inst_D0      ( HPS_SD_DATA[0]     ),      //                               .hps_io_sdio_inst_D0
	.hps_0_hps_io_hps_io_sdio_inst_D1      ( HPS_SD_DATA[1]     ),      //                               .hps_io_sdio_inst_D1
	.hps_0_hps_io_hps_io_sdio_inst_CLK     ( HPS_SD_CLK   ),            //                               .hps_io_sdio_inst_CLK
	.hps_0_hps_io_hps_io_sdio_inst_D2      ( HPS_SD_DATA[2]     ),      //                               .hps_io_sdio_inst_D2
	.hps_0_hps_io_hps_io_sdio_inst_D3      ( HPS_SD_DATA[3]     ),      //                               .hps_io_sdio_inst_D3
	//HPS USB 		  
	.hps_0_hps_io_hps_io_usb1_inst_D0      ( HPS_USB_DATA[0]    ),      //                               .hps_io_usb1_inst_D0
	.hps_0_hps_io_hps_io_usb1_inst_D1      ( HPS_USB_DATA[1]    ),      //                               .hps_io_usb1_inst_D1
	.hps_0_hps_io_hps_io_usb1_inst_D2      ( HPS_USB_DATA[2]    ),      //                               .hps_io_usb1_inst_D2
	.hps_0_hps_io_hps_io_usb1_inst_D3      ( HPS_USB_DATA[3]    ),      //                               .hps_io_usb1_inst_D3
	.hps_0_hps_io_hps_io_usb1_inst_D4      ( HPS_USB_DATA[4]    ),      //                               .hps_io_usb1_inst_D4
	.hps_0_hps_io_hps_io_usb1_inst_D5      ( HPS_USB_DATA[5]    ),      //                               .hps_io_usb1_inst_D5
	.hps_0_hps_io_hps_io_usb1_inst_D6      ( HPS_USB_DATA[6]    ),      //                               .hps_io_usb1_inst_D6
	.hps_0_hps_io_hps_io_usb1_inst_D7      ( HPS_USB_DATA[7]    ),      //                               .hps_io_usb1_inst_D7
	.hps_0_hps_io_hps_io_usb1_inst_CLK     ( HPS_USB_CLKOUT    ),       //                               .hps_io_usb1_inst_CLK
	.hps_0_hps_io_hps_io_usb1_inst_STP     ( HPS_USB_STP    ),          //                               .hps_io_usb1_inst_STP
	.hps_0_hps_io_hps_io_usb1_inst_DIR     ( HPS_USB_DIR    ),          //                               .hps_io_usb1_inst_DIR
	.hps_0_hps_io_hps_io_usb1_inst_NXT     ( HPS_USB_NXT    ),          //                               .hps_io_usb1_inst_NXT
	//HPS SPI 		  
	.hps_0_hps_io_hps_io_spim1_inst_CLK    ( HPS_SPIM_CLK  ),           //                               .hps_io_spim1_inst_CLK
	.hps_0_hps_io_hps_io_spim1_inst_MOSI   ( HPS_SPIM_MOSI ),           //                               .hps_io_spim1_inst_MOSI
	.hps_0_hps_io_hps_io_spim1_inst_MISO   ( HPS_SPIM_MISO ),           //                               .hps_io_spim1_inst_MISO
	.hps_0_hps_io_hps_io_spim1_inst_SS0    ( HPS_SPIM_SS   ),             //                               .hps_io_spim1_inst_SS0
	//HPS UART		
	.hps_0_hps_io_hps_io_uart0_inst_RX     ( HPS_UART_RX   ),          //                               .hps_io_uart0_inst_RX
	.hps_0_hps_io_hps_io_uart0_inst_TX     ( HPS_UART_TX   ),          //                               .hps_io_uart0_inst_TX
	//HPS I2C1
	.hps_0_hps_io_hps_io_i2c0_inst_SDA     ( HPS_I2C0_SDAT  ),        //                               .hps_io_i2c0_inst_SDA
	.hps_0_hps_io_hps_io_i2c0_inst_SCL     ( HPS_I2C0_SCLK  ),        //                               .hps_io_i2c0_inst_SCL
	//HPS I2C2
	.hps_0_hps_io_hps_io_i2c1_inst_SDA     ( HPS_I2C1_SDAT  ),        //                               .hps_io_i2c1_inst_SDA
	.hps_0_hps_io_hps_io_i2c1_inst_SCL     ( HPS_I2C1_SCLK  ),        //                               .hps_io_i2c1_inst_SCL
	//GPIO 
	.hps_0_hps_io_hps_io_gpio_inst_GPIO09  ( HPS_CONV_USB_N ),  //                               .hps_io_gpio_inst_GPIO09
	.hps_0_hps_io_hps_io_gpio_inst_GPIO35  ( HPS_ENET_INT_N ),  //                               .hps_io_gpio_inst_GPIO35
	.hps_0_hps_io_hps_io_gpio_inst_GPIO40  ( HPS_LTC_GPIO   ),  //                               .hps_io_gpio_inst_GPIO40
	.hps_0_hps_io_hps_io_gpio_inst_GPIO53  ( HPS_LED   ),  //                               .hps_io_gpio_inst_GPIO53
	.hps_0_hps_io_hps_io_gpio_inst_GPIO54  ( HPS_KEY   ),  //                               .hps_io_gpio_inst_GPIO54
	.hps_0_hps_io_hps_io_gpio_inst_GPIO61  ( HPS_GSENSOR_INT ),  //                               .hps_io_gpio_inst_GPIO61
	//FPGA Partion
	.hps_0_h2f_reset_reset_n               ( hps_fpga_reset_n )                //                hps_0_h2f_reset.reset_n
 ); 

endmodule
