#include <SPI.h>
#include <MFRC522.h>
#include <SoftwareSerial.h>
#include <TimerOne.h>

#define RST_PIN1         6
#define SS_PIN1          5    

#define RST_PIN2         7 //8          
#define SS_PIN2          10 //4          

#define RST_PIN3         8//7          
#define SS_PIN3          4//10       

#define on  1
#define off 0

#define buzzer A0
#define in_vblutut A1

SoftwareSerial myBluetooth(2, 3);  // RX, TX pins for HC-05

MFRC522 mfrc522(SS_PIN1, RST_PIN1);     
MFRC522 mfrc522_2(SS_PIN2, RST_PIN2);   
MFRC522 mfrc522_3(SS_PIN3, RST_PIN3);   

void int_timer( void);

enum state_rdrfid{
  start,
  tunggu_ada,
  tunggu_kosong,
  nexck_kosong
};

char st_rd_rfid1=start;
char st_rd_rfid2=start;
char st_rd_rfid3=start;

bool bip=0;

String UID1 = "";
String UID2 = "";
String UID3 = "";

void setup() {
    Serial.begin(9600);     
    myBluetooth.begin(9600);
    while (!Serial);        
    SPI.begin();            

    mfrc522.PCD_Init();     
    mfrc522_2.PCD_Init();   
    mfrc522_3.PCD_Init();   
    
    Serial.println(F("Scanning ....."));

    pinMode(buzzer, OUTPUT);
    pinMode(in_vblutut, INPUT_PULLUP);
    digitalWrite(buzzer, 0);

    pinMode(RST_PIN3,OUTPUT);
    pinMode(SS_PIN3, OUTPUT);

    pinMode(RST_PIN2,OUTPUT);
    pinMode(SS_PIN2, OUTPUT);

    pinMode(RST_PIN1,OUTPUT);
    pinMode(SS_PIN1, OUTPUT);
}

void loop() {
 
    switch( st_rd_rfid1 )
    {
      case start:    
          delay(50);      
          mfrc522.PCD_Init();       
          delay(50);
          if ( mfrc522.PICC_IsNewCardPresent())          
          {
              UID1 = "";
              if (mfrc522.PICC_ReadCardSerial()) 
              {  // NUID has been readed
                for (int i = 0; i < mfrc522.uid.size; i++) 
                {
                  UID1 += String(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " ");
                  UID1 += String(mfrc522.uid.uidByte[i], HEX);
                }
                UID1.replace(" ", "");
                UID1.toUpperCase();
                Serial.println(UID1);

                if( UID1 == "B3654310" )
                {
                  Serial.println(F("1:ADA"));
                  myBluetooth.print("11\r\n");
                  st_rd_rfid1 = tunggu_kosong;                  
                }
                else Serial.println(F("1:TAG TIDAK TERDAFTAR"));
              }
                             
          }
          
          delay(50);
          mfrc522.PICC_HaltA();      
          mfrc522.PCD_StopCrypto1();
      break;
      
      case tunggu_kosong:      
          delay(50);
          mfrc522.PCD_Init();       
          delay(50);
          
          if (!mfrc522.PICC_IsNewCardPresent())
            st_rd_rfid1 = nexck_kosong;
            
          delay(10);
          mfrc522.PICC_HaltA();      
          mfrc522.PCD_StopCrypto1();               
      break;      

      case nexck_kosong:
          delay(10);
          mfrc522.PCD_Init();       
          delay(10);
          if (!mfrc522.PICC_IsNewCardPresent())
          {
            Serial.println(F("1:KOSONG"));
            myBluetooth.print("10\r\n");
            st_rd_rfid1 = start;
          }
          else st_rd_rfid1 = tunggu_kosong;
          delay(10);
          mfrc522.PICC_HaltA();      
          mfrc522.PCD_StopCrypto1();       
      break;
    }

    switch( st_rd_rfid2 )
    {
      case start:       
          delay(100);  
          mfrc522_2.PCD_Init();       
          delay(100); 
          if ( mfrc522_2.PICC_IsNewCardPresent())          
          {
              UID2 = "";
              if (mfrc522_2.PICC_ReadCardSerial()) 
              {  // NUID has been readed
                for (int i = 0; i < mfrc522_2.uid.size; i++) 
                {
                  UID2 += String(mfrc522_2.uid.uidByte[i] < 0x10 ? " 0" : " ");
                  UID2 += String(mfrc522_2.uid.uidByte[i], HEX);
                }
                UID2.replace(" ", "");
                UID2.toUpperCase();
                Serial.println(UID2);

                if( UID2 == "53063A96" )
                {
                  Serial.println(F("2:ADA"));
                  myBluetooth.print("21\r\n");
                  st_rd_rfid2 = tunggu_kosong;                  
                }
                else Serial.println(F("2:TAG TIDAK TERDAFTAR"));
              }
          }
          delay(100);
          mfrc522_2.PICC_HaltA();      
          mfrc522_2.PCD_StopCrypto1(); 
      break;
      
      case tunggu_kosong:      
          delay(50);
          mfrc522_2.PCD_Init();       
          delay(50);
          
          if (!mfrc522_2.PICC_IsNewCardPresent())
            st_rd_rfid2 = nexck_kosong;            
          
          delay(50);
          mfrc522_2.PICC_HaltA();      
          mfrc522_2.PCD_StopCrypto1(); 
      break;      

      case nexck_kosong:
          delay(10);
          mfrc522_2.PCD_Init();       
          delay(10);
          
          if (!mfrc522_2.PICC_IsNewCardPresent())
          {
            Serial.println(F("2:KOSONG"));
            myBluetooth.print("20\r\n");
            st_rd_rfid2 = start;
          }
          else st_rd_rfid2 = tunggu_kosong;
          
          delay(10);
          mfrc522_2.PICC_HaltA();      
          mfrc522_2.PCD_StopCrypto1();       
      break;
    }
    
    switch( st_rd_rfid3 )
    {
      case start:          
          delay(100);
          mfrc522_3.PCD_Init();       
          delay(100);
          if ( mfrc522_3.PICC_IsNewCardPresent())          
          {
              UID3 = "";
              if (mfrc522_3.PICC_ReadCardSerial()) 
              {  // NUID has been readed
                for (int i = 0; i < mfrc522_3.uid.size; i++) 
                {
                  UID3 += String(mfrc522_3.uid.uidByte[i] < 0x10 ? " 0" : " ");
                  UID3 += String(mfrc522_3.uid.uidByte[i], HEX);
                }
                UID3.replace(" ", "");
                UID3.toUpperCase();
                Serial.println(UID3);

                if( UID3 == "BAF4DA10" )
                {
                  Serial.println(F("3:ADA"));
                  myBluetooth.print("31\r\n");
                  st_rd_rfid3 = tunggu_kosong;                  
                }
                else Serial.println(F("3:TAG TIDAK TERDAFTAR"));
              }       
          }          
          
          delay(100);
          mfrc522_3.PICC_HaltA();      
          mfrc522_3.PCD_StopCrypto1(); 
      break;
      
      case tunggu_kosong:      
          delay(10);
          mfrc522_3.PCD_Init();       
          delay(10);
          
          if (!mfrc522_3.PICC_IsNewCardPresent())
            st_rd_rfid3 = nexck_kosong;
          
          delay(10);
          mfrc522_3.PICC_HaltA();      
          mfrc522_3.PCD_StopCrypto1(); 
      break;      

      case nexck_kosong:
          delay(10);
          mfrc522_3.PCD_Init();       
          delay(10);
          
          if (!mfrc522_3.PICC_IsNewCardPresent())
          {
            Serial.println(F("3:KOSONG"));
            myBluetooth.print("30\r\n");
            st_rd_rfid3 = start;
          }
          else st_rd_rfid3 = tunggu_kosong;
          
          delay(10);
          mfrc522_3.PICC_HaltA();      
          mfrc522_3.PCD_StopCrypto1();       
      break;
    }
    
    if( !digitalRead( in_vblutut))
    {
      //Serial.println("offline");
      bip ^= 1;
      digitalWrite(buzzer, bip);
    }
    else {         
      //Serial.println("online");
      digitalWrite(buzzer, 0);
    }
       
//------------------------------------------------
//loop forever    
}
