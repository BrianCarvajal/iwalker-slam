/*  File    : sampleTimeSync.c
 *  Abstract:
 *
 *      C-file S-function para sincronizarse con los tiempos de sampleo,
 *      mediante el uso de un reloj en tiempo real (PerformanceCounter)
 *      De esa forma, conseguimos una simulacion pseudo-tiempo-real.
 *
 *  Copyright 2007 Toni Benedico Blanes
 *  Version: 1.0
 */

#define S_FUNCTION_NAME sampleTimeSync
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"
#include "windows.h"

#define U(element) (*uPtrs[element])  /* Pointer to Input Port0 */

char primeraIteracio;
LONGLONG ticsPerSegon;
LONGLONG ticsAnteriors;
time_T sampleTime;

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
    BOOL out_qpf;
    LARGE_INTEGER tmp_qpf;
    
    ssSetNumSFcnParams(S, 0);  /* Number of expected parameters */
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        return; /* Parameter mismatch will be reported by Simulink */
    }
    
    ssSetNumContStates(S, 0);
    ssSetNumDiscStates(S, 1);
    
    if (!ssSetNumInputPorts(S, 0)) return;
    if (!ssSetNumOutputPorts(S, 1)) return;
    ssSetOutputPortWidth(S, 0, 1);
    
    ssSetNumSampleTimes(S, 1);
    ssSetNumRWork(S, 0);
    ssSetNumIWork(S, 0);
    ssSetNumPWork(S, 0);
    ssSetNumModes(S, 0);
    ssSetNumNonsampledZCs(S, 0);
    
    /* Take care when specifying exception free code - see sfuntmpl_doc.c */
//    ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE);
    
    
    out_qpf = QueryPerformanceFrequency( &tmp_qpf);
    ticsPerSegon=tmp_qpf.QuadPart;
    printf("PerformanceCounter Frequency: %08X",(ticsPerSegon>>32)&0x0FFFFFFFF);
    printf("%08X\n",ticsPerSegon&0x0FFFFFFFF);
    
    primeraIteracio=1;
    
}



/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    Specifiy that we inherit our sample time from the driving block.
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    InputRealPtrsType uPtrs = ssGetInputPortRealSignalPtrs(S,0);
    mxArray *array_ptr;
    double stTmp;
    
    // Leemos el sample time definido por el usuario
    array_ptr = mexGetVariable("caller", "SampleTime");
    if (array_ptr == NULL ){
        mexPrintf("No se encontro la variable SampleTime. Se usará 0.001\n");
        stTmp = 0.001;
    }
    else
    {
        stTmp=*((double*)(mxGetData(array_ptr)));
        mexPrintf("Usando variable SampleTime con valor = %f\n", sampleTime);
    }
    sampleTime = stTmp;
    /* Destroy array */
    mxDestroyArray(array_ptr);
    
    ssSetSampleTime(S, 0, sampleTime);
    ssSetOffsetTime(S, 0, 0.0);
}

#define MDL_INITIALIZE_CONDITIONS
/* Function: mdlInitializeConditions ========================================
 * Abstract:
 *    Initialize both discrete states to one.
 */
static void mdlInitializeConditions(SimStruct *S)
{
    real_T *x0 = ssGetRealDiscStates(S);
    
    x0[0]=0;
}



/* Function: mdlOutputs =======================================================
 * Abstract:
 *      y = Cx + Du
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
    
    real_T            *y    = ssGetOutputPortRealSignal(S,0);
    real_T            *x    = ssGetRealDiscStates(S);
//    InputRealPtrsType uPtrs = ssGetInputPortRealSignalPtrs(S,0);
    
    UNUSED_ARG(tid); /* not used in single tasking mode */
    
    y[0]=x[0];
}



#define MDL_UPDATE
/* Function: mdlUpdate ======================================================
 * Abstract:
 *      xdot = Ax + Bu
 */
static void mdlUpdate(SimStruct *S, int_T tid)
{
//    real_T            tempX[2] = {0.0, 0.0};
    real_T            *x       = ssGetRealDiscStates(S);
//    InputRealPtrsType uPtrs    = ssGetInputPortRealSignalPtrs(S,0);
    BOOL out_qpf;
    LARGE_INTEGER tmp_qpf;
    LONGLONG ticsTarget;
    LONGLONG tmpTicsPeriode;
    
    UNUSED_ARG(tid); /* not used in single tasking mode */
    
    /*
    x[0]=x[0]+U(0);
    x[1]=x[1]+U(1);
     */
    
    if (primeraIteracio)
    {
        primeraIteracio=0;
        out_qpf = QueryPerformanceCounter( &tmp_qpf);
        ticsAnteriors=tmp_qpf.QuadPart;
    }
    
    tmpTicsPeriode=ticsPerSegon/((LONGLONG)(1.0/sampleTime));
    ticsTarget=ticsAnteriors+tmpTicsPeriode;
    out_qpf = QueryPerformanceCounter( &tmp_qpf);
//if (tmp_qpf.QuadPart>ticsTarget)
//    x[0]=101;
//else
    x[0]=100-((ticsTarget-tmp_qpf.QuadPart)*100)/tmpTicsPeriode;
    
    do
    {
        out_qpf = QueryPerformanceCounter( &tmp_qpf);
    } while(tmp_qpf.QuadPart<ticsTarget);
    ticsAnteriors=ticsTarget;
    
//printf("Contador:  %08X",(ticsTarget>>32)&0x0FFFFFFFF);
//printf("%08X\n",ticsTarget&0x0FFFFFFFF);
    
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
