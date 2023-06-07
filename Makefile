#
TARGET = HPS_app

#
CROSS_COMPILE = arm-linux-gnueabihf-
CFLAGS = -g -Wall  -I${SOCEDS_DEST_ROOT}/ip/altera/hps/altera_hps/hwlib/include
LDFLAGS =  -g -Wall 
CC = $(CROSS_COMPILE)gcc
ARCH= arm


build: $(TARGET)
$(TARGET): main.o led.o mmap_hw_regs.o led_gpio.o key_gpio.o dipsw_pio.o key_pio.o pio_reg_in.o pio_reg_out.o pio_reg_inout.o driver.o
	$(CC) $(LDFLAGS)   $^ -o $@  
%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f $(TARGET) *.a *.o *~ 
