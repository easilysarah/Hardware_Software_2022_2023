// pio_reg_inout.h 
// PIO_REG_INOUT_BASE
#ifndef PIO_REG_INOUT_H_
#define PIO_REG_INOUT_H_
 
void PIO_REG_INOUT_setup();
unsigned int PIO_REG_INOUT_read();
void PIO_REG_INOUT_write( unsigned int data_out );
char *PIO_REG_INOUT_binary_string(unsigned int i );

#endif /*PIO_REG_INOUT_H_*/

 
