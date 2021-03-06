
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

unsigned char buf[2000]; // era 1456 pero por si acaso el laser devuelve mas informacion
int act_urg = 0;
int res[682];
int verbose = 0;
bool isFIFOURGcreated;

void openURG(unsigned char COMnumber){
    char portString[20];
    if (verbose) printf("URG: call openURG()\n");
    sprintf(portString,"\\\\.\\COM%d",COMnumber);
    if (verbose) {
        printf(portString);
        printf("\n");
    }
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
    if (ReadFile(hCom,buf,size,&aux,NULL) == 0)
    {
        if (verbose) printf("URG: ReadFile() failed\n");
        return 0;
    } else {
        if (verbose) printf("URG: OK in ReadFile()\n");
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
    sprintf(msg,"MS0044072500001\n");
    
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
    
    int k;
    int i,idx,j=0;
    char data[2];
    char startIdx=47;  // era 26
    
    for (k=0; k<21; k++) {
        
        idx = startIdx + k*66;
        
        for (i=0;i<64;i+=2) {
            
            data[0]=buf[idx + i];
            data[1]=buf[idx + i+1];
            res[j] = char_decode(data, 2);
            j++;
        }
    }
    
    idx = startIdx + 21*66;
    
    for (i=0;i<20;i+=2) {
        
        data[0]=buf[idx + i];
        data[1]=buf[idx + i +1];
        res[j] = char_decode(data, 2);
        j++;
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
    // printf("URG: 2222\n");
    // Leemos el sample time definido por el usuario
    array_ptr = mexGetVariable("caller", "SampleTime");
    if (array_ptr == NULL ){
        printf("URG: No se encontro la variable SampleTime. Se usar� 0.5\n");
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
    urg_start_single_scan();
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
    int act;
    char car;
    int negative;
    //printf("asignacion: %d\n",n = readURG(&car, sizeof(car)));
    //printf("lectura de laser: \n");
    act = 0;
    while((readURG(&car, sizeof(car)))==1) {
        
        buf[act] = car;
        act++;
        // printf("%c",car);
        if ((act>1) && ((buf[act-1] == '\r') || (buf[act-1] == '\n')) && ((buf[act-2] == '\r') || (buf[act-2] == '\n'))) {
            
            if (act>1000) {
                
                buf[act] = '\0';
                
                memset(res, 0, sizeof(res));
                urg_decode(buf,res);
                
                memset(aux, 0, sizeof(aux));
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
                
                act=0;
                memset(buf, 0, sizeof(buf));
                break;
            }
        }
    }
    urg_start_single_scan();
    negative = 0;
    for (i=0; i<682; i++)
    {
        if (res[i] < 0)
        {
            negative = 1;
            break;
        }
        else 
        {
            y[i] = res[i];
        }
    }
    // Si hay algun negativo son datos invaldiso: devolvemos todo 0
    if (negative == 1)
    {
        for (i=0; i<682; i++) y[i] = 0;
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
