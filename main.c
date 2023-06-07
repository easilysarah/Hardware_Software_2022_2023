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

int main() {
	MMAP_open();
	DRIVER_setup();

	while(1) {
		char c;
        printf ("write pio_reg_out\n");
        scanf(" %c",&c);
        int i;
        int bit;
        printf("Représentation binaire de c = ");
        for (i = 7; i >= 0; i--) {
            bit = (c >> i) & 1;
            printf("%d",bit);
        }
        printf("\n");

        DRIVER_out_write_data(c);
	}
	MMAP_close();
	return 0;
}
