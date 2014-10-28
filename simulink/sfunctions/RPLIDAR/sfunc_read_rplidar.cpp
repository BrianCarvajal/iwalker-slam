
#define S_FUNCTION_NAME  sfunc_read_rplidar
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"
#include <fcntl.h>
#include <stdio.h>
#include "windows.h"
#include <tchar.h>

#include "rplidar.h" //RPLIDAR standard sdk, all-in-one header

#ifndef _countof
#define _countof(_Array) (int)(sizeof(_Array) / sizeof(_Array[0]))
#endif

using namespace rp::standalone::rplidar;

RPlidarDriver * drv;
int verbose = 0;
const int DATA_MAX_LENGTH = 360 * 2;
rplidar_response_measurement_node_t nodes[DATA_MAX_LENGTH*2];


void init_rplidar(int COMnumber) {
    char portString[20];
    u_result op_result;
    rplidar_response_device_health_t healthinfo;
    rplidar_response_device_info_t devinfo;
    
    mexPrintf("RPLIDAR: inicializando driver RPLIDAR...\n");
    sprintf(portString,"\\\\.\\COM%d",COMnumber);
    /*global RPlidarDriver*/ drv = RPlidarDriver::CreateDriver(RPlidarDriver::DRIVER_TYPE_SERIALPORT);
    if (!drv) {
        mexPrintf("RPLIDAR: Error: No se ha podido crear el driver\n");
        return;
    }
    mexPrintf("RPLIDAR: driver creado\n");
    
    op_result = drv->connect(portString, 115200);
    if (IS_FAIL(op_result)) {
        mexPrintf( "RPLIDAR: Error, no se puede conectar al puerto serie %s.\n", portString);
        return;
    }
    mexPrintf( "RPLIDAR: conectado al puerto serie %s.\n", portString);
    
    op_result = drv->getDeviceInfo(devinfo);
    if (IS_FAIL(op_result)) {
        mexPrintf( "RPLIDAR: Error[%d], no se puede leer del dispositivo\n", op_result);
        return;
    }
    
    mexPrintf("RPLIDAR S/N: ");
    for (int pos = 0; pos < 16 ;++pos) {
        mexPrintf("%02X", devinfo.serialnum[pos]);
    }
    mexPrintf("\n"
            "Firmware Ver: %d.%02d\n"
            "Hardware Rev: %d\n"
            , devinfo.firmware_version>>8
            , devinfo.firmware_version & 0xFF
            , (int)devinfo.hardware_version);
    
    drv->startScan();
    
    op_result = drv->getHealth(healthinfo);
    if (IS_FAIL(op_result)) {
        mexPrintf( "RPLIDAR: Error[%d], no se puede leer del dispositivo\n", op_result);
    }
    mexPrintf("RPLIDAR health status : ");
    switch (healthinfo.status) {
        case RPLIDAR_STATUS_OK:
            mexPrintf("OK.");
            break;
        case RPLIDAR_STATUS_WARNING:
            mexPrintf("Warning.");
            break;
        case RPLIDAR_STATUS_ERROR:
            mexPrintf("Error.");
            break;
    }
    mexPrintf(" (errorcode: %d)\n", healthinfo.error_code);
    
    drv->startScan();
//      if (drv) {
//          mexPrintf("RPLIDAR: driver creado\n");
//          u_result op_result = drv->connect(portString, 115200);
//          if (IS_OK(op_result)) {
//              mexPrintf( "RPLIDAR: conectado al puerto serie %s.\n", portString);
//              drv->startScan();
//          }
//          else if (IS_FAIL(op_result)) {
//              mexPrintf( "RPLIDAR: Error, no se puede conectar al puerto serie %s.\n", portString);
//          }
//      }
//      else {
//          mexPrintf("RPLIDAR: Error: No se ha podido crear el driver\n");
//      }
}

void close_rplidar() {
    if (drv) {
        drv->disconnect();
        RPlidarDriver::DisposeDriver(drv);
    }
    mexPrintf( "RPLIDAR: desconectado con éxito.\n");
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
    if (!ssSetNumOutputPorts(S, 4)) return;
    // range data
    ssSetOutputPortWidth(S, 0, DATA_MAX_LENGTH);
    ssSetOutputPortDataType(S, 0, SS_DOUBLE);
    // angle data
    ssSetOutputPortWidth(S, 1, DATA_MAX_LENGTH);
    ssSetOutputPortDataType(S, 1, SS_DOUBLE);
    // length
    ssSetOutputPortWidth(S, 2, 1);
    ssSetOutputPortDataType(S, 1, SS_DOUBLE);
    // frequency
    ssSetOutputPortWidth(S, 3, 1);
    ssSetOutputPortDataType(S, 1, SS_DOUBLE);
    
    ssSetNumSampleTimes(S, 1);
    ssSetNumRWork(S, 0);
    ssSetNumIWork(S, 0);
    ssSetNumPWork(S, 0);
    ssSetNumModes(S, 0);
    ssSetNumNonsampledZCs(S, 0);
    
    ssSetOptions(S, 0);
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
        mexPrintf("RPLIDAR: no se encontró la variable SampleTime. Se usará 0.5\n");
        sampleTime = 0.5;
    }
    else
    {
        sampleTime=*((double*)(mxGetData(array_ptr)));
        mexPrintf("RPLIDAR: SampleTime con valor = %f\n", sampleTime);
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
    int COM;
    // Leemos el COM definido por el usuario
    array_ptr = mexGetVariable("caller", "COM");
    if (array_ptr == NULL ){
        mexPrintf("RPLIDAR: no se encontro la variable COM. Se intentara usar COM7\n");
        COM = 7;
    }
    else
    {
        tmp=(double*)(mxGetData(array_ptr));
        COM=(unsigned char)(*tmp);
        mexPrintf("RPLIDAR: COM%d\n",COM);
    }
    
    // Leemos el flag Verbose
    array_ptr = mexGetVariable("caller", "Verbose");
    if (array_ptr == NULL ){
        verbose = 1;
    }
    else
    {
        tmp=(double*)(mxGetData(array_ptr));
        verbose=(int)(*tmp);
        if (verbose) {
            mexPrintf("RPLIDAR: verbose ON\n");
        } else {
            mexPrintf("RPLIDAR: verbose OFF\n");
        }
    }
    /* Destroy array */
    mxDestroyArray(array_ptr);
    //memset(buf, 0, sizeof(buf));
    //memset(res, 0, sizeof(res));
    init_rplidar(COM);
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
    close_rplidar();
}


static void mdlOutputs(SimStruct *S, int_T tid) {
    real_T *rangeOutput = (real_T *)ssGetOutputPortSignal(S,0);
    real_T *angleOutput = (real_T *)ssGetOutputPortSignal(S,1);
    real_T *countOutput = (real_T *)ssGetOutputPortSignal(S,2);
    real_T *freqOutput = (real_T *)ssGetOutputPortSignal(S,3);
    u_result op_return;
    size_t count = 0;
    float freq = 0;
    
    if (drv) {
        count = _countof(nodes);
        op_return = drv->grabScanData(nodes, count, 0);
        if (IS_OK(op_return) || op_return == RESULT_OPERATION_TIMEOUT) {
            //Ordenamos los datos por angulo
            drv->ascendScanData(nodes, count);
            drv->getFrequency(nodes, count, freq);
            // Copiamos los datos leidos
            int max_i = (int)count > DATA_MAX_LENGTH ? DATA_MAX_LENGTH : (int)count;
            for (int i = 0; i < max_i; ++i) {
                angleOutput[i] = (nodes[i].angle_q6_checkbit >> RPLIDAR_RESP_MEASUREMENT_ANGLE_SHIFT)/64.0f;
                rangeOutput[i] = nodes[i].distance_q2/4.0f;
            }
        }
    }
    // Ponemos a 0 los valores no leidos
    for (int i = (int)count; i < DATA_MAX_LENGTH; ++i) {
        angleOutput[i] = 0;
        rangeOutput[i] = 0;
    }
    countOutput[0] = (double)count;
    freqOutput[0] = freq;
}



/*=============================*
 * Required S-function trailer *
 *=============================*/

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif
