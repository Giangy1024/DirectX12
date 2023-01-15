// 64 bit MATLAB requires a C-Compiler
// Macintosh OS X comes with a C-Compiler
// Use the .h file to define the interface
// loadlibrary calls in the Photoshop .m files must use the psmatlab.h file


#ifdef EXPORT_FCNS
#ifdef _WIN32
#define EXPORTED_FUNCTION extern "C" 
#else
#define EXPORTED_FUNCTION extern "C" __attribute__((visibility("default"))) 
#endif
#else
#ifdef _WIN32
#define EXPORTED_FUNCTION __declspec(dllimport)
#else
#define EXPORTED_FUNCTION
#endif
#endif

///////////////////////////////////////////////////////////////////////////////
// Execute JavaScript in Photoshop
///////////////////////////////////////////////////////////////////////////////
EXPORTED_FUNCTION char * psjavascript( char * scripttext );


///////////////////////////////////////////////////////////////////////////////
// Execute JavaScript UNICODE in Photoshop
///////////////////////////////////////////////////////////////////////////////
EXPORTED_FUNCTION unsigned int psjavascriptu( unsigned short * scripttext );


///////////////////////////////////////////////////////////////////////////////
// Get the result of the last script in UNICODE
///////////////////////////////////////////////////////////////////////////////
EXPORTED_FUNCTION void psjavascriptgetresult( unsigned short * result );


///////////////////////////////////////////////////////////////////////////////
// Launch/Connect Photoshop
///////////////////////////////////////////////////////////////////////////////
EXPORTED_FUNCTION void pslaunch( void );


///////////////////////////////////////////////////////////////////////////////
// Quit Photoshop
///////////////////////////////////////////////////////////////////////////////
EXPORTED_FUNCTION void psquit( void );

