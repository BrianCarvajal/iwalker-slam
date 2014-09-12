#define SAMPLES_URG  1000


#define SAMPLE_TIME_URG     0.04

#include <windows.h>
#include <stdio.h>
#include "windows.h"


unsigned int  ss_port;



HANDLE hCom;
DCB dcb;


void openURG(){
    
   // int res;
    
     hCom= CreateFile("\\\\.\\COM5", GENERIC_READ | GENERIC_WRITE, 0 , NULL, OPEN_EXISTING, 0, NULL);

    
    ZeroMemory(&dcb, sizeof(dcb));
    dcb.DCBlength = sizeof(DCB);
    if ( GetCommState(hCom, &dcb) )
    {
           // Set as needed
           dcb.BaudRate = CBR_115200;     
           dcb.ByteSize = 8;      
           dcb.Parity = NOPARITY;
           dcb.StopBits = ONESTOPBIT;
            printf("Open Port\n");
           SetCommState(hCom, &dcb);
    }
    else printf("Error opening Port\n");
    
 
}

int readURG(unsigned char *buf, int size) {

   unsigned long aux=size;
   //printf("ReadURG\n");
   if (ReadFile(hCom, 
    buf,               
    size,              
    &aux,                 
    NULL) == 0)             
  {
   
    return 0;
  }
  if (aux > 0)
  {
      //printf("Read - %c\n",buf);
   // buf[size] = NULL; // Assign end flag of message.
     return (int)0-aux;  
  }  
 return (int)0-aux;
    //return 0-size; //??????????
   /* int aux = 1;
    #ifndef MEX_PATCH
    aux = rt_spread(ss_port, buf, size);
    #endif
    return 0 - aux;*/
}

int urg_start_single_scan(void) {
    DWORD dwBytesWritten = 0;
    int res = 0;
    char msg[256];
    sprintf(msg,"MS0044072500001\r\n");
    
   // printf("Sending text: %s\n", msg);
    if(!WriteFile(hCom, msg, strlen(msg),
                    &dwBytesWritten, NULL))
    {
        printf( "Error writing text to %s\n", msg);
    }
    else
    {
      //  printf( "%d bytes written\n", dwBytesWritten);
    }
    
   /* #ifndef MEX_PATCH
    res = rt_spwrite(ss_port,msg,strlen(msg)); 
    #endif*/
    return dwBytesWritten;
}

void closeURG(){
    CloseHandle(hCom);
    /*#ifndef MEX_PATCH
    rt_spclose(ss_port);
    #endif*/
}
