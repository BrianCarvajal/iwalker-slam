#include "mex.h"
#include "class_handle.hpp"

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

// The class that we are interfacing to
class rplidarmex
{
private:
    RPlidarDriver * drv;
    static const int DATA_MAX_LENGTH = 400;
    rplidar_response_measurement_node_t nodes[DATA_MAX_LENGTH*2];
    
public:
    rplidarmex()
    {
        drv = NULL;
    }
    
    ~rplidarmex()
    {
        disconnect();
        mexPrintf( "RPLIDAR: desconectado con éxito.\n");
    }
    
    bool connect(int COMnumber)
    {
        if (drv && drv->isConnected())
        {
            mexPrintf("RPLIDAR: already connected!\n");
            return true;
        }
        
        mexPrintf("RPLIDAR: inicializando driver RPLIDAR en COM%d...\n", COMnumber);
        mexPrintf("Connecting to COM%d\n", COMnumber);
        
        char portString[20];
        u_result op_result;
        rplidar_response_device_health_t healthinfo;
        rplidar_response_device_info_t devinfo;
        
        sprintf(portString,"\\\\.\\COM%d",COMnumber);
        
        this->drv = RPlidarDriver::CreateDriver(RPlidarDriver::DRIVER_TYPE_SERIALPORT);
        if (!this->drv) {
            mexPrintf("RPLIDAR: Error: No se ha podido crear el driver\n");
            return false;
        }
        mexPrintf("RPLIDAR: driver creado\n");
        op_result = this->drv->connect(portString, 115200);
        if (IS_FAIL(op_result)) {
            mexPrintf( "RPLIDAR: Error, no se puede conectar al puerto serie %s.\n", portString);
            return false;
        }
        mexPrintf( "RPLIDAR: conectado al puerto serie %s.\n", portString);
        
        op_result = drv->getDeviceInfo(devinfo);
        if (IS_FAIL(op_result)) {
            mexPrintf( "RPLIDAR: Error[%d], no se puede leer del dispositivo\n", op_result);
            return false;
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
        return true;
    }
    
    bool disconnect()
    {
        if (drv) {
            drv->disconnect();
            RPlidarDriver::DisposeDriver(drv);
            drv = NULL;
        }
        return true;
    }
    
    void getScan(double *freqOutput, 
                 double *countOutput, 
                 double *rangeOutput, 
                 double *angleOutput,
                 double *qualityOutput)
    {
       u_result op_return;
       size_t count = 0;
       float freq = 0;
       
       if (drv) {
           count = _countof(nodes);
           //mexPrintf("	%d datos disponibles\n", (int)count);
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
                   qualityOutput[i] = nodes[i].sync_quality >> RPLIDAR_RESP_MEASUREMENT_QUALITY_SHIFT;
               }
           }
       }
       
       // Ponemos a 0 los valores no leidos
        for (int i = (int)count; i < DATA_MAX_LENGTH; ++i) {
            angleOutput[i] = 0;
            rangeOutput[i] = 0;
            qualityOutput[i] = 0;
        }
       
       *freqOutput = freq;
       *countOutput = count;       
    }
    
    double OutputSize()
    {
        return (double)DATA_MAX_LENGTH;
    }
    

};

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // Get the command string
    char cmd[64];
    if (nrhs < 1 || mxGetString(prhs[0], cmd, sizeof(cmd)))
        mexErrMsgTxt("First input should be a command string less than 64 characters long.");
    
    
    // New
    if (!strcmp("new", cmd)) {
        // Check parameters
        if (nlhs != 1)
            mexErrMsgTxt("New: One output expected.");
        // Return a handle to a new C++ instance
        plhs[0] = convertPtr2Mat<rplidarmex>(new rplidarmex);
        return;
    }
    
    // Check there is a second input, which should be the class instance handle
    if (nrhs < 2)
        mexErrMsgTxt("Second input should be a class instance handle.");
    
    // Delete
    if (!strcmp("delete", cmd)) {
        // Destroy the C++ object
        destroyObject<rplidarmex>(prhs[1]);
        // Warn if other commands were ignored
        if (nlhs != 0 || nrhs != 2)
            mexWarnMsgTxt("Delete: Unexpected arguments ignored.");
        return;
    }
    
    // Get the class instance pointer from the second input
    rplidarmex *rpl = convertMat2Ptr<rplidarmex>(prhs[1]);
    
    
    
    // Call the various class methods
    
    //Connect
    if (!strcmp("connect", cmd))
    {
        // Check parameters
        if (nlhs > 1 || nrhs != 3)
            mexErrMsgTxt("Connect: Unexpected arguments.");
        
        int port = (int)mxGetScalar(prhs[2]);
        plhs[0]=  mxCreateLogicalScalar(rpl->connect(port));
        return;
    }
    
    //Disonnect
    if (!strcmp("disconnect", cmd))
    {
        // Check parameters
        if (nlhs > 1 || nrhs != 2)
            mexErrMsgTxt("Connect: Unexpected arguments.");
        
        plhs[0]=  mxCreateLogicalScalar(rpl->disconnect());
        return;
    }
    
    
    // getScan
    if (!strcmp("getScan", cmd)) 
    {
        // Check parameters
        if (nlhs != 5 || nrhs != 2)
            mexErrMsgTxt("getScan: Unexpected arguments.");
        
        // Call the method

        // Allocate output arrays
        plhs[2] = mxCreateDoubleMatrix(1,rpl->OutputSize(),mxREAL);
        plhs[3] = mxCreateDoubleMatrix(1,rpl->OutputSize(),mxREAL);
        plhs[4] = mxCreateDoubleMatrix(1,rpl->OutputSize(),mxREAL);
        
        double *outRange = mxGetPr(plhs[2]);
        double *outAngle = mxGetPr(plhs[3]);
        double *outQuality = mxGetPr(plhs[4]);
        double outFreq;
        double outCount;
        
        rpl->getScan(&outFreq, &outCount, outRange, outAngle, outQuality);

        plhs[0] = mxCreateDoubleScalar(outFreq);
        plhs[1] = mxCreateDoubleScalar(outCount);
        
        return;
    }
    
    // Got here, so command not recognized
    mexErrMsgTxt("Command not recognized.");
}
