
#define S_FUNCTION_NAME  sfunc_read_urg
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"
#include <fcntl.h>
//#include <unistd.h>
#include <stdio.h>
#include "windows.h"
#include <tchar.h>



#include "sfunc_rtai_serial.h"




//unsigned int logURG[409800]; /*600*(682+1)*/
int actLogURG = 0;
int numURG = 0;

unsigned long timesUrg[SAMPLES_URG];
unsigned char buf[1456];
int act_urg = 0;
int act=0;
int res[682];
bool isFIFOURGcreated;
//struct timeval timestamp;


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

    ssSetSampleTime(S, 0, 0.5);
    ssSetOffsetTime(S, 0, 0.0);
}


#define MDL_START  /* Change to #undef to remove function */
#if defined(MDL_START) 
/* Function: mdlStart =======================================================
* Abstract:
*    This function is called once at 
char aux[20];start of model execution. If you
*    have states that should be initialized once, this is the place
*    to do it.
*/
static void mdlStart(SimStruct *S) {
    
    memset(buf, 0, sizeof(buf));
    memset(res, 0, sizeof(res));
    
    openURG();
    
    urg_start_single_scan();
}
#endif /*  MDL_START */


/* Function: mdlTerminate =====================================================
 * Abstract:
 *    In this function, you should perform any actions that are necessary
 *    at the termination of a simulation.  For example, if memory was
 *    allocated in mdlStart, this is the place to free it.

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
    
    int k;
    int i,act,j=0;
    char data[2];
   
    for (k=0; k<21; k++) {
        
        act = 26 + k*66;
        
        for (i=0;i<64;i+=2) {
                
            data[0]=buf[act + i];
            data[1]=buf[act + i+1];
            res[j] = char_decode(data, 2);
            j++;
        }
    }
    
    act = 26 + 21*66;
    
    for (i=0;i<20;i+=2) {
                
        data[0]=buf[act + i];
        data[1]=buf[act + i +1];
        res[j] = char_decode(data, 2);
        j++;
    }
}


/* Function: mdlOutputs =======================================================

 * Abstract:
 *    In this function, you compute the outputs of your S-function
 *    block.
 */

unsigned char car;
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
   
   
    //printf("asignacion: %d\n",n = readURG(&car, sizeof(car)));
      while((n = readURG(&car, sizeof(car)))==-1) {
	    
        buf[act] = car;
        act++;
         //printf("leido: %c\n",car);
        if ((act>1) && ((buf[act-1] == '\r') || (buf[act-1] == '\n')) && ((buf[act-2] == '\r') || (buf[act-2] == '\n'))) {
            
            if (act==1435) {
                
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
                

                
            }
            
            if (act>22) urg_start_single_scan();            
            act=0;            
            memset(buf, 0, sizeof(buf));
            break;
        }
	}
    
    for (i=0; i<682; i++) y[i] = res[i];
    

 /*   if (act_urg<SAMPLES_URG) {
    //    timesUrg[act_urg] = timestamp.tv_sec*1000000 + timestamp.tv_usec;
        act_urg++;
    }*/


}



/*=============================*
 * Required S-function trailer *
 *=============================*/

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif
