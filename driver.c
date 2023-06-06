#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <time.h>
#include <sys/mman.h>
#include <stdbool.h>
#include "mmap_hw_regs.h"
#include "led.h"
#include "dipsw_pio.h"
#include "key_pio.h"
#include "pio_reg_in.h"
#include "pio_reg_out.h"
#include "pio_reg_inout.h"
#include "led_gpio.h"
#include "key_gpio.h"
#include "driver.h"

void write_pi_reg_inout( unsigned int pio_reg_inout );
void write_pio_reg_out( unsigned int pio_reg_out );
unsigned int pio_reg_out;
unsigned int pio_reg_inout;

void DRIVER_setup();

void DRIVER_setup() {
	PIO_REG_IN_setup();
	PIO_REG_OUT_setup();
	PIO_REG_INOUT_setup();
}

void write_pio_reg_inout( unsigned int pio_reg_inout ) {
	printf ("write pio_reg_inout\t%s\n", PIO_REG_INOUT_binary_string( pio_reg_inout ) );
	PIO_REG_INOUT_write( pio_reg_inout );
}
void write_pio_reg_out( unsigned int pio_reg_out ) {
	printf ("write pio_reg_out\t%s\n", PIO_REG_OUT_binary_string( pio_reg_out ) );
	PIO_REG_OUT_write( pio_reg_out );
}
//FONCTION PRINCIPALE
void DRIVER_out_write_data( unsigned int data ) {
    write_pio_reg_out(data);//on met les données dans le registre pio_reg_out
	write_pio_reg_inout(1);//on met à 1 le registre pi_reg_inout pour dire au hardware que les données ont été placées dans le registre
	sleep(0.0001042);
	write_pio_reg_inout(0);
	sleep(1);
}