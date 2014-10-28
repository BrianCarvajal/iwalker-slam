/*  File    : dsfunc.c
 *  Abstract:
 *
 *      Example C-file S-function for defining a discrete system.  
 *
 *      x(n+1) = Ax(n) + Bu(n)
 *      y(n)   = Cx(n) + Du(n)
 *
 *      For more details about S-functions, see simulink/src/sfuntmpl_doc.c.
 * 
 *  Copyright 1990-2004 The MathWorks, Inc.
 *  $Revision: 1.12.4.2 $
 */

#define S_FUNCTION_NAME canReadTrama
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"
#include <windows.h>
#include "lawicel_can.h"

#define U(element) (*uPtrs[element])  /* Pointer to Input Port0 */


/*====================*
 * S-function methods *
 *====================*/

/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *    The sizes information is used by Simulink to determine the S-function
 *    block's characteristics (number of inputs, outputs, states, etc.).
 */
static void mdlInitializeSizes(SimStruct *S)
{

    ssSetNumSFcnParams(S, 0);  /* Number of expected parameters */
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        return; /* Parameter mismatch will be reported by Simulink */
    }

    ssSetNumContStates(S, 0);
    ssSetNumDiscStates(S, 10);

    if (!ssSetNumInputPorts(S, 1)) return;
    ssSetInputPortWidth(S, 0, 1);
    ssSetInputPortDirectFeedThrough(S, 0, 0);

    if (!ssSetNumOutputPorts(S, 1)) return;
    ssSetOutputPortWidth(S, 0, 8);

    ssSetNumSampleTimes(S, 1);
    ssSetNumRWork(S, 0);
    ssSetNumIWork(S, 0);
    ssSetNumPWork(S, 0);
    ssSetNumModes(S, 0);
    ssSetNumNonsampledZCs(S, 0);

    /* Take care when specifying exception free code - see sfuntmpl_doc.c */
//    ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE);

}



/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    Specifiy that we inherit our sample time from the driving block.
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    mxArray *array_ptr;
    double sampleTime;
    
    // Leemos el sample time definido por el usuario
    array_ptr = mexGetVariable("caller", "SampleTime");
    if (array_ptr == NULL ){
        mexPrintf("canReadTrama: No se encontro la variable SampleTime. Se usará 0.01\n");
        sampleTime = 0.01;
    }
    else
    {
        sampleTime=*((double*)(mxGetData(array_ptr)));
        mexPrintf("canReadTrama: Usando variable SampleTime con valor = %f\n", sampleTime);
    }
    //sampleTime = *sampleTimeTmp;
    /* Destroy array */
    mxDestroyArray(array_ptr);
    
    
    ssSetSampleTime(S, 0, sampleTime);
    ssSetOffsetTime(S, 0, 0.0);
    ////
}

#define MDL_INITIALIZE_CONDITIONS
/* Function: mdlInitializeConditions ========================================
 * Abstract:
 *    Initialize both discrete states to one.
 */
static void mdlInitializeConditions(SimStruct *S)
{
    InputRealPtrsType uPtrs = ssGetInputPortRealSignalPtrs(S,0);
    real_T *x0 = ssGetRealDiscStates(S);
    mxArray *array_ptr;
    int *handleTmp;

    UNUSED_ARG(S); /* unused input argument */

    x0[0]=0; 
    x0[2]=0; 
    x0[3]=0; 
    x0[4]=0; 
    x0[5]=0; 
    x0[6]=0; 
    x0[7]=0; 
    x0[8]=0; 
    x0[9]=0; 

    array_ptr = mexGetVariable("base", "handleCAN");
    if (array_ptr == NULL ){
	    mexPrintf("No se encontro la variable handleCAN al inicializar el bloque de LECTURA de tramas %d\n",(int)(U(0)));
        x0[1]=-1;
    }
    else
    {
        handleTmp=(int*)(mxGetData(array_ptr));
        x0[1]=(real_T)(*handleTmp);
    }
    /* Destroy array */
    mxDestroyArray(array_ptr);
}

/* Function: mdlOutputs =======================================================
 * Abstract:
 *      y = Cx + Du 
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
    real_T            *y    = ssGetOutputPortRealSignal(S,0);
    real_T            *x    = ssGetRealDiscStates(S);
    InputRealPtrsType uPtrs = ssGetInputPortRealSignalPtrs(S,0);
 
    UNUSED_ARG(tid); /* not used in single tasking mode */

    //ahora el #NOMSG (x[0]) no sale hacia afuera. Tenerlo en cuenta por si se
    //quisiera en un futuro
    y[0]=x[2];
    y[1]=x[3];
    y[2]=x[4];
    y[3]=x[5];
    y[4]=x[6];
    y[5]=x[7];
    y[6]=x[8];
    y[7]=x[9];
}



#define MDL_UPDATE
/* Function: mdlUpdate ======================================================
 * Abstract:
 *      xdot = Ax + Bu
 */
static void mdlUpdate(SimStruct *S, int_T tid)
{
    real_T            *x       = ssGetRealDiscStates(S);
    InputRealPtrsType uPtrs    = ssGetInputPortRealSignalPtrs(S,0);

CANHANDLE hndCAN;
//canStatus statCAN;
int statCAN;
long id=0;
unsigned int dlc=0;
unsigned int flg=0;
unsigned int i=0;
DWORD time=0;

CANMsg message;  
message.id=id;
message.timestamp=0;
message.flags=0;
message.len=8;

for (i=0;i<8;i++) message.data[i]=0;
 

    UNUSED_ARG(tid); /* not used in single tasking mode */

    hndCAN=(CANHANDLE)(x[1]);
    if (hndCAN>0)
    {
        //mexPrintf("Leyendo de CAN\n");
        id=(long)(U(0));
        //message.id=id;
               
        do {
            
            statCAN=canusb_ReadFirst(hndCAN,id,0,&message);
            //mexPrintf("statCAN vale %d\n",statCAN);
            
            if (statCAN==ERROR_CANUSB_NO_MESSAGE)
            {
                
                x[0]=x[0]+1;
            }
            else
            {
                //mexPrintf("Id trama: %d\n",message.id);
                x[2]=(real_T)((unsigned char)(message.data[0]));
                //mexPrintf("Byte0 vale: %d\n",message.data[0]);
                x[3]=(real_T)((unsigned char)(message.data[1]));
                //mexPrintf("Byte1 vale: %d\n",message.data[1]);
                x[4]=(real_T)((unsigned char)(message.data[2]));
                //mexPrintf("Byte2 vale: %d\n",message.data[2]);
                x[5]=(real_T)((unsigned char)(message.data[3]));
                //mexPrintf("Byte3 vale: %d\n",message.data[3]);
                x[6]=(real_T)((unsigned char)(message.data[4]));
                //mexPrintf("Byte4 vale: %d\n",message.data[4]);
                x[7]=(real_T)((unsigned char)(message.data[5]));
                //mexPrintf("Byte5 vale: %d\n",message.data[5]);
                x[8]=(real_T)((unsigned char)(message.data[6]));
                //mexPrintf("Byte6 vale: %d\n",message.data[6]);
                x[9]=(real_T)((unsigned char)(message.data[7]));
                //mexPrintf("Byte7 vale: %d\n",message.data[7]);
            }
        } while (statCAN==ERROR_CANUSB_OK);
    }
    // handleCAN == 0, devolvemos todo 0
    else {
        //mexPrintf("CAN no conectado, devolviendo todo 0\n");
        for (i = 2; i <= 9; i++) {
            x[i] = 0;
        }
    }
    //mexPrintf("salen\n");
}



/* Function: mdlTerminate =====================================================
 * Abstract:
 *    No termination needed, but we are required to have this routine.
 */
static void mdlTerminate(SimStruct *S)
{

    UNUSED_ARG(S); /* unused input argument */

}

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif
