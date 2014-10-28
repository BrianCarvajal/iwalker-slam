/*  File    : canInterface.c
 *  Abstract:
 *
 *      C-file S-function para gestionar la apertura y cierre del canal de
 *      comunicaciones CAN que ofrece Kvaser. Proporciona un "handle" que
 *      cualquier interlocutor puede hacer servir para escuchar o hablar
 *      por dicho canal.
 *      El handle es publicado como variable global y llamado "handleCAN"
 *
 *  Copyright 2007 Toni Benedico Blanes
 *  Version: 1.0
 */

#define S_FUNCTION_NAME canInterface
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
char msg[64];
mwSize dims[2]={1,1};
CANHANDLE hndCAN;
mxArray *array_ptr;
int *handleTmp;
int status;
int err;

    ssSetNumSFcnParams(S, 0);  /* Number of expected parameters */
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        return; /* Parameter mismatch will be reported by Simulink */
    }

    ssSetNumContStates(S, 0);
    ssSetNumDiscStates(S, 0);

    if (!ssSetNumInputPorts(S, 0)) return;
    if (!ssSetNumOutputPorts(S, 0)) return;

    ssSetNumSampleTimes(S, 1);
    ssSetNumRWork(S, 0);
    ssSetNumIWork(S, 0);
    ssSetNumPWork(S, 0);
    ssSetNumModes(S, 0);
    ssSetNumNonsampledZCs(S, 0);

    /* Take care when specifying exception free code - see sfuntmpl_doc.c */
    ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE);


    //canInitializeLibrary();
   
     
    err= canusb_Status(hndCAN);
    printf ("CanUSB Status: (%d)\n", err);
    
    hndCAN = canusb_Open(0,"1000",CANUSB_ACCEPTANCE_CODE_ALL,CANUSB_ACCEPTANCE_MASK_ALL,CANUSB_FLAG_QUEUE_REPLACE);
    if (hndCAN == 0) {
        //canGetErrorText((canStatus)hndCAN, msg, sizeof(msg));
        //mexPrintf("canOpenChannel failed (%s)\n", msg);
        printf("canOpenChannel failed (%s)\n", msg);
//        exit(1);
    }
    else
    {
        //mexPrintf("Can Open Channel0 OK!\n");
        printf("Can Open Channel0 OK!\n");
    }
    //canSetBusParams(hndCAN, BAUD_1M, 10, 5, 4, 1, 0);
    //canSetBusOutputControl(hndCAN, canDRIVER_NORMAL);
    //canBusOn(hndCAN);

    array_ptr=mxCreateNumericArray(2,dims,mxINT32_CLASS,mxREAL);
    handleTmp=(int*)(mxGetData(array_ptr));
    *handleTmp=hndCAN;
    /* Put variable in MATLAB base workspace */
    status=mexPutVariable("base", "handleCAN", array_ptr);
    if (status==1){
    	mexPrintf("Variable 'handleCAN': ");
        mexErrMsgTxt("Could not put variable in base workspace.\n");
    }
    /* Destroy array */
    mxDestroyArray(array_ptr);
}



/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    Specifiy that we inherit our sample time from the driving block.
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
//    InputRealPtrsType uPtrs = ssGetInputPortRealSignalPtrs(S,0);

    ssSetSampleTime(S, 0, mxGetInf());  // pensaba que poniendo Inf, no llamaria a
                                        // Outputs ni a Update, pero si lo hace. ¿solucionar?
    ssSetOffsetTime(S, 0, 0.0);
}

#define MDL_INITIALIZE_CONDITIONS
/* Function: mdlInitializeConditions ========================================
 * Abstract:
 *    Initialize both discrete states to one.
 */
static void mdlInitializeConditions(SimStruct *S)
{
//    real_T *x0 = ssGetRealDiscStates(S);

//    x0[0]=0; 
}



/* Function: mdlOutputs =======================================================
 * Abstract:
 *      y = Cx + Du 
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{

//    real_T            *y    = ssGetOutputPortRealSignal(S,0);
//    real_T            *x    = ssGetRealDiscStates(S);
//    InputRealPtrsType uPtrs = ssGetInputPortRealSignalPtrs(S,0);
 
    UNUSED_ARG(tid); // not used in single tasking mode
//printf("He entrado en outputs\n");
//    y[0]=x[0];
}



#define MDL_UPDATE
/* Function: mdlUpdate ======================================================
 * Abstract:
 *      xdot = Ax + Bu
 */
static void mdlUpdate(SimStruct *S, int_T tid)
{
//    real_T            tempX[2] = {0.0, 0.0};
//    real_T            *x       = ssGetRealDiscStates(S);
//    InputRealPtrsType uPtrs    = ssGetInputPortRealSignalPtrs(S,0);

    UNUSED_ARG(tid); // not used in single tasking mode
//printf("He entrado en update\n");


//    x[0]=x[0]+U(0);
//    x[1]=x[1]+U(1);



//printf("Contador:  %08X",(ticsTarget>>32)&0x0FFFFFFFF);
//printf("%08X\n",ticsTarget&0x0FFFFFFFF);

}



/* Function: mdlTerminate =====================================================
 * Abstract:
 *    No termination needed, but we are required to have this routine.
 */
static void mdlTerminate(SimStruct *S)
{
int statCAN;
char msg[64];
CANHANDLE hndCAN = 0;
mxArray *array_ptr;
int *handleTmp;

    UNUSED_ARG(S); /* unused input argument */

    array_ptr = mexGetVariable("base", "handleCAN");
    if (array_ptr == NULL ){
	    mexPrintf("No se encontro la variable handleCAN al terminar la ejecucion\n");
    }
    else
    {
       
        handleTmp=(int*)(mxGetData(array_ptr));
        hndCAN=*handleTmp;
         mexPrintf("handleCAN = %d\n", hndCAN);
        if (hndCAN > 0) {
            statCAN=canusb_Close(hndCAN);
            if (statCAN <= 0) {
                //canGetErrorText(statCAN, msg, sizeof(msg));
                //mexPrintf("canClose failed (%s)\n", msg);
                printf("canClose failed (%s)\n", msg);
            } else 
            {
                printf("Can Close ok!\n");//mexPrintf("Can Close ok!\n");
            }
        } 
        else {
            printf("Can Close ok!\n");
        }
    }

    /* Destroy array */
    mxDestroyArray(array_ptr);
}

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif

