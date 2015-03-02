#include "mex.h"
#include "class_handle.hpp"

// The class that we are interfacing to
class dummy
{
public:
    double train(double d) 
    {
        mexPrintf("Hello %f!\n", d); 
        return d*d;
    };
    void test() 
    {
         mexPrintf("Hello test!\n"); 
    };
private:
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
        plhs[0] = convertPtr2Mat<dummy>(new dummy);
        return;
    }
    
    // Check there is a second input, which should be the class instance handle
    if (nrhs < 2)
		mexErrMsgTxt("Second input should be a class instance handle.");
    
    // Delete
    if (!strcmp("delete", cmd)) {
        // Destroy the C++ object
        destroyObject<dummy>(prhs[1]);
        // Warn if other commands were ignored
        if (nlhs != 0 || nrhs != 2)
            mexWarnMsgTxt("Delete: Unexpected arguments ignored.");
        return;
    }
    
    // Get the class instance pointer from the second input
    dummy *dummy_instance = convertMat2Ptr<dummy>(prhs[1]);
    
    // Call the various class methods
    // Train    
    if (!strcmp("train", cmd)) {
        // Check parameters
        if (nlhs < 0 || nrhs < 3)
            mexErrMsgTxt("Train: Unexpected arguments.");
        
        double input = mxGetScalar(prhs[2]);
        double output;
        // Call the method
        output = dummy_instance->train(input);
        
        plhs[0] = mxCreateDoubleScalar(output);
        return;
    }
    // Test    
    if (!strcmp("test", cmd)) {
        // Check parameters
        if (nlhs < 0 || nrhs < 2)
            mexErrMsgTxt("Test: Unexpected arguments.");
        // Call the method
        dummy_instance->test();
        return;
    }
    
    // Got here, so command not recognized
    mexErrMsgTxt("Command not recognized.");
}
