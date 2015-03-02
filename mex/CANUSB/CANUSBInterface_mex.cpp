#include "mex.h"
#include "class_handle.hpp"

#include "simstruc.h"
#include <windows.h>
#include "lawicel_can.h"

#define U(element) (*uPtrs[element])  /* Pointer to Input Port0 */

// The class that we are interfacing to
class CANUSB
{
private:
    CANHANDLE hndCAN;
    
public:
    
    CANUSB()
    {
        hndCAN = 0;
        connect();
    }
           
    ~CANUSB()
    {
        disconnect();
    }
    
    bool connect() 
    {
        int err;
        if (hndCAN != 0)
        {
            mexPrintf("CANUSB already connected!\n");
            return false;
        }
        
        err = canusb_Status(hndCAN);
        mexPrintf("CANUSB Status: (%d)\n", err);
        
        hndCAN = canusb_Open(0,"1000",CANUSB_ACCEPTANCE_CODE_ALL,
                                      CANUSB_ACCEPTANCE_MASK_ALL,
                                      CANUSB_FLAG_QUEUE_REPLACE);
        
        if (hndCAN == 0) 
        {
            mexPrintf("CANUSB OpenChannel failed\n");
            return false;
        }
        else
        {
            mexPrintf("CANUSB Open Channel0 OK [%d]!\n", hndCAN);
            return true;
        }      
    }
    
    bool disconnect()
    {
        int statCAN;        
        if (hndCAN == 0) 
        {
            mexPrintf("CANUSB already closed!\n");
            return true;
        }
        
        statCAN = canusb_Close(hndCAN);
        if (statCAN <= 0) {
            mexPrintf("CANUSB close failed \n");
            return false;
        } 
        else
        {
            mexPrintf("CANUSB close ok!\n");
            return true;
        }
    }
    
    bool read(_u32 id, _u8 *data)
    {
        for (int i = 0; i < 8; ++i) data[i] = 0;
        
        if (hndCAN == 0) 
        {
            mexPrintf("CANUSB is not opened, can not read!\n");
            return false;
        }
        
        int statCAN;
        bool readed = false;
        CANMsg message;
        message.id = id;
        message.timestamp = 0;
        message.flags = 0;
        message.len = 8;
        
        for (int i = 0; i < 8; ++i) message.data[i]=0;
        //mexPrintf("CANUSB: reading frame %d!\n", message.id);
        do 
        {
            statCAN=canusb_ReadFirst(hndCAN,id,0,&message);
            if (statCAN==ERROR_CANUSB_OK)
            {
                for (int i = 0; i < 8; ++i) data[i] = message.data[i];
                readed = true;
            }           
        } while (statCAN==ERROR_CANUSB_OK);

        return readed;        
    }
    
    bool write(_u32 id, _u8 dlc, _u8 *data)
    {
        if (hndCAN == 0) 
        {
            mexPrintf("CANUSB is not opened, can not write!\n");
            return false;
        }
        
        CANMsg message;
        int statCAN;
        
        message.id=id;
        message.timestamp=0;
        message.flags=0;
        message.len=dlc;
        
        if (dlc > 0)
        {
            for (int i = 0; i < dlc; ++i) message.data[i] = data[i];
            for (int i = dlc; i < 8; ++i) message.data[i] = 0;
            
            statCAN = canusb_Write(hndCAN, &message);
        }
        
        if (statCAN <= 0) 
        {            
            return false;
        }
        else 
        {
            return true;
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
    if (!strcmp("new", cmd)) 
    {
        // Check parameters
        if (nlhs != 1)
            mexErrMsgTxt("New: One output expected.");
        // Return a handle to a new C++ instance
        plhs[0] = convertPtr2Mat<CANUSB>(new CANUSB);
        return;
    }
    
    // Check there is a second input, which should be the class instance handle
    if (nrhs < 2)
		mexErrMsgTxt("Second input should be a class instance handle.");
    
    // Delete
    if (!strcmp("delete", cmd)) 
    {
        // Destroy the C++ object
        destroyObject<CANUSB>(prhs[1]);
        // Warn if other commands were ignored
        if (nlhs != 0 || nrhs != 2)
            mexWarnMsgTxt("Delete: Unexpected arguments ignored.");
        return;
    }
    
    // Get the class instance pointer from the second input
    CANUSB *canusb = convertMat2Ptr<CANUSB>(prhs[1]);
    
    // Call the various class methods
    if (!strcmp("test", cmd))
    {
        // Check parameters
        if (nlhs < 1 || nrhs < 3)
            mexErrMsgTxt("Test: Unexpected arguments.");
        
        
        if (!mxIsUint8(prhs[2]))
        {
            mexErrMsgTxt("Test: 3rd argument must be a uint8 array");
        }
        _u8 *input = (_u8*)mxGetData(prhs[2]);
        
        
        // Allocate output array
        plhs[0] = mxCreateNumericMatrix(1, 8, mxUINT8_CLASS, mxREAL);       
        _u8 *output = (_u8*)mxGetData(plhs[0]);
        
        for (int i = 0; i < 8; ++i) output[i] = input[i]+1;
        return; 
    }
    
    if (!strcmp("read", cmd))
    {
        // Check parameters
        if (nlhs < 1 || nrhs < 3)
            mexErrMsgTxt("Read: Unexpected arguments.");
        
        if (!mxIsUint32(prhs[2]))
            mexErrMsgTxt("Read: 3rd argument (id) must be a uint32");
        
        _u32 id = *(_u32*)mxGetData(prhs[2]);
        
        // Allocate output array
        plhs[0] = mxCreateNumericMatrix(1, 8, mxUINT8_CLASS, mxREAL);       
        _u8 *output = (_u8*)mxGetData(plhs[0]);
        
        canusb->read(id, output);
        return;
    }
    
    if (!strcmp("write", cmd))
    {
        // Check parameters
        if (nrhs < 5)
            mexErrMsgTxt("Write: Unexpected arguments.");
        
        if (!mxIsUint32(prhs[2]))
            mexErrMsgTxt("Read: 3rd argument (id) must be a uint32");
        
        if (!mxIsUint8(prhs[3]))
            mexErrMsgTxt("Read: 4th argument (dlc) must be a uint8");
        
         if (!mxIsUint8(prhs[4]))
            mexErrMsgTxt("Read: 5th argument (message) must be a uint8 array");
        
        _u32 id = *(_u32*)mxGetData(prhs[2]);
        _u8 dlc = *(_u8*)mxGetData(prhs[3]);
        _u8 *input = (_u8*)mxGetData(prhs[4]);
        
        canusb->write(id, dlc, input);
        return;
        
    }
    
    // Got here, so command not recognized
    mexErrMsgTxt("Command not recognized.");
}
