/* For GCC compiler revise _write() function for printf functionality */

typedef struct UART_t {
	volatile unsigned int DATA;
	volatile unsigned int STATE;
	volatile unsigned int CTRL;
	volatile unsigned int INTSTATUS;
	volatile unsigned int BAUDDIV;
} UART_t;

#define UART0_ADDR ((UART_t *)(0x40000000))
#define UART_CTRL_TX_EN (1 << 0)
#define UART_CTRL_RX_EN (1 << 1)
#define UART_CTRL_TX_INTR_EN (1 << 2)
#define UART_CTRL_RX_INTR_EN (1 << 3)

int uart_init_done = 0;

/**
 * Initializes the UART
 */
void uart_init(void)
{
    if(!uart_init_done) {
        UART0_ADDR->BAUDDIV = 16;
        UART0_ADDR->CTRL = UART_CTRL_TX_EN | UART_CTRL_RX_EN | UART_CTRL_RX_INTR_EN;
        uart_init_done = 1;
    }
}

/**
 * Output a char to the UART TX
 */
void uart_putc(char c)
{
    UART0_ADDR->DATA =  c;
}

//TODO , check reenter issue in newlib while print call
int _write(int file, char *ptr, int len)
{
    int i;
    file = file;
    uart_init();
    for (i = 0; i < len; i++)
    {
        uart_putc(*ptr++);
    }
    return len;
}
