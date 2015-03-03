#include "mex.h"
#include "class_handle.hpp"

#include "simstruc.h"
#include <fcntl.h>
#include <stdio.h>
#include "windows.h"
#include <tchar.h>

// The class that we are interfacing to
class urg
{
public:
    urg()
    {
        verbose = true;
    }
    
    ~urg()
    {
        disconnect();
    }
    
    bool connect(int COMnumber)
    {
        char portString[20];
        if (verbose)
            mexPrintf("URG: inicializando URG en COM%d...\n", COMnumber);
        
        sprintf(portString,"\\\\.\\COM%d",COMnumber);
        
        hCom = CreateFile(
                portString,
                GENERIC_READ | GENERIC_WRITE,
                0 ,
                NULL,
                OPEN_EXISTING,
                0,
                NULL);
        
        if (hCom == INVALID_HANDLE_VALUE)
        {
            if (verbose) mexPrintf("URG: Error opening Port\n");
            return false;
        }
        
        ZeroMemory(&dcb, sizeof(dcb));
        dcb.DCBlength = sizeof(DCB);
        if ( GetCommState(hCom, &dcb) )
        {
            // Set as needed
            dcb.BaudRate = CBR_115200;
            dcb.ByteSize = 8;
            dcb.Parity = NOPARITY;
            dcb.StopBits = ONESTOPBIT;
            if (verbose) mexPrintf("URG: Opening Port...");
            SetCommState(hCom, &dcb);
            if (verbose) mexPrintf(" Ok!\n");
            startSingleScan();
            return true;
        }
        else {
            if (verbose) mexPrintf("URG: Error opening Port\n");
            return false;
        }
    }
    
    bool disconnect()
    {
        CloseHandle(hCom);
        return true;
    }
    
    void getScan(double *rangeOutput)
    {
        int act;
        unsigned char car;
        unsigned char buf[2000];
        unsigned char aux[2732];
        int res[682];
        act = 0;
        while((readURG(&car, sizeof(car)))==1)
        {
            buf[act] = car;
            act++;
            if ((act>1) && ((buf[act-1] == '\r') || (buf[act-1] == '\n')) &&
                    ((buf[act-2] == '\r') || (buf[act-2] == '\n')))
            {
                if (act>1000)
                {
                    buf[act] = '\0';
                    
                    memset(res, 0, sizeof(res));
                    urg_decode(buf,res);
                    
                    memset(aux, 0, sizeof(aux));
                    int j = 0;
                    for (int i = 0; i < 682; ++i) {
                        
                        biconvert.val = res[i];
                        
                        aux[j++] = biconvert.bytes[0];
                        aux[j++] = biconvert.bytes[1];
                        aux[j++] = biconvert.bytes[2];
                        aux[j++] = biconvert.bytes[3];
                    }
                    
                    biconvert.val = 0;
                    
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
        startSingleScan();
        bool negative = false;
        for (int i = 0; i < 682; ++i)
        {
            if (res[i] < 0)
            {
                negative = true;
                break;
            }
            else
            {
                rangeOutput[i] = res[i];
            }
        }
        // Si hay algun negativo son datos invaldiso: devolvemos todo 0
        if (negative)
        {
            for (int i = 0; i < 682; ++i) rangeOutput[i] = 0;
        }
    }
    
private:
    HANDLE hCom;
    DCB dcb;
    bool verbose;
    
    union {
        unsigned char bytes[4];
        unsigned int val;
    } biconvert;
    
    
    int startSingleScan()
    {
        DWORD dwBytesWritten = 0;
        int res = 0;
        char msg[256];
        sprintf(msg,"MS0044072500001\n");
        
        if(!WriteFile(hCom, msg, strlen(msg), &dwBytesWritten, NULL))
        {
            if (verbose) mexPrintf( "URG: Error writing text to %s\n", msg);
        }
        else
        {
            if (verbose) mexPrintf( "URG: %d bytes written\n", dwBytesWritten);
        }
        return dwBytesWritten;
    }
    
    int readURG(unsigned char *buf, int size)
    {
        unsigned long aux = size;
        if (ReadFile(hCom, buf, size, &aux, NULL) == 0)
        {
            if (verbose) printf("URG: read failed\n");
            return 0;
        }
        else
        {
            //if (verbose) printf("URG: read OK\n");
        }
        if (aux > 0)
        {
            return (int)aux;
        }
        return (int)0-aux;
    }
    
    short char_decode(const unsigned char data[], int data_byte)
    {
        short value = 0;
        int i;
        
        for (i = 0; i < data_byte; ++i) {
            value <<= 6;
            value &= ~0x3f;
            value |= data[i] - 0x30;
        }
        return value;
    }
    
    void urg_decode(unsigned char *buf, int *res)
    {
        int k;
        int i,idx,j=0;
        unsigned char data[2];
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
        plhs[0] = convertPtr2Mat<urg>(new urg);
        return;
    }
    
    // Check there is a second input, which should be the class instance handle
    if (nrhs < 2)
        mexErrMsgTxt("Second input should be a class instance handle.");
    
    // Delete
    if (!strcmp("delete", cmd)) {
        // Destroy the C++ object
        destroyObject<urg>(prhs[1]);
        // Warn if other commands were ignored
        if (nlhs != 0 || nrhs != 2)
            mexWarnMsgTxt("Delete: Unexpected arguments ignored.");
        return;
    }
    
    // Get the class instance pointer from the second input
    urg *lid = convertMat2Ptr<urg>(prhs[1]);
    
    // Call the various class methods
    //Connect
    if (!strcmp("connect", cmd))
    {
        // Check parameters
        if (nlhs != 1 || nrhs != 3)
            mexErrMsgTxt("Connect: Unexpected arguments.");
        
        int port = (int)mxGetScalar(prhs[2]);
        plhs[0]=  mxCreateLogicalScalar(lid->connect(port));
        return;
    }
    
    //Disconnect
    if (!strcmp("disconnect", cmd))
    {
        // Check parameters
        if (nlhs != 1 || nrhs != 2)
            mexErrMsgTxt("Disconnect: Unexpected arguments.");
        
        plhs[0]=  mxCreateLogicalScalar(lid->disconnect());
        return;
    }
    
    // getScan
    if (!strcmp("getScan", cmd))
    {
        // Check parameters
        if (nlhs != 1 || nrhs != 2)
            mexErrMsgTxt("Test: Unexpected arguments.");
        
        // Allocate output arrays
        plhs[0] = mxCreateDoubleMatrix(1,682,mxREAL);
        double *outRange = mxGetPr(plhs[0]);
        lid->getScan(outRange);
        return;
    }
    
    // Got here, so command not recognized
    mexErrMsgTxt("Command not recognized.");
}
