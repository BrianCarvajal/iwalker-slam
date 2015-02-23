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

#define S_FUNCTION_NAME canWriteTrama
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
    ssSetNumDiscStates(S, 11);

    if (!ssSetNumInputPorts(S, 1)) return;
    ssSetInputPortWidth(S, 0, 10);
    ssSetInputPortDirectFeedThrough(S, 0, 0);

    if (!ssSetNumOutputPorts(S, 0)) return;

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
    InputRealPtrsType uPtrs = ssGetInputPortRealSignalPtrs(S,0);
mxArray *array_ptr;
double *tsTmp;
time_T sampleTime;

    array_ptr = mexGetVariable("base", "Ts");
    if (array_ptr == NULL ){
	    mexPrintf("No se encontro la variable Ts\n");
        sampleTime=0.001; // valor por defecto. Aunque no llegara a ejecutarse
                          // porque se quejara el parametro Ts del Solver Parameters
    }
    else
    {
        tsTmp=(double*)(mxGetData(array_ptr));
        sampleTime=(time_T)(*tsTmp);
        mexPrintf("Block 'canWriteTrama' has get the sample time from workspace: %f sec.\n",(double)sampleTime);
    }
    /* Destroy array */
    mxDestroyArray(array_ptr);

    ssSetSampleTime(S, 0, -1);
    ssSetOffsetTime(S, 0, 0.0);
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
    x0[10]=0; 

    array_ptr = mexGetVariable("base", "handleCAN");
    if (array_ptr == NULL ){
	    mexPrintf("No se encontro la variable handleCAN al inicializar el bloque de ESCRITURA de tramas %d\n",(int)(U(0)));
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

CANMsg message;     
CANHANDLE hndCAN;
int statCAN;



long id=0;
unsigned int dlc=0;
unsigned int i=0;

    UNUSED_ARG(tid); // not used in single tasking mode
    
    hndCAN=(CANHANDLE)(x[1]);
    //if (hndCAN>=0)
    //{
        // DLC viene como un parametro mas de input port: x[1]
        id=(long)(U(0));
        dlc=(unsigned int)(U(1));
        
        message.id=id;
        message.timestamp=0;
        message.flags=0;
        message.len=dlc;
       
        for (i=0;i<dlc;i++)
            message.data[i]=(unsigned char)(U(2+i));
        for (i=dlc;i<8;i++)
            message.data[i]=0; 
        
        //message.data[0]=30;
        //message.data[1]=20;
          
        if (dlc>0) statCAN=canusb_Write(hndCAN, &message);
        
        //else
        //    statCAN=canWrite(hndCAN, id, (void*)msg);

//mexPrintf("msg={%u,%u,%u,%u,%u,%u,%u,%u}\n",msg[0],msg[1],msg[2],msg[3],msg[4],msg[5],msg[6],msg[7]);
//mexPrintf("canWrite(%d,%d,(void*)msg,%d,canMSG_STD);\n",hndCAN, id, dlc);
        // En el caso del canWrite, retorna inmediatamente.
        // Eso no garantiza que el mensaje se haya enviado. Ha sido colocado 
        // en la cola de salida, y se enviara cuando pueda.

        // En x[0] recogemos el numero de veces que la llamada no ha ido bien.
        if (statCAN<=0)
        {
            x[0]=x[0]+1;
        }
    //}


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
