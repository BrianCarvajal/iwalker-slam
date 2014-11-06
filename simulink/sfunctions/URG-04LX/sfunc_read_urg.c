
#define S_FUNCTION_NAME  sfunc_read_urg
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"
#include <fcntl.h>
#include <stdio.h>
#include "windows.h"
#include <tchar.h>

unsigned int  ss_port;

HANDLE hCom;
DCB dcb;

//unsigned int logURG[409800]; /*600*(682+1)*/
int actLogURG = 0;
int numURG = 0;

unsigned char buf[3000]; // era 1456 pero por si acaso el laser devuelve mas informacion
int act_urg = 0;
int res[682];
int verbose = 0;
bool isFIFOURGcreated;

void openURG(unsigned char COMnumber){   
    char portString[20];
    if (verbose) printf("URG: call openURG()\n");
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
        if (verbose) printf("URG: Opening Port...");
        SetCommState(hCom, &dcb);
        if (verbose) printf(" Ok!\n");
        urg_start_single_scan();
    }
    else {
        if (verbose) printf("URG: Error opening Port\n");
    }
    if (verbose) printf("URG: return openURG()\n");
}

int readURG(unsigned char *buf, int size) {   
    unsigned long aux=size;
    if (verbose) printf("URG: call readURG()\n");
    if (ReadFile(hCom,
            buf,
            size,
            &aux,
            NULL) == 0)
    {
        if (verbose) printf("URG: ReadFile() Ok\n");
        return 0;
    } else {
        if (verbose) printf("URG: ERROR in ReadFile()\n");
    }
    if (aux > 0)
    {
        return (int)aux;
    }
    if (verbose) printf("URG: return readURG()\n");
    return (int)0-aux;
}

int urg_start_single_scan(void) {  
    DWORD dwBytesWritten = 0;
    int res = 0;
    char msg[256];
    if (verbose) printf("URG: call urg_start_single_scan()\n");
    sprintf(msg,"MS0044072500001\r\n");
    
    if (verbose) printf("URG: Sending text: %s\n", msg);
    if(!WriteFile(hCom, msg, strlen(msg), &dwBytesWritten, NULL))
    {
        if (verbose) printf( "URG: Error writing text to %s\n", msg);
    }
    else
    {
       if (verbose) printf( "URG: %d bytes written\n", dwBytesWritten);
    }
    if (verbose) printf("URG: return urg_start_single_scan()\n");
    return dwBytesWritten;
}

void closeURG(){
    if (verbose) printf("URG: call closeURG()\n");
    CloseHandle(hCom);
    if (verbose) printf("URG: return closeURG()\n");
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
        if (verbose) printf("[%c%c]",buf[i], buf[i+1]);
        if (!isLF(buf[i+1])) {
            data[0] = buf[i];
            data[1] = buf[i+1];
            res[j] = char_decode(data, 2);
            j++;
        }
        i+=2;
    }
}

int isLF(char c) {
    return (c == '\r' || c == '\n');
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
  //  printf("URG: 111\n");
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
    
    printf("URG: Inicializando driver URG-04LX...\n");
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
    printf("URG: 2222\n");
    // Leemos el sample time definido por el usuario
    array_ptr = mexGetVariable("caller", "SampleTime");
    if (array_ptr == NULL ){
        printf("URG: No se encontro la variable SampleTime. Se usará 0.5\n");
        sampleTime = 0.5;
    }
    else
    {
        sampleTime=*((double*)(mxGetData(array_ptr)));
        printf("URG: Usando variable SampleTime con valor = %f\n", sampleTime);
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
 *    start of model execution. If you
 *    have states that should be initialized once, this is the place
 *    to do it.
 */
static void mdlStart(SimStruct *S) {
    mxArray *array_ptr;
    double *tmp;
    char COM;
    if (verbose) printf("URG: call mdlStart()\n");
    // Leemos el COM definido por el usuario
    array_ptr = mexGetVariable("caller", "COM");
    if (array_ptr == NULL ){
        printf("URG: No se encontro la variable COM. Se intentara usar COM1\n");
        verbose = 0;
    }
    else
    {
        tmp=(double*)(mxGetData(array_ptr));
        COM=(unsigned char)(*tmp);
        printf("URG: Usando COM%d\n",COM);
    }
    
    // Leemos el flag Verbose
    array_ptr = mexGetVariable("caller", "Verbose");
    if (array_ptr == NULL ){
        printf("URG: No se encontro la variable Verbose. Se desactiva Verbose");
        COM=1;
    }
    else
    {
        tmp=(double*)(mxGetData(array_ptr));
        verbose=(int)(*tmp);
        if (verbose) {
            printf("URG: Verbose activado\n");
        } else {
            printf("URG: Verbose desactivado\n");
        }
    }   
    /* Destroy array */
    mxDestroyArray(array_ptr);        
    memset(buf, 0, sizeof(buf));
    memset(res, 0, sizeof(res));    
    openURG(COM);   
    //urg_start_single_scan();
    if (verbose) printf("URG: return mdlStart()\n");
}
#endif /*  MDL_START */

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
    //if (verbose) printf("asignacion: %d\n",n = readURG(&car, sizeof(car)));
    if (verbose) printf("URG: \n\n=====================================\n");
    if (verbose) printf("URG: Lectura de laser: \n");
    if (verbose) printf("URG: Leyendo cabecera...\n");

    // Leemos los datos disponibles y pedimos una nueva lectura
    n = readURG(buf, sizeof(buf));
    urg_start_single_scan();
    if (verbose) printf("URG: %d bytes leidos\n", n);
//     for (i = 0; i < n; i++) {
//         if (verbose) printf("%c",buf[i]);
//     }
    
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
        if (verbose) printf("URG: Datos leidos, decodificando...\n");
        //buf[act] = '\0';
        memset(res, 0, sizeof(res));
        urg_decode(&(buf[startData]), res);
        memset(aux, 0, sizeof(aux));

        if (verbose) printf("URG: Convirtiendo a Integer...\n");
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
        if (verbose) printf("URG: Fin lectura laser\n");
        
        for (i=0; i<682; i++) y[i] = res[i];
        if (verbose) printf("URG: copia realizada en Output laser\n");
    }
    else {
        if (verbose) printf("URG: Datos no disponibles\n");
    }      
}

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


/*=============================*
 * Required S-function trailer *
 *=============================*/

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif
