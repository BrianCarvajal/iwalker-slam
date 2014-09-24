
#define S_FUNCTION_NAME  sfunc_read_urg
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"
#include <fcntl.h>
#include <stdio.h>
#include "windows.h"
#include <tchar.h>
#include "sfunc_rtai_serial.h"

//unsigned int logURG[409800]; /*600*(682+1)*/
int actLogURG = 0;
int numURG = 0;

unsigned char buf[3000]; // era 1456 pero por si acaso el laser devuelve mas informacion
int act_urg = 0;
int res[682];
bool isFIFOURGcreated;
//struct timeval timestamp;

// Parametros leidos desde simulink



void openURG(unsigned char COMnumber){
    
    char portString[20];
    sprintf(portString,"\\\\.\\COM%d",COMnumber);
    hCom= CreateFile(portString, GENERIC_READ | GENERIC_WRITE, 0 , NULL, OPEN_EXISTING, 0, NULL);
    
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
        return (int)aux;
    }
    return (int)0-aux;
    //return 0-size; //??????????
    /* int aux = 1;
     * #ifndef MEX_PATCH
     * aux = rt_spread(ss_port, buf, size);
     * #endif
     * return 0 - aux;*/
}

int urg_start_single_scan(void) {
    DWORD dwBytesWritten = 0;
    int res = 0;
    char msg[256];
    sprintf(msg,"MS0044072500001\r");
    
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
     * res = rt_spwrite(ss_port,msg,strlen(msg));
     * #endif*/
    return dwBytesWritten;
}

void closeURG(){
    CloseHandle(hCom);
    /*#ifndef MEX_PATCH
     * rt_spclose(ss_port);
     * #endif*/
}

/*====================*
 * S-function methods *
 *====================*/

/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *    The sizes information is used by Simulink to determine the S-function
 *    block's characteristics (number of inputs, outputs, states, etc.).
 */
static void mdlInitializeSizes(SimStruct *S) {
    
    ssSetNumSFcnParams(S, 0);  /* Number of expected parameters */
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        /* Return if number of expected != number of actual parameters */
        return;
    }
    
    ssSetNumContStates(S, 0);
    ssSetNumDiscStates(S, 0);
    
    if (!ssSetNumInputPorts(S, 0)) return;
    
    if (!ssSetNumOutputPorts(S, 1)) return;
    ssSetOutputPortWidth(S, 0, 682);
    ssSetOutputPortDataType(S, 0, SS_INT16);
    
    ssSetNumSampleTimes(S, 1);
    ssSetNumRWork(S, 0);
    ssSetNumIWork(S, 0);
    ssSetNumPWork(S, 0);
    ssSetNumModes(S, 0);
    ssSetNumNonsampledZCs(S, 0);
    
    
    /* Specify the sim state compliance to be same as a built-in block */
    //  ssSetSimStateCompliance(S, USE_DEFAULT_SIM_STATE);
    
    ssSetOptions(S, 0);
    
    printf("Inicializando...\n");
}


/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    This function is used to specify the sample time(s) for your
 *    S-function. You must register the same number of sample times as
 *    specified in ssSetNumSampleTimes.
 */
static void mdlInitializeSampleTimes(SimStruct *S) {
    mxArray *array_ptr;
    double sampleTime;
    
    // Leemos el sample time definido por el usuario
    array_ptr = mexGetVariable("caller", "SampleTime");
    if (array_ptr == NULL ){
        mexPrintf("No se encontro la variable SampleTime. Se usará 0.5\n");
        sampleTime = 0.5;
    }
    else
    {
        sampleTime=*((double*)(mxGetData(array_ptr)));
        //mexPrintf("Block 'sfunc_read_urg' has get the Laser SampleTime from workspace: COM%d\n",COM);
    }
    //sampleTime = *sampleTimeTmp;
    /* Destroy array */
    mxDestroyArray(array_ptr);
    
    
    ssSetSampleTime(S, 0, sampleTime);
    ssSetOffsetTime(S, 0, 0.0);
}


#define MDL_START  /* Change to #undef to remove function */
#if defined(MDL_START)
/* Function: mdlStart =======================================================
 * Abstract:
 *    This function is called once at
 * char aux[20];start of model execution. If you
 *    have states that should be initialized once, this is the place
 *    to do it.
 */
static void mdlStart(SimStruct *S) {
    mxArray *array_ptr;
    double *COMTmp;
    char COM;
    
    // Leemos el COM definido por el usuario
    array_ptr = mexGetVariable("caller", "COM");
    if (array_ptr == NULL ){
        mexPrintf("No se encontro la variable COM. Se intentara usar COM1\n");
        COM=1;
    }
    else
    {
        COMTmp=(double*)(mxGetData(array_ptr));
        COM=(unsigned char)(*COMTmp);
        mexPrintf("Block 'sfunc_read_urg' has get the Laser COM number from workspace: COM%d\n",COM);
    }
    /* Destroy array */
    mxDestroyArray(array_ptr);
    
    
    memset(buf, 0, sizeof(buf));
    memset(res, 0, sizeof(res));
    
    
    
    openURG(COM);
    
    urg_start_single_scan();
}
#endif /*  MDL_START */


/* Function: mdlTerminate =====================================================
 * Abstract:
 *    In this function, you should perform any actions that are necessary
 *    at the termination of a simulation.  For example, if memory was
 *    allocated in mdlStart, this is the place to free it.
 *
 */
static void mdlTerminate(SimStruct *S) {
    closeURG();
}


short char_decode(const unsigned char data[], int data_byte) {
    
    short value = 0;
    int i;
    
    for (i = 0; i < data_byte; ++i) {
        value <<= 6;
        value &= ~0x3f;
        value |= data[i] - 0x30;
    }
    
    return value;
}


void urg_decode(unsigned char *buf, int *res) {
    
    int i = 0;
    int j = 0;
    char data[2];
    
    // 2 LF seguidos marcan el final de los datos
    while (!(isLF(buf[i+1]) && isLF(buf[i+2]))) {
        //Leemos los bytes de 2 en 2. Si el segundo byte es LF es fin de
        //linea de 64 bytes + byte de suma + byte LF
        printf("[%c%c]",buf[i], buf[i+1]);
        if (!isLF(buf[i+1])) {
            data[0] = buf[i];
            data[1] = buf[i+1];
            res[j] = char_decode(data, 2);
            j++;
        }
        i+=2;
    }
    
//     // Decodificamos las lineas completas
//     for (k = 0; k < fullLines; k++) {
//         idx = k*66;
//         for (i=0;i<64;i+=2) {
//
//             data[0]=buf[idx + i];
//             data[1]=buf[idx + i+1];
//             res[j] = char_decode(data, 2);
//             j++;
//         }
//     }
//
//     // Decodificamos la última linea
//     idx = fullLines*66;
//     for (i =0 ; i < lenLastLine; i+=2) {
//         data[0]=buf[idx + i];
//         data[1]=buf[idx + i +1];
//         res[j] = char_decode(data, 2);
//         j++;
//     }
}

int isLF(char c) {
    return (c == '\r' || c == '\n');
}

/* Function: mdlOutputs =======================================================
 *
 * Abstract:
 *    In this function, you compute the outputs of your S-function
 *    block.
 */


int n,i,j;
unsigned long time;
unsigned char bytes[4];
unsigned char aux[2732];

union {
    unsigned char bytes[4];
    unsigned int val;
} biconvert;

static void mdlOutputs(SimStruct *S, int_T tid) {
    uint16_T *y = ssGetOutputPortSignal(S,0);
    unsigned char c; // catacter leido del laser
    int act = 0; // indice actual del buffer
    int i;
    int lenLine = 0;
    int startData = 0;
    //printf("asignacion: %d\n",n = readURG(&car, sizeof(car)));
    printf("\n\n=====================================\n");
    printf("Lectura de laser: \n");
    printf("Leyendo cabecera...\n");

    // Leemos los datos disponibles y pedimos una nueva lectura
    n = readURG(buf, sizeof(buf));
    urg_start_single_scan();
    printf("%d bytes leidos\n", n);
    for (i = 0; i < n; i++) {
        printf("%c",buf[i]);
    }
    
    i = 0;
    while (i < n && lenLine < 64) {
        //Si encontramos LF es nueva linea
        if (isLF(buf[i])) {
            lenLine = 0;
            startData = i+1;
        } else {
            lenLine++;
        }
        i++;
    }
    
    if (lenLine >= 64) {
        printf("\nDatos leidos, decodificando...\n");
        //buf[act] = '\0';
        memset(res, 0, sizeof(res));
        urg_decode(&(buf[startData]), res);
        memset(aux, 0, sizeof(aux));

        printf("\nConvirtiendo a Integer...\n");
        j=0;
        for (i=0; i<682; i++) {
            biconvert.val = res[i];
            aux[j++] = biconvert.bytes[0];
            aux[j++] = biconvert.bytes[1];
            aux[j++] = biconvert.bytes[2];
            aux[j++] = biconvert.bytes[3];
        }
        biconvert.val = time;
        aux[j++] = biconvert.bytes[0];
        aux[j++] = biconvert.bytes[1];
        aux[j++] = biconvert.bytes[2];
        aux[j++] = biconvert.bytes[3];
        
        memset(buf, 0, sizeof(buf));
        printf("\nfin lectura laser\n");
        
        for (i=0; i<682; i++) y[i] = res[i];
        printf("copia realizada en Output laser\n");
    }
    else {
        printf("Datos no disponibles\n");
    }      
}



/*=============================*
 * Required S-function trailer *
 *=============================*/

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif
