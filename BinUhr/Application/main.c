
			
	/*
 * BinUhr.c
 *
 * Created: 08.03.2024 
 * Author : Thorben Stehling
 */ 
#define F_CPU 32768UL
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>



volatile int INT0_pushed = 0;
volatile int INT1_pushed = 0;

uint8_t isSleeping = 0;

volatile uint8_t second;
volatile uint8_t minute;
volatile uint8_t hour;
uint8_t bitArray[11] = {0,0,0,0,0,0,0,0,0,0,0};


ISR(INT0_vect){
	
	if (!(PIND & (1 << PD2))) {
		_delay_ms(150);
		if (!(PIND & (1 << PD2))) {
			if(isSleeping == 0){
				isSleeping = 1;
				TIMSK2 &= ~(1 << OCIE2A);
				SMCR |= (1 << SM2) | (1 << SM1) | (1 << SM0);  // External (Extended?? Standby aktivieren
			}
			else{
				isSleeping = 0;
				SMCR = 0; // Zurück setzen	(IDLE)	
				TIMSK2 |= (1 << OCIE2A);
			}
			
		
		}
}
}






ISR(TIMER2_COMPA_vect){
	second++;
		if (second >= 60){
			minute++;
			second = 0;
		}
		if(minute >= 60){
			hour++;
			minute = 0;
		}
		if(hour >= 24){
			hour = 0;
		}
	}
	
	

	
void fillBitArray(uint8_t hour, uint8_t minute){
	
	for(int i = 0; i <= 5; i++){
		bitArray[i] = minute & 1;
		minute >>= 1;
	}
	
	
	for(int i = 6; i <= 10; i++){
		bitArray[i] = hour & 1;
		hour >>= 1;
	}
	
	
	
}


	

	
void showTime(uint8_t bitArray[]){
	//Minuten
	if(bitArray[0] == 1){
		PORTC |= (1 << 5);
	}
	else{
		PORTC &= ~(1 << 5);
	}
	if(bitArray[1] == 1){
		PORTC |= (1 << 0);
	}
	else{
		PORTC &= ~(1 << 0);
	}
	if(bitArray[2] == 1){
		PORTC |= (1 << 3);
	}
	else{
		PORTC &= ~(1 << 3);
	}
	if(bitArray[3] == 1){
		PORTC |= (1 << 2);
	}
	else{
		PORTC &= ~(1 << 2);
	}
	if(bitArray[4] == 1){
		PORTC |= (1 << 1);
	}
	else{
		PORTC &= ~(1 << 1);
	}
	
	//Stunden
	
	if(bitArray[5] == 1){
		PORTD |= (1 << 1);
	}
	else{
		PORTD &= ~(1 << 1);
	}
	if(bitArray[6] == 1){
		PORTB |= (1 << 0);
	}
	else{
		PORTB &= ~(1 << 0);
	}
	if(bitArray[7] == 1){
		PORTD |= (1 << 0);
	}
	else{
		PORTD &= ~(1 << 0);
	}
	if(bitArray[8] == 1){
		PORTC |= (1 << 4);
	}
	else{
		PORTC &= ~(1 << 4);
	}
	if(bitArray[9] == 1){
		PORTB |= (1 << 2);
	}
	else{
		PORTB &= ~(1 << 2);
	}
	if(bitArray[10] == 1){
		PORTB |= (1 << 1);
	}
	else{
		PORTB &= ~(1 << 1);
	}
	
	
	
	
}






int main(void)
{	
	cli();							
	DDRB = 0b00011111 ;
	DDRC = 0b00111111;
	DDRD = 0b11100011;
	PORTD |= (1 << 2) | (1 << 3) | (1 << 4);  //Pullups PD2 PD3 PD4 aktiviert
	
	
	EICRA = (1 << ISC11) |(1 << ISC01); // Interrupts auf fallende Flanke getriggert (pullup aktiv, taster betätigen zieht pegel auf low)
	EIMSK |= (1 << INT0) ; // enable INT0 und INT1
	 
	TCCR2A |= (1 << WGM21); // nutze CTC  Clear Timer on compare wird auf 0 gesetzt wenn TCNT2 (zähler) dem wert von OCR2A entspricht
	OCR2A = 127;
	TCCR2B |= (1 << CS21) | (1 << CS22); //prescaler auf 256 gesetzt  
	TIMSK2 |= (1 << OCIE2A);  // compare interrupt A erlaubt  Timer/Counter Interrupt Mask Register 
	    
	
					
	sei();
	
	
	
    while(1){
		
		
	fillBitArray(hour, minute);
	showTime(bitArray);
	
	
	
	if (!(PIND & (1 << PD3))) {
		_delay_ms(150);
		if (!(PIND & (1 << PD3))) {
			hour++;
			if(hour >= 24){
				hour = 0;
			}
		}
	}
	
	
	
	if (!(PIND & (1 << PD4))) {
		_delay_ms(150);
		if (!(PIND & (1 << PD4))) {
			minute++;
			if(minute >= 60){
				minute = 0;
			}
			
			
		}
	}
	


		
	}
	return 0;
}

/*		PORTC |= (1 << 5);
		_delay_ms(1000);
		PORTC |= (1 << 0);
		_delay_ms(1000);
		PORTC |= (1 << 3);
		_delay_ms(1000);
		PORTC |= (1 << 2);
		_delay_ms(1000);
		PORTC |= (1 << 1);
		_delay_ms(1000);
		
		PORTD |= (1 << 1);
		_delay_ms(1000);
		PORTB |= (1 << 0);
		_delay_ms(1000);
		PORTD |= (1 << 0);
		_delay_ms(1000);
		PORTC |= (1 << 4);
		_delay_ms(1000);
		PORTB |= (1 << 2);
		_delay_ms(1000);
		PORTB |= (1 << 1);
		_delay_ms(1000);
			
		*/


	
	
	

		
				
			
			
