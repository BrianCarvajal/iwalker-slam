#line 1 "C:/Archivos de programa/KVASER/Canlib/INC/canlib.h"

#line 16 "C:/Archivos de programa/KVASER/Canlib/INC/canlib.h"



#line 1 "C:\MATLAB7\sys\lcc\include\stdlib.h"

#line 3 "C:\MATLAB7\sys\lcc\include\stdlib.h"



#line 1 "C:\MATLAB7\sys\lcc\include\stddef.h"



typedef unsigned int size_t;


typedef int ptrdiff_t;


#line 7 "C:\MATLAB7\sys\lcc\include\stdlib.h"
#line 1 "C:\MATLAB7\sys\lcc\include\_syslist.h"


#line 4 "C:\MATLAB7\sys\lcc\include\_syslist.h"




#line 8 "C:\MATLAB7\sys\lcc\include\stdlib.h"





typedef struct {
  int quot;
  int rem;
} div_t;

typedef struct {
  long quot;
  long rem;
} ldiv_t;
















void	abort(void);
int	abs(int);
int	atexit(void (*_func)(void));
double	atof(char *_nptr);
int	atoi(char *_nptr);

char    *itoa(int,char *,int);
char	*ltoa(long,char *,int);
long	atol(char *_nptr);
void *	bsearch(const void * _key,void * _base, size_t _nmemb, size_t _size,
		       int (*_compar)(void *, void *));
void *	calloc(size_t _nmemb, size_t _size);
div_t	div(int _numer, int _denom);
void	exit(int _status);
void	free(void *);
char	*_fullpath( char *absPath, const char *relPath, size_t maxLength );
char *  getenv(char *_string);
long	labs(long);
ldiv_t	ldiv(long _numer, long _denom);
void *	malloc(size_t _size);
unsigned long _lrotl(unsigned long,int);
unsigned long _rotl(unsigned int,int);
void	qsort(void * _base, size_t _nmemb, size_t _size, int(*_compar)(const void *, const void *));
int	rand(void);
void *	realloc(void * _r, size_t _size);
void	srand(unsigned _seed);
double	strtod(const char *_n, char **_endvoid);
long	strtol(const char *_n, char **_endvoid, int _base);
unsigned long strtoul(const char *_n, char **_end, int _base);
int	system(char *_string);
int	putenv(char *_string);
int	setenv(char *_string, char *_value, int _overwrite);
char *	_gcvt(double,int,char *);
char *	_fcvt(double,int,int *,int *);
char *	_ecvt(double,int,int *,int *);
int     mbstowcs(unsigned short *,char *,int);
int	mblen(char *,int);
int	mbstrlen(char *s);
extern int _sleep(unsigned long);




extern int *(_imp___fmode_dll);
extern char **_environ;
extern unsigned int _osver;
extern unsigned int *(_imp___osver);

extern unsigned int _winmajor;
extern unsigned int *(_imp___winmajor);

extern unsigned int _winminor;
extern unsigned int *(_imp___winminor);

extern unsigned int _winver;
extern unsigned int *(_imp___winver);


#line 20 "C:/Archivos de programa/KVASER/Canlib/INC/canlib.h"
#line 1 "C:\MATLAB7\sys\lcc\include\windows.h"



#line 1 "C:\MATLAB7\sys\lcc\include\win.h"
#line 1 "C:\MATLAB7\sys\lcc\include\limits.h"



































#line 37 "C:\MATLAB7\sys\lcc\include\limits.h"





#line 2 "C:\MATLAB7\sys\lcc\include\win.h"
#line 1 "C:\MATLAB7\sys\lcc\include\stdarg.h"




typedef char *	va_list;







#line 3 "C:\MATLAB7\sys\lcc\include\win.h"





#pragma pack(push,1)


typedef int BOOL;








typedef int WINBOOL;
typedef unsigned short ATOM;
typedef unsigned char BOOLEAN;
typedef unsigned char BYTE;
typedef unsigned long CALTYPE;
typedef unsigned long CALID;
typedef char CCHAR;
typedef char CHAR;
typedef unsigned long COLORREF;

typedef unsigned long DWORD;
typedef double DWORDLONG,*PDWORDLONG;
typedef float FLOAT;
typedef void *HANDLE;
typedef long SCODE,*PSCODE;
typedef double DOUBLE;
typedef HANDLE GLOBALHANDLE;
typedef HANDLE HSTMT;
typedef HANDLE HDBC;
typedef HANDLE HENV;
typedef HANDLE LOCALHANDLE;
typedef HANDLE HTASK;
typedef HANDLE HACCEL;
typedef HANDLE HBITMAP;
typedef HANDLE HBRUSH;
typedef HANDLE HCOLORSPACE;
typedef HANDLE HCONV;
typedef HANDLE HCONVLIST;
typedef HANDLE HCURSOR;
typedef HANDLE HDC;
typedef HANDLE HDDEDATA;
typedef HANDLE HDESK;
typedef HANDLE HDWP;
typedef HANDLE HENHMETAFILE;
typedef int HFILE;
typedef HANDLE HFONT;
typedef HANDLE HGDIOBJ;
typedef HANDLE HGLOBAL;
typedef HANDLE HGLRC;
typedef HANDLE HHOOK;
typedef HANDLE HICON;
typedef HANDLE HIMAGELIST;
typedef HANDLE HINSTANCE;
typedef HANDLE HKEY,*PHKEY;
typedef HANDLE HKL;
typedef HANDLE HLOCAL;
typedef HANDLE HMENU;
typedef HANDLE HMETAFILE;
typedef HANDLE HMODULE;
typedef HANDLE HPALETTE;
typedef HANDLE HPEN;
typedef long HRESULT;
typedef HANDLE HRGN;
typedef HANDLE HRSRC;
typedef HANDLE HSZ;
typedef HANDLE HWINSTA;
typedef HANDLE HWND;
typedef int INT;
typedef unsigned short LANGID;
typedef DWORD LCID;
typedef DWORD LCTYPE;
typedef long LONG;
typedef long LPARAM;
typedef BOOL *LPBOOL;
typedef BYTE *LPBYTE;
typedef const CHAR *LPCCH;
typedef CHAR *LPCH;
typedef COLORREF *LPCOLORREF;
typedef const char *LPCSTR;
typedef LPCSTR LPCOLESTR;
typedef signed char SCHAR;
typedef long int SDWORD;
typedef short int SWORD;
typedef unsigned long int UDWORD;
typedef unsigned short int UWORD;
typedef signed short RETCODE;


































































































typedef const char *LPCTSTR;
typedef char *LPTCH;
typedef char *LPTSTR;
typedef unsigned char *PTBYTE;
typedef char *PTCH;
typedef char *PTCHAR;
typedef char *PTSTR;
typedef unsigned char TBYTE;
typedef char TCHAR;
typedef BYTE BCHAR;























































































typedef const unsigned short *LPCWCH;
typedef const unsigned short *LPCWSTR;
typedef DWORD *LPDWORD;
typedef HANDLE *LPHANDLE;
typedef int *LPINT;
typedef long *LPLONG;
typedef char *LPSTR;
typedef long LRESULT;
typedef void *LPVOID;
typedef const void *LPCVOID;
typedef unsigned short *LPWCH;
typedef unsigned short *LPWORD;
typedef unsigned short *LPWSTR;
typedef unsigned short *PWSTR;
typedef unsigned short *NWPSTR;
typedef BOOL *PWINBOOL;
typedef BYTE *PBOOLEAN;
typedef BYTE *PBYTE;
typedef const CHAR *PCCH;
typedef CHAR *PCH;
typedef CHAR *PCHAR;
typedef const char *PCSTR;
typedef const unsigned short *PCWCH;
typedef const unsigned short *PCWSTR;
typedef DWORD *PDWORD;
typedef float *PFLOAT;
typedef HANDLE *PHANDLE;
typedef int *PINT;
typedef long *PLONG;
typedef short *PSHORT;
typedef char *PSTR;
typedef char *PSZ;
typedef unsigned char *PUCHAR;
typedef unsigned int *PUINT;
typedef unsigned long *PULONG;
typedef unsigned short *PUSHORT;
typedef void *PVOID;
typedef unsigned short *PWCH;
typedef unsigned short *PWCHAR;
typedef unsigned short *PWORD;
typedef HANDLE SC_HANDLE;
typedef LPVOID SC_LOCK;
typedef SC_HANDLE *LPSC_HANDLE;
typedef DWORD SERVICE_STATUS_HANDLE;
typedef short SHORT;
typedef unsigned char UCHAR;
typedef unsigned int UINT;
typedef unsigned long ULONG;
typedef unsigned short USHORT;

typedef unsigned short WCHAR;
typedef unsigned short WORD;
typedef unsigned int WPARAM;








typedef enum _ACL_INFORMATION_CLASS {
	AclRevisionInformation = 1, AclSizeInformation
} ACL_INFORMATION_CLASS;
typedef enum _SECURITY_IMPERSONATION_LEVEL {
	SecurityAnonymous, SecurityIdentification, SecurityImpersonation,
	SecurityDelegation
} SECURITY_IMPERSONATION_LEVEL;
typedef enum _SID_NAME_USE {
	SidTypeUser = 1, SidTypeGroup, SidTypeDomain, SidTypeAlias,
	SidTypeWellKnownGroup, SidTypeDeletedAccount, SidTypeInvalid,
	SidTypeUnknown
} SID_NAME_USE,*PSID_NAME_USE;
typedef enum _TOKEN_INFORMATION_CLASS {
	TokenUser = 1, TokenGroups, TokenPrivileges, TokenOwner,
	TokenPrimaryGroup, TokenDefaultDacl, TokenSource, TokenType,
	TokenImpersonationLevel, TokenStatistics
} TOKEN_INFORMATION_CLASS;
typedef enum tagTOKEN_TYPE {
	TokenPrimary = 1, TokenImpersonation
} TOKEN_TYPE;









































typedef int (_stdcall *BFFCALLBACK) (HWND,UINT,LPARAM,LPARAM);
typedef UINT (_stdcall *LPCCHOOKPROC) (HWND,UINT,WPARAM,LPARAM);
typedef UINT (_stdcall *LPCFHOOKPROC) (HWND,UINT,WPARAM,LPARAM);
typedef DWORD (_stdcall *PTHREAD_START_ROUTINE) (LPVOID);
typedef PTHREAD_START_ROUTINE LPTHREAD_START_ROUTINE;
typedef DWORD (_stdcall *EDITSTREAMCALLBACK) (DWORD,LPBYTE,LONG,LONG *);
typedef UINT (_stdcall *LPFRHOOKPROC) (HWND,UINT,WPARAM,LPARAM);
typedef UINT (_stdcall *LPOFNHOOKPROC) (HWND,UINT,WPARAM,LPARAM);
typedef UINT (_stdcall *LPPRINTHOOKPROC) (HWND,UINT,WPARAM,LPARAM);
typedef UINT (_stdcall *LPSETUPHOOKPROC) (HWND,UINT,WPARAM,LPARAM);
typedef BOOL (_stdcall *DLGPROC) (HWND,UINT,WPARAM,LPARAM);
typedef int (_stdcall *PFNPROPSHEETCALLBACK) (HWND,UINT,LPARAM);
typedef void (_stdcall *LPSERVICE_MAIN_FUNCTION) (DWORD,LPTSTR);
typedef int (_stdcall *PFNTVCOMPARE) (LPARAM,LPARAM,LPARAM);
typedef LRESULT (_stdcall *WNDPROC) (HWND,UINT,WPARAM,LPARAM);
typedef int (_stdcall *FARPROC)();
typedef int (_stdcall *PROC)();
typedef BOOL (_stdcall *WNDENUMPROC)(HWND,LPARAM);
typedef BOOL (_stdcall *ENUMRESTYPEPROC) (HANDLE,LPTSTR,LONG);
typedef BOOL (_stdcall *ENUMRESNAMEPROC) (HANDLE,LPCTSTR,LPTSTR,LONG);
typedef BOOL (_stdcall *ENUMRESLANGPROC) (HANDLE,LPCTSTR,LPCTSTR,WORD,LONG);
typedef BOOL (_stdcall *ENUMWINDOWSPROC) (HWND,LPARAM);
typedef BOOL (_stdcall *ENUMWINDOWSTATIONPROC) (LPTSTR,LPARAM);
typedef void (_stdcall *SENDASYNCPROC) (HWND,UINT,DWORD,LRESULT);
typedef void (_stdcall *TIMERPROC) (HWND,UINT,UINT,DWORD);
typedef BOOL (_stdcall *GRAYSTRINGPROC)(HDC,LPARAM,int);
typedef BOOL (_stdcall *DRAWSTATEPROC) (HDC,LPARAM,WPARAM,int,int);
typedef BOOL (_stdcall *PROPENUMPROCEX) (HWND,LPCTSTR,HANDLE,DWORD);
typedef BOOL (_stdcall *PROPENUMPROC) (HWND,LPCTSTR,HANDLE);
typedef LRESULT (_stdcall *HOOKPROC) (int,WPARAM,LPARAM);
typedef void (_stdcall *ENUMOBJECTSPROC) (LPVOID,LPARAM);
typedef void (_stdcall *LINEDDAPROC) (int,int,LPARAM);
typedef BOOL (_stdcall *ABORTPROC) (HDC,int);
typedef UINT (_stdcall *LPPAGEPAINTHOOK) (HWND,UINT,WPARAM,LPARAM);
typedef UINT (_stdcall *LPPAGESETUPHOOK) (HWND,UINT,WPARAM,LPARAM);
typedef int (_stdcall *ICMENUMPROC) (LPTSTR,LPARAM);
typedef LONG (*EDITWORDBREAKPROCEX) (char *,LONG,BYTE,INT);
typedef int (_stdcall *PFNLVCOMPARE) (LPARAM,LPARAM,LPARAM);
typedef BOOL (_stdcall *LOCALE_ENUMPROC) (LPTSTR);
typedef BOOL (_stdcall *CODEPAGE_ENUMPROC) (LPTSTR);
typedef BOOL (_stdcall *DATEFMT_ENUMPROC) (LPTSTR);
typedef BOOL (_stdcall *TIMEFMT_ENUMPROC) (LPTSTR);
typedef BOOL (_stdcall *CALINFO_ENUMPROC) (LPTSTR);
typedef BOOL (_stdcall *PHANDLER_ROUTINE) (DWORD);
typedef BOOL (_stdcall *LPHANDLER_FUNCTION) (DWORD);
typedef UINT (_stdcall *PFNGETPROFILEPATH) (LPCTSTR,LPSTR,UINT);
typedef UINT (_stdcall *PFNRECONCILEPROFILE) (LPCTSTR,LPCTSTR,DWORD);
typedef BOOL (_stdcall *PFNPROCESSPOLICIES) (HWND,LPCTSTR,LPCTSTR,LPCTSTR,DWORD);
typedef BOOL (_stdcall * NAMEENUMPROCA)(LPSTR, LPARAM);
typedef BOOL (_stdcall * NAMEENUMPROCW)(LPWSTR, LPARAM);
typedef NAMEENUMPROCA WINSTAENUMPROCA;
typedef NAMEENUMPROCA DESKTOPENUMPROCA;
typedef NAMEENUMPROCW WINSTAENUMPROCW;
typedef NAMEENUMPROCW DESKTOPENUMPROCW;


























































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































typedef struct _ABC {
	int abcA;
	UINT abcB;
	int abcC;
} ABC,*LPABC;
typedef struct _ABCFLOAT {
	FLOAT abcfA;
	FLOAT abcfB;
	FLOAT abcfC;
} ABCFLOAT,*LPABCFLOAT;
typedef struct tagACCEL {
	BYTE fVirt;
	WORD key;
	WORD cmd;
} ACCEL,*LPACCEL;
typedef struct _ACE_HEADER {
	BYTE AceType;
	BYTE AceFlags;
	WORD AceSize;
} ACE_HEADER;
typedef DWORD ACCESS_MASK;
typedef ACCESS_MASK REGSAM;
typedef struct _ACCESS_ALLOWED_ACE {
	ACE_HEADER Header;
	ACCESS_MASK Mask;
	DWORD SidStart;
} ACCESS_ALLOWED_ACE;
typedef struct _ACCESS_DENIED_ACE {
	ACE_HEADER Header;
	ACCESS_MASK Mask;
	DWORD SidStart;
} ACCESS_DENIED_ACE;
typedef struct tagACCESSTIMEOUT {
	UINT cbSize;
	DWORD dwFlags;
	DWORD iTimeOutMSec;
} ACCESSTIMEOUT;
typedef struct _ACL {
	BYTE AclRevision;
	BYTE Sbz1;
	WORD AclSize;
	WORD AceCount;
	WORD Sbz2;
} ACL,*PACL;
typedef struct _ACL_REVISION_INFORMATION {
	DWORD AclRevision;
} ACL_REVISION_INFORMATION;
typedef struct _ACL_SIZE_INFORMATION {
	DWORD AceCount;
	DWORD AclBytesInUse;
	DWORD AclBytesFree;
} ACL_SIZE_INFORMATION;
typedef struct _ACTION_HEADER {
	ULONG transport_id;
	USHORT action_code;
	USHORT reserved;
} ACTION_HEADER;
typedef struct _ADAPTER_STATUS {
	UCHAR adapter_address[6];
	UCHAR rev_major;
	UCHAR reserved0;
	UCHAR adapter_type;
	UCHAR rev_minor;
	WORD duration;
	WORD frmr_recv;
	WORD frmr_xmit;
	WORD iframe_recv_err;
	WORD xmit_aborts;
	DWORD xmit_success;
	DWORD recv_success;
	WORD iframe_xmit_err;
	WORD recv_buff_unavail;
	WORD t1_timeouts;
	WORD ti_timeouts;
	DWORD reserved1;
	WORD free_ncbs;
	WORD max_cfg_ncbs;
	WORD max_ncbs;
	WORD xmit_buf_unavail;
	WORD max_dgram_size;
	WORD pending_sess;
	WORD max_cfg_sess;
	WORD max_sess;
	WORD max_sess_pkt_size;
	WORD name_count;
} ADAPTER_STATUS;
typedef struct _ADDJOB_INFO_1 {
	LPTSTR Path;
	DWORD JobId;
} ADDJOB_INFO_1;
typedef struct tagANIMATIONINFO {
	UINT cbSize;
	int iMinAnimate;
} ANIMATIONINFO,*LPANIMATIONINFO;
typedef struct _RECT {
	LONG left;
	LONG top;
	LONG right;
	LONG bottom;
} RECT,*LPRECT;
typedef struct _RECT *PRECT;
typedef const RECT *LPCRECT;
typedef struct _RECTL {
	LONG left;
	LONG top;
	LONG right;
	LONG bottom;
} RECTL;
typedef const RECTL *LPCRECTL;
typedef struct tagBITMAP {
	LONG bmType;
	LONG bmWidth;
	LONG bmHeight;
	LONG bmWidthBytes;
	WORD bmPlanes;
	WORD bmBitsPixel;
	LPVOID bmBits;
} BITMAP,*PBITMAP,*NPBITMAP,*LPBITMAP;
typedef struct tagBITMAPCOREHEADER {
	DWORD bcSize;
	WORD bcWidth;
	WORD bcHeight;
	WORD bcPlanes;
	WORD bcBitCount;
} BITMAPCOREHEADER;

typedef BITMAPCOREHEADER *LPBITMAPCOREHEADER;
typedef struct tagRGBTRIPLE {
	BYTE rgbtBlue;
	BYTE rgbtGreen;
	BYTE rgbtRed;
} RGBTRIPLE;
typedef struct _BITMAPCOREINFO {
	BITMAPCOREHEADER bmciHeader;
	RGBTRIPLE bmciColors[1];
} BITMAPCOREINFO;

typedef BITMAPCOREINFO *LPBITMAPCOREINFO;
typedef struct tagBITMAPFILEHEADER {
	WORD bfType;
	DWORD bfSize;
	WORD bfReserved1;
	WORD bfReserved2;
	DWORD bfOffBits;
} BITMAPFILEHEADER,*LPBITMAPFILEHEADER;
typedef struct tagBITMAPINFOHEADER {
	DWORD biSize;
	LONG biWidth;
	LONG biHeight;
	WORD biPlanes;
	WORD biBitCount;
	DWORD biCompression;
	DWORD biSizeImage;
	LONG biXPelsPerMeter;
	LONG biYPelsPerMeter;
	DWORD biClrUsed;
	DWORD biClrImportant;
} BITMAPINFOHEADER,*LPBITMAPINFOHEADER;
typedef struct tagRGBQUAD {
	BYTE rgbBlue;
	BYTE rgbGreen;
	BYTE rgbRed;
	BYTE rgbReserved;
} RGBQUAD,*LPRGBQUAD;
typedef struct tagBITMAPINFO {
	BITMAPINFOHEADER bmiHeader;
	RGBQUAD bmiColors[1];
} BITMAPINFO,*LPBITMAPINFO,*PBITMAPINFO;
typedef long FXPT2DOT30,*LPFXPT2DOT30;
typedef struct tagCIEXYZ {
	FXPT2DOT30 ciexyzX;
	FXPT2DOT30 ciexyzY;
	FXPT2DOT30 ciexyzZ;
} CIEXYZ;
typedef CIEXYZ *LPCIEXYZ;
typedef struct tagCIEXYZTRIPLE {
	CIEXYZ ciexyzRed;
	CIEXYZ ciexyzGreen;
	CIEXYZ ciexyzBlue;
} CIEXYZTRIPLE;
typedef CIEXYZTRIPLE *LPCIEXYZTRIPLE;
typedef struct {
	DWORD bV4Size;
	LONG bV4Width;
	LONG bV4Height;
	WORD bV4Planes;
	WORD bV4BitCount;
	DWORD bV4V4Compression;
	DWORD bV4SizeImage;
	LONG bV4XPelsPerMeter;
	LONG bV4YPelsPerMeter;
	DWORD bV4ClrUsed;
	DWORD bV4ClrImportant;
	DWORD bV4RedMask;
	DWORD bV4GreenMask;
	DWORD bV4BlueMask;
	DWORD bV4AlphaMask;
	DWORD bV4CSType;
	CIEXYZTRIPLE bV4Endpoints;
	DWORD bV4GammaRed;
	DWORD bV4GammaGreen;
	DWORD bV4GammaBlue;
} BITMAPV4HEADER,*LPBITMAPV4HEADER,*PBITMAPV4HEADER;
typedef struct _SHITEMID {
	USHORT cb;
	BYTE abID[1];
} SHITEMID,*LPSHITEMID;
typedef const SHITEMID *LPCSHITEMID;
typedef struct _ITEMIDLIST {
	SHITEMID mkid;
} ITEMIDLIST,*LPITEMIDLIST;
typedef const ITEMIDLIST *LPCITEMIDLIST;
typedef struct _browseinfo {
	HWND hwndOwner;
	LPCITEMIDLIST pidlRoot;
	LPSTR pszDisplayName;
	LPCSTR lpszTitle;
	UINT ulFlags;
	BFFCALLBACK lpfn;
	LPARAM lParam;
	int iImage;
} BROWSEINFO,*PBROWSEINFO,*LPBROWSEINFO;
typedef struct _FILETIME {
	DWORD dwLowDateTime;
	DWORD dwHighDateTime;
} FILETIME,*LPFILETIME,*PFILETIME;
typedef struct _BY_HANDLE_FILE_INFORMATION {
	DWORD dwFileAttributes;
	FILETIME ftCreationTime;
	FILETIME ftLastAccessTime;
	FILETIME ftLastWriteTime;
	DWORD dwVolumeSerialNumber;
	DWORD nFileSizeHigh;
	DWORD nFileSizeLow;
	DWORD nNumberOfLinks;
	DWORD nFileIndexHigh;
	DWORD nFileIndexLow;
} BY_HANDLE_FILE_INFORMATION,*LPBY_HANDLE_FILE_INFORMATION;
typedef struct _FIXED {
	WORD fract;
	short value;
} FIXED;
typedef struct tagPOINT {
	LONG x;
	LONG y;
} POINT,*PPOINT;

typedef struct tagPOINTFX {
	FIXED x;
	FIXED y;
} POINTFX;
typedef struct _POINTL {
	LONG x;
	LONG y;
} POINTL;
typedef struct tagPOINTS {
	SHORT x;
	SHORT y;
} POINTS;
typedef struct _tagCANDIDATEFORM {
	DWORD dwIndex;
	DWORD dwStyle;
	POINT ptCurrentPos;
	RECT rcArea;
} CANDIDATEFORM,*LPCANDIDATEFORM;
typedef struct _tagCANDIDATELIST {
	DWORD dwSize;
	DWORD dwStyle;
	DWORD dwCount;
	DWORD dwSelection;
	DWORD dwPageStart;
	DWORD dwPageSize;
	DWORD dwOffset[1];
} CANDIDATELIST,*LPCANDIDATELIST;
typedef struct tagCREATESTRUCT {
	LPVOID lpCreateParams;
	HINSTANCE hInstance;
	HMENU hMenu;
	HWND hwndParent;
	int cy;
	int cx;
	int y;
	int x;
	LONG style;
	LPCTSTR lpszName;
	LPCTSTR lpszClass;
	DWORD dwExStyle;
} CREATESTRUCT,*LPCREATESTRUCT;
typedef struct tagCBT_CREATEWND {
	LPCREATESTRUCT lpcs;
	HWND hwndInsertAfter;
} CBT_CREATEWND;
typedef struct tagCBTACTIVATESTRUCT {
	BOOL fMouse;
	HWND hWndActive;
} CBTACTIVATESTRUCT;
typedef struct _CHAR_INFO {
	union {
		WCHAR UnicodeChar;
		CHAR AsciiChar;
	} Char;
	WORD Attributes;
} CHAR_INFO,*PCHAR_INFO;
typedef struct _charrange { LONG cpMin; LONG cpMax; } CHARRANGE;
typedef struct tagCHARSET { DWORD aflBlock[3]; DWORD flLang; } CHARSET;
typedef struct tagFONTSIGNATURE { DWORD fsUsb[4]; DWORD fsCsb[2]; }
	FONTSIGNATURE,*LPFONTSIGNATURE;
typedef struct {
	UINT ciCharset;
	UINT ciACP;
	FONTSIGNATURE fs;
} CHARSETINFO,*LPCHARSETINFO;
typedef struct {
	DWORD lStructSize;
	HWND hwndOwner;
	HWND hInstance;
	COLORREF rgbResult;
	COLORREF *lpCustColors;
	DWORD Flags;
	LPARAM lCustData;
	LPCCHOOKPROC lpfnHook;
	LPCTSTR lpTemplateName;
} CHOOSECOLOR,*LPCHOOSECOLOR;
typedef struct tagLOGFONT {
	LONG lfHeight;
	LONG lfWidth;
	LONG lfEscapement;
	LONG lfOrientation;
	LONG lfWeight;
	BYTE lfItalic;
	BYTE lfUnderline;
	BYTE lfStrikeOut;
	BYTE lfCharSet;
	BYTE lfOutPrecision;
	BYTE lfClipPrecision;
	BYTE lfQuality;
	BYTE lfPitchAndFamily;
	TCHAR lfFaceName[32];
} LOGFONT,*LPLOGFONT,*PLOGFONT;
typedef struct {
	DWORD lStructSize;
	HWND hwndOwner;
	HDC hDC;
	LPLOGFONT lpLogFont;
	INT iPointSize;
	DWORD Flags;
	DWORD rgbColors;
	LPARAM lCustData;
	LPCFHOOKPROC lpfnHook;
	LPCTSTR lpTemplateName;
	HINSTANCE hInstance;
	LPTSTR lpszStyle;
	WORD nFontType;
	WORD ___MISSING_ALIGNMENT__;
	INT nSizeMin;
	INT nSizeMax;
} CHOOSEFONT,*LPCHOOSEFONT;
typedef struct _IDA {
	UINT cidl;
	UINT aoffset[1];
} CIDA,*LPIDA;
typedef struct tagCLIENTCREATESTRUCT {
	HANDLE hWindowMenu;
	UINT idFirstChild;
} CLIENTCREATESTRUCT;
typedef struct _CMInvokeCommandInfo {
	DWORD cbSize;
	DWORD fMask;
	HWND hwnd;
	LPCSTR lpVerb;
	LPCSTR lpParameters;
	LPCSTR lpDirectory;
	int nShow;
	DWORD dwHotKey;
	HANDLE hIcon;
} CMINVOKECOMMANDINFO,*LPCMINVOKECOMMANDINFO;
typedef struct tagCOLORADJUSTMENT {
	WORD caSize;
	WORD caFlags;
	WORD caIlluminantIndex;
	WORD caRedGamma;
	WORD caGreenGamma;
	WORD caBlueGamma;
	WORD caReferenceBlack;
	WORD caReferenceWhite;
	SHORT caContrast;
	SHORT caBrightness;
	SHORT caColorfulness;
	SHORT caRedGreenTint;
} COLORADJUSTMENT,*LPCOLORADJUSTMENT;
typedef struct _COLORMAP {
	COLORREF from;
	COLORREF to;
} COLORMAP,*LPCOLORMAP;
typedef struct _DCB {
	DWORD DCBlength;
	DWORD BaudRate;
	DWORD fBinary:1;
	DWORD fParity:1;
	DWORD fOutxCtsFlow:1;
	DWORD fOutxDsrFlow:1;
	DWORD fDtrControl:2;
	DWORD fDsrSensitivity:1;
	DWORD fTXContinueOnXoff:1;
	DWORD fOutX:1;
	DWORD fInX:1;
	DWORD fErrorChar:1;
	DWORD fNull:1;
	DWORD fRtsControl:2;
	DWORD fAbortOnError:1;
	DWORD fDummy2:17;
	WORD wReserved;
	WORD XonLim;
	WORD XoffLim;
	BYTE ByteSize;
	BYTE Parity;
	BYTE StopBits;
	char XonChar;
	char XoffChar;
	char ErrorChar;
	char EofChar;
	char EvtChar;
	WORD wReserved1;
} DCB,*LPDCB;
typedef struct  _DEC { USHORT wReserved; BYTE scale; BYTE sign;
    ULONG Hi32;long long Lo64; }   DECIMAL;
typedef struct tagBLOB { ULONG cbSize; BYTE *pBlobData; } BLOB;
typedef struct tagBLOB *LPBLOB;
typedef struct _COMM_CONFIG {
	DWORD dwSize;
	WORD wVersion;
	WORD wReserved;
	DCB dcb;
	DWORD dwProviderSubType;
	DWORD dwProviderOffset;
	DWORD dwProviderSize;
	WCHAR wcProviderData[1];
} COMMCONFIG,*LPCOMMCONFIG;
typedef struct _COMMPROP {
	WORD wPacketLength;
	WORD wPacketVersion;
	DWORD dwServiceMask;
	DWORD dwReserved1;
	DWORD dwMaxTxQueue;
	DWORD dwMaxRxQueue;
	DWORD dwMaxBaud;
	DWORD dwProvSubType;
	DWORD dwProvCapabilities;
	DWORD dwSettableParams;
	DWORD dwSettableBaud;
	WORD wSettableData;
	WORD wSettableStopParity;
	DWORD dwCurrentTxQueue;
	DWORD dwCurrentRxQueue;
	DWORD dwProvSpec1;
	DWORD dwProvSpec2;
	WCHAR wcProvChar[1];
} COMMPROP,*LPCOMMPROP;
typedef struct _COMMTIMEOUTS {
	DWORD ReadIntervalTimeout;
	DWORD ReadTotalTimeoutMultiplier;
	DWORD ReadTotalTimeoutConstant;
	DWORD WriteTotalTimeoutMultiplier;
	DWORD WriteTotalTimeoutConstant;
} COMMTIMEOUTS,*LPCOMMTIMEOUTS;
typedef struct tagCOMPAREITEMSTRUCT {
	UINT CtlType;
	UINT CtlID;
	HWND hwndItem;
	UINT itemID1;
	DWORD itemData1;
	UINT itemID2;
	DWORD itemData2;
} COMPAREITEMSTRUCT;
typedef struct {
	COLORREF crText;
	COLORREF crBackground;
	DWORD dwEffects;
} COMPCOLOR;
typedef struct _tagCOMPOSITIONFORM {
	DWORD dwStyle;
	POINT ptCurrentPos;
	RECT rcArea;
} COMPOSITIONFORM,*LPCOMPOSITIONFORM;
typedef struct _COMSTAT {
	DWORD fCtsHold:1;
	DWORD fDsrHold:1;
	DWORD fRlsdHold:1;
	DWORD fXoffHold:1;
	DWORD fXoffSent:1;
	DWORD fEof:1;
	DWORD fTxim:1;
	DWORD fReserved:25;
	DWORD cbInQue;
	DWORD cbOutQue;
} COMSTAT,*LPCOMSTAT;
typedef struct _CONSOLE_CURSOR_INFO {
	DWORD dwSize;
	BOOL bVisible;
} CONSOLE_CURSOR_INFO,*PCONSOLE_CURSOR_INFO;
typedef struct _COORD {
	SHORT X;
	SHORT Y;
} COORD;
typedef struct _SMALL_RECT {
	SHORT Left;
	SHORT Top;
	SHORT Right;
	SHORT Bottom;
} SMALL_RECT,*PSMALL_RECT;
typedef struct _CONSOLE_SCREEN_BUFFER_INFO {
	COORD dwSize;
	COORD dwCursorPosition;
	WORD wAttributes;
	SMALL_RECT srWindow;
	COORD dwMaximumWindowSize;
} CONSOLE_SCREEN_BUFFER_INFO,*PCONSOLE_SCREEN_BUFFER_INFO;

typedef struct _FLOATING_SAVE_AREA {
	DWORD ControlWord;
	DWORD StatusWord;
	DWORD TagWord;
	DWORD ErrorOffset;
	DWORD ErrorSelector;
	DWORD DataOffset;
	DWORD DataSelector;
	BYTE RegisterArea[80];
	DWORD Cr0NpxState;
} FLOATING_SAVE_AREA;
typedef struct _CONTEXT {
	DWORD ContextFlags;
	DWORD Dr0;
	DWORD Dr1;
	DWORD Dr2;
	DWORD Dr3;
	DWORD Dr6;
	DWORD Dr7;
	FLOATING_SAVE_AREA FloatSave;
	DWORD SegGs;
	DWORD SegFs;
	DWORD SegEs;
	DWORD SegDs;
	DWORD Edi;
	DWORD Esi;
	DWORD Ebx;
	DWORD Edx;
	DWORD Ecx;
	DWORD Eax;
	DWORD Ebp;
	DWORD Eip;
	DWORD SegCs;
	DWORD EFlags;
	DWORD Esp;
	DWORD SegSs;
} CONTEXT,*PCONTEXT,*LPCONTEXT;

typedef struct _LIST_ENTRY {
	struct _LIST_ENTRY *Flink;
	struct _LIST_ENTRY *Blink;
} LIST_ENTRY,*PLIST_ENTRY;
typedef struct _CRITICAL_SECTION_DEBUG {
	WORD Type;
	WORD CreatorBackTraceIndex;
	struct _CRITICAL_SECTION *CriticalSection;
	LIST_ENTRY ProcessLocksList;
	DWORD EntryCount;
	DWORD ContentionCount;
	DWORD Depth;
	PVOID OwnerBackTrace[5];
} CRITICAL_SECTION_DEBUG,*PCRITICAL_SECTION_DEBUG;
typedef struct _CRITICAL_SECTION {
	PCRITICAL_SECTION_DEBUG DebugInfo;
	LONG LockCount;
	LONG RecursionCount;
	HANDLE OwningThread;
	HANDLE LockSemaphore;
	DWORD Reserved;
} CRITICAL_SECTION,*PCRITICAL_SECTION,*LPCRITICAL_SECTION;
typedef struct _SECURITY_QUALITY_OF_SERVICE {
	DWORD Length;
	SECURITY_IMPERSONATION_LEVEL ImpersonationLevel;
	BOOL ContextTrackingMode;
	BOOLEAN EffectiveOnly;
} SECURITY_QUALITY_OF_SERVICE;
typedef struct tagCONVCONTEXT {
	UINT cb;
	UINT wFlags;
	UINT wCountryID;
	int iCodePage;
	DWORD dwLangID;
	DWORD dwSecurity;
	SECURITY_QUALITY_OF_SERVICE qos;
} CONVCONTEXT;
typedef struct tagCONVINFO {
	DWORD cb;
	DWORD hUser;
	HCONV hConvPartner;
	HSZ hszSvcPartner;
	HSZ hszServiceReq;
	HSZ hszTopic;
	HSZ hszItem;
	UINT wFmt;
	UINT wType;
	UINT wStatus;
	UINT wConvst;
	UINT wLastError;
	HCONVLIST hConvList;
	CONVCONTEXT ConvCtxt;
	HWND hwnd;
	HWND hwndPartner;
} CONVINFO;
typedef struct tagCOPYDATASTRUCT {
	DWORD dwData;
	DWORD cbData;
	PVOID lpData;
} COPYDATASTRUCT,*PCOPYDATASTRUCT;
typedef struct _cpinfo {
	UINT MaxCharSize;
	BYTE DefaultChar[2];
	BYTE LeadByte[12];
} CPINFO,*LPCPINFO;
typedef struct tagCPLINFO {
	int idIcon;
	int idName;
	int idInfo;
	LONG lData;
} CPLINFO;
typedef struct _CREATE_PROCESS_DEBUG_INFO {
	HANDLE hFile;
	HANDLE hProcess;
	HANDLE hThread;
	LPVOID lpBaseOfImage;
	DWORD dwDebugInfoFileOffset;
	DWORD nDebugInfoSize;
	LPVOID lpThreadLocalBase;
	LPTHREAD_START_ROUTINE lpStartAddress;
	LPVOID lpImageName;
	WORD fUnicode;
} CREATE_PROCESS_DEBUG_INFO;
typedef struct _CREATE_THREAD_DEBUG_INFO {
	HANDLE hThread;
	LPVOID lpThreadLocalBase;
	LPTHREAD_START_ROUTINE lpStartAddress;
} CREATE_THREAD_DEBUG_INFO;
typedef struct _currencyfmt {
	UINT NumDigits;
	UINT LeadingZero;
	UINT Grouping;
	LPTSTR lpDecimalSep;
	LPTSTR lpThousandSep;
	UINT NegativeOrder;
	UINT PositiveOrder;
	LPTSTR lpCurrencySymbol;
} CURRENCYFMT;
typedef struct tagCURSORSHAPE {
	int xHotSpot;
	int yHotSpot;
	int cx;
	int cy;
	int cbWidth;
	BYTE Planes;
	BYTE BitsPixel;
} CURSORSHAPE,*LPCURSORSHAPE;
typedef struct tagCWPRETSTRUCT {
	LRESULT lResult;
	LPARAM lParam;
	WPARAM wParam;
	DWORD message;
	HWND hwnd;
} CWPRETSTRUCT;
typedef struct tagCWPSTRUCT {
	LPARAM lParam;
	WPARAM wParam;
	UINT message;
	HWND hwnd;
} CWPSTRUCT,*PWCWPSTRUCT;
typedef struct _DATATYPES_INFO_1 {
	LPTSTR pName;
} DATATYPES_INFO_1;
typedef struct {
	unsigned short bAppReturnCode:8,reserved:6,fBusy:1,fAck:1;
} DDEACK;
typedef struct {
	unsigned short reserved:14,fDeferUpd:1,fAckReq:1;
	short cfFormat;
} DDEADVISE;
typedef struct {
	unsigned short unused:12,fResponse:1,fRelease:1,reserved:1,fAckReq:1;
	short cfFormat;
	BYTE Value[1];
} DDEDATA;
typedef struct {
	unsigned short unused:13,fRelease:1,fDeferUpd:1,fAckReq:1;
	short cfFormat;
} DDELN;
typedef struct tagDDEML_MSG_HOOK_DATA {
	UINT uiLo;
	UINT uiHi;
	DWORD cbData;
	DWORD Data[8];
} DDEML_MSG_HOOK_DATA;
typedef struct {
	unsigned short unused:13,fRelease:1,fReserved:2;
	short cfFormat;
	BYTE Value[1];
} DDEPOKE;
typedef struct {
	unsigned short unused:12,fAck:1,fRelease:1,fReserved:1,fAckReq:1;
	short cfFormat;
	BYTE rgb[1];
} DDEUP;
typedef struct _EXCEPTION_RECORD {
	DWORD ExceptionCode;
	DWORD ExceptionFlags;
	struct _EXCEPTION_RECORD *ExceptionRecord;
	PVOID ExceptionAddress;
	DWORD NumberParameters;
	DWORD ExceptionInformation[15];
} EXCEPTION_RECORD,*PEXCEPTION_RECORD,*LPEXCEPTION_RECORD;
typedef struct _EXCEPTION_DEBUG_INFO {
	EXCEPTION_RECORD ExceptionRecord;
	DWORD dwFirstChance;
} EXCEPTION_DEBUG_INFO;
typedef struct _EXIT_PROCESS_DEBUG_INFO {
	DWORD dwExitCode;
} EXIT_PROCESS_DEBUG_INFO;
typedef struct _EXIT_THREAD_DEBUG_INFO {
	DWORD dwExitCode;
} EXIT_THREAD_DEBUG_INFO;
typedef struct _LOAD_DLL_DEBUG_INFO {
	HANDLE hFile;
	LPVOID lpBaseOfDll;
	DWORD dwDebugInfoFileOffset;
	DWORD nDebugInfoSize;
	LPVOID lpImageName;
	WORD fUnicode;
} LOAD_DLL_DEBUG_INFO;
typedef struct _UNLOAD_DLL_DEBUG_INFO {
	LPVOID lpBaseOfDll;
} UNLOAD_DLL_DEBUG_INFO;
typedef struct _OUTPUT_DEBUG_STRING_INFO {
	LPSTR lpDebugStringData;
	WORD fUnicode;
	WORD nDebugStringLength;
} OUTPUT_DEBUG_STRING_INFO;
typedef struct _RIP_INFO {
	DWORD dwError;
	DWORD dwType;
} RIP_INFO;
typedef struct _DEBUG_EVENT {
	DWORD dwDebugEventCode;
	DWORD dwProcessId;
	DWORD dwThreadId;
	union {
		EXCEPTION_DEBUG_INFO Exception;
		CREATE_THREAD_DEBUG_INFO CreateThread;
		CREATE_PROCESS_DEBUG_INFO CreateProcessInfo;
		EXIT_THREAD_DEBUG_INFO ExitThread;
		EXIT_PROCESS_DEBUG_INFO ExitProcess;
		LOAD_DLL_DEBUG_INFO LoadDll;
		UNLOAD_DLL_DEBUG_INFO UnloadDll;
		OUTPUT_DEBUG_STRING_INFO DebugString;
		RIP_INFO RipInfo;
	} u;
} DEBUG_EVENT,*LPDEBUG_EVENT;
typedef struct tagDEBUGHOOKINFO {
	DWORD idThread;
	DWORD idThreadInstaller;
	LPARAM lParam;
	WPARAM wParam;
	int code;
} DEBUGHOOKINFO;
typedef LONG(_stdcall * PTOP_LEVEL_EXCEPTION_FILTER) (struct _EXCEPTION_POINTERS * ExceptionInfo);
typedef PTOP_LEVEL_EXCEPTION_FILTER LPTOP_LEVEL_EXCEPTION_FILTER;
typedef struct tagDELETEITEMSTRUCT {
	UINT CtlType;
	UINT CtlID;
	UINT itemID;
	HWND hwndItem;
	UINT itemData;
} DELETEITEMSTRUCT,*LPDELETEITEMSTRUCT,*PDELETEITEMSTRUCT;
typedef struct _DEV_BROADCAST_HDR {
	ULONG dbch_size;
	ULONG dbch_devicetype;
	ULONG dbch_reserved;
} DEV_BROADCAST_HDR;
typedef DEV_BROADCAST_HDR *PDEV_BROADCAST_HDR;
typedef struct _DEV_BROADCAST_OEM {
	ULONG dbco_size;
	ULONG dbco_devicetype;
	ULONG dbco_reserved;
	ULONG dbco_identifier;
	ULONG dbco_suppfunc;
} DEV_BROADCAST_OEM;
typedef DEV_BROADCAST_OEM *PDEV_BROADCAST_OEM;
typedef struct _DEV_BROADCAST_PORT {
	ULONG dbcp_size;
	ULONG dbcp_devicetype;
	ULONG dbcp_reserved;
	char dbcp_name[1];
} DEV_BROADCAST_PORT;
typedef DEV_BROADCAST_PORT *PDEV_BROADCAST_PORT;
struct _DEV_BROADCAST_USERDEFINED {
	struct _DEV_BROADCAST_HDR dbud_dbh;
	char dbud_szName[1];
	BYTE dbud_rgbUserDefined[1];
};
typedef struct _DEV_BROADCAST_VOLUME {
	ULONG dbcv_size;
	ULONG dbcv_devicetype;
	ULONG dbcv_reserved;
	ULONG dbcv_unitmask;
	USHORT dbcv_flags;
} DEV_BROADCAST_VOLUME;
typedef DEV_BROADCAST_VOLUME *PDEV_BROADCAST_VOLUME;
typedef struct _devicemode {
	BCHAR dmDeviceName[32];
	WORD dmSpecVersion;
	WORD dmDriverVersion;
	WORD dmSize;
	WORD dmDriverExtra;
	DWORD dmFields;
	short dmOrientation;
	short dmPaperSize;
	short dmPaperLength;
	short dmPaperWidth;
	short dmScale;
	short dmCopies;
	short dmDefaultSource;
	short dmPrintQuality;
	short dmColor;
	short dmDuplex;
	short dmYResolution;
	short dmTTOption;
	short dmCollate;
	BCHAR dmFormName[32];
	WORD dmLogPixels;
	DWORD dmBitsPerPel;
	DWORD dmPelsWidth;
	DWORD dmPelsHeight;
	DWORD dmDisplayFlags;
	DWORD dmDisplayFrequency;
	DWORD dmICMMethod;
	DWORD dmICMIntent;
	DWORD dmMediaType;
	DWORD dmDitherType;
	DWORD dmICCManufacturer;
	DWORD dmICCModel;
} DEVMODE,*LPDEVMODE,*PDEVMODE;
typedef struct tagDEVNAMES {
	WORD wDriverOffset;
	WORD wDeviceOffset;
	WORD wOutputOffset;
	WORD wDefault;
} DEVNAMES,*LPDEVNAMES;
typedef struct tagDIBSECTION {
	BITMAP dsBm;
	BITMAPINFOHEADER dsBmih;
	DWORD dsBitfields[3];
	HANDLE dshSection;
	DWORD dsOffset;
} DIBSECTION;
typedef union _LARGE_INTEGER {
	struct {
		DWORD LowPart;
		LONG HighPart;
	};
	struct {
		DWORD LowPart;
		LONG HighPart;
	} u;
 long long QuadPart;
} LARGE_INTEGER,*PLARGE_INTEGER;
typedef struct {
	DWORD style;
	DWORD dwExtendedStyle;
	short x;
	short y;
	short cx;
	short cy;
	WORD id;
} DLGITEMTEMPLATE;
typedef struct {
	DWORD style;
	DWORD dwExtendedStyle;
	WORD cdit;
	short x;
	short y;
	short cx;
	short cy;
} DLGTEMPLATE,*LPDLGTEMPLATE;
typedef const DLGTEMPLATE *LPCDLGTEMPLATE;
typedef struct _DOC_INFO_1 {
	LPTSTR pDocName;
	LPTSTR pOutputFile;
	LPTSTR pDatatype;
} DOC_INFO_1;
typedef struct _DOC_INFO_2 {
	LPTSTR pDocName;
	LPTSTR pOutputFile;
	LPTSTR pDatatype;
	DWORD dwMode;
	DWORD JobId;
} DOC_INFO_2;
typedef struct {
	int cbSize;
	LPCTSTR lpszDocName;
	LPCTSTR lpszOutput;
	LPCTSTR lpszDatatype;
	DWORD fwType;
} DOCINFO;
typedef struct {
	UINT uNotification;
	HWND hWnd;
	POINT ptCursor;
} DRAGLISTINFO,*LPDRAGLISTINFO;
typedef struct tagDRAWITEMSTRUCT {
	UINT CtlType;
	UINT CtlID;
	UINT itemID;
	UINT itemAction;
	UINT itemState;
	HWND hwndItem;
	HDC hDC;
	RECT rcItem;
	DWORD itemData;
} DRAWITEMSTRUCT,*LPDRAWITEMSTRUCT,*PDRAWITEMSTRUCT;
typedef struct {
	UINT cbSize;
	int iTabLength;
	int iLeftMargin;
	int iRightMargin;
	UINT uiLengthDrawn;
} DRAWTEXTPARAMS,*LPDRAWTEXTPARAMS;
typedef struct _DRIVER_INFO_1 {
	LPTSTR pName;
} DRIVER_INFO_1;
typedef struct _DRIVER_INFO_2 {
	DWORD cVersion;
	LPTSTR pName;
	LPTSTR pEnvironment;
	LPTSTR pDriverPath;
	LPTSTR pDataFile;
	LPTSTR pConfigFile;
} DRIVER_INFO_2;
typedef struct _DRIVER_INFO_3 {
	DWORD cVersion;
	LPTSTR pName;
	LPTSTR pEnvironment;
	LPTSTR pDriverPath;
	LPTSTR pDataFile;
	LPTSTR pConfigFile;
	LPTSTR pHelpFile;
	LPTSTR pDependentFiles;
	LPTSTR pMonitorName;
	LPTSTR pDefaultDataType;
} DRIVER_INFO_3;
typedef struct _editstream {
	DWORD dwCookie;
	DWORD dwError;
	EDITSTREAMCALLBACK pfnCallback;
} EDITSTREAM;
typedef struct tagEMR {
	DWORD iType;
	DWORD nSize;
} EMR,*PEMR;
typedef struct tagEMRANGLEARC {
	EMR emr;
	POINTL ptlCenter;
	DWORD nRadius;
	FLOAT eStartAngle;
	FLOAT eSweepAngle;
} EMRANGLEARC,*PEMRANGLEARC;
typedef struct tagEMRARC {
	EMR emr;
	RECTL rclBox;
	POINTL ptlStart;
	POINTL ptlEnd;
} EMRARC,*PEMRARC,
EMRARCTO,*PEMRARCTO,
EMRCHORD,*PEMRCHORD,
EMRPIE,*PEMRPIE;
typedef struct _XFORM {
	FLOAT eM11;
	FLOAT eM12;
	FLOAT eM21;
	FLOAT eM22;
	FLOAT eDx;
	FLOAT eDy;
} XFORM,*PXFORM,*LPXFORM;
typedef struct tagEMRBITBLT {
	EMR emr;
	RECTL rclBounds;
	LONG xDest;
	LONG yDest;
	LONG cxDest;
	LONG cyDest;
	DWORD dwRop;
	LONG xSrc;
	LONG ySrc;
	XFORM xformSrc;
	COLORREF crBkColorSrc;
	DWORD iUsageSrc;
	DWORD offBmiSrc;
	DWORD offBitsSrc;
	DWORD cbBitsSrc;
} EMRBITBLT,*PEMRBITBLT;
typedef struct tagLOGBRUSH {
	UINT lbStyle;
	COLORREF lbColor;
	LONG lbHatch;
} LOGBRUSH,*LPLOGBRUSH;
typedef struct tagEMRCREATEBRUSHINDIRECT {
	EMR emr;
	DWORD ihBrush;
	LOGBRUSH lb;
} EMRCREATEBRUSHINDIRECT,*PEMRCREATEBRUSHINDIRECT;
typedef LONG LCSCSTYPE;
typedef LONG LCSGAMUTMATCH;
typedef struct tagLOGCOLORSPACE {
	DWORD lcsSignature;
	DWORD lcsVersion;
	DWORD lcsSize;
	LCSCSTYPE lcsCSType;
	LCSGAMUTMATCH lcsIntent;
	CIEXYZTRIPLE lcsEndpoints;
	DWORD lcsGammaRed;
	DWORD lcsGammaGreen;
	DWORD lcsGammaBlue;
	TCHAR lcsFilename[260];
} LOGCOLORSPACE,*LPLOGCOLORSPACE;
typedef struct tagEMRCREATECOLORSPACE {
	EMR emr;
	DWORD ihCS;
	LOGCOLORSPACE lcs;
} EMRCREATECOLORSPACE,*PEMRCREATECOLORSPACE;
typedef struct tagEMRCREATEDIBPATTERNBRUSHPT {
	EMR emr;
	DWORD ihBrush;
	DWORD iUsage;
	DWORD offBmi;
	DWORD cbBmi;
	DWORD offBits;
	DWORD cbBits;
} EMRCREATEDIBPATTERNBRUSHPT,
PEMRCREATEDIBPATTERNBRUSHPT;
typedef struct tagEMRCREATEMONOBRUSH {
	EMR emr;
	DWORD ihBrush;
	DWORD iUsage;
	DWORD offBmi;
	DWORD cbBmi;
	DWORD offBits;
	DWORD cbBits;
} EMRCREATEMONOBRUSH,*PEMRCREATEMONOBRUSH;
typedef struct tagPALETTEENTRY {
	BYTE peRed;
	BYTE peGreen;
	BYTE peBlue;
	BYTE peFlags;
} PALETTEENTRY,*LPPALETTEENTRY,*PPALETTEENTRY;
typedef struct tagLOGPALETTE {
	WORD palVersion;
	WORD palNumEntries;
	PALETTEENTRY palPalEntry[1];
} LOGPALETTE,*PLOGPALETTE;

typedef LOGPALETTE *LPLOGPALETTE;
typedef struct tagEMRCREATEPALETTE {
	EMR emr;
	DWORD ihPal;
	LOGPALETTE lgpl;
} EMRCREATEPALETTE,*PEMRCREATEPALETTE;
typedef struct tagLOGPEN {
	UINT lopnStyle;
	POINT lopnWidth;
	COLORREF lopnColor;
} LOGPEN,*LPLOGPEN;
typedef struct tagEMRCREATEPEN {
	EMR emr;
	DWORD ihPen;
	LOGPEN lopn;
} EMRCREATEPEN,*PEMRCREATEPEN;
typedef struct tagEMRELLIPSE {
	EMR emr;
	RECTL rclBox;
} EMRELLIPSE,*PEMRELLIPSE,
EMRRECTANGLE,*PEMRRECTANGLE;
typedef struct tagEMREOF {
	EMR emr;
	DWORD nPalEntries;
	DWORD offPalEntries;
	DWORD nSizeLast;
} EMREOF,*PEMREOF;
typedef struct tagEMREXCLUDECLIPRECT {
	EMR emr;
	RECTL rclClip;
} EMREXCLUDECLIPRECT,*PEMREXCLUDECLIPRECT,
EMRINTERSECTCLIPRECT,*PEMRINTERSECTCLIPRECT;
typedef struct tagPANOSE {
	BYTE bFamilyType;
	BYTE bSerifStyle;
	BYTE bWeight;
	BYTE bProportion;
	BYTE bContrast;
	BYTE bStrokeVariation;
	BYTE bArmStyle;
	BYTE bLetterform;
	BYTE bMidline;
	BYTE bXHeight;
} PANOSE;
typedef struct tagEXTLOGFONT {
	LOGFONT elfLogFont;
	BCHAR elfFullName[64];
	BCHAR elfStyle[32];
	DWORD elfVersion;
	DWORD elfStyleSize;
	DWORD elfMatch;
	DWORD elfReserved;
	BYTE elfVendorId[4];
	DWORD elfCulture;
	PANOSE elfPanose;
} EXTLOGFONT;
typedef struct tagEMREXTCREATEFONTINDIRECTW {
	EMR emr;
	DWORD ihFont;
	EXTLOGFONT elfw;
} EMREXTCREATEFONTINDIRECTW,
PEMREXTCREATEFONTINDIRECTW;
typedef struct tagEXTLOGPEN {
	UINT elpPenStyle;
	UINT elpWidth;
	UINT elpBrushStyle;
	COLORREF elpColor;
	LONG elpHatch;
	DWORD elpNumEntries;
	DWORD elpStyleEntry[1];
} EXTLOGPEN;
typedef struct tagEMREXTCREATEPEN {
	EMR emr;
	DWORD ihPen;
	DWORD offBmi;
	DWORD cbBmi;
	DWORD offBits;
	DWORD cbBits;
	EXTLOGPEN elp;
} EMREXTCREATEPEN,*PEMREXTCREATEPEN;
typedef struct tagEMREXTFLOODFILL {
	EMR emr;
	POINTL ptlStart;
	COLORREF crColor;
	DWORD iMode;
} EMREXTFLOODFILL,*PEMREXTFLOODFILL;
typedef struct tagEMREXTSELECTCLIPRGN {
	EMR emr;
	DWORD cbRgnData;
	DWORD iMode;
	BYTE RgnData[1];
} EMREXTSELECTCLIPRGN,*PEMREXTSELECTCLIPRGN;
typedef struct tagEMRTEXT {
	POINTL ptlReference;
	DWORD nChars;
	DWORD offString;
	DWORD fOptions;
	RECTL rcl;
	DWORD offDx;
} EMRTEXT,*PEMRTEXT;
typedef struct tagEMREXTTEXTOUTA {
	EMR emr;
	RECTL rclBounds;
	DWORD iGraphicsMode;
	FLOAT exScale;
	FLOAT eyScale;
	EMRTEXT emrtext;
} EMREXTTEXTOUTA,*PEMREXTTEXTOUTA,
EMREXTTEXTOUTW,*PEMREXTTEXTOUTW;
typedef struct tagEMRFILLPATH {
	EMR emr;
	RECTL rclBounds;
} EMRFILLPATH,*PEMRFILLPATH,
EMRSTROKEANDFILLPATH,*PEMRSTROKEANDFILLPATH,
EMRSTROKEPATH,*PEMRSTROKEPATH;
typedef struct tagEMRFILLRGN {
	EMR emr;
	RECTL rclBounds;
	DWORD cbRgnData;
	DWORD ihBrush;
	BYTE RgnData[1];
} EMRFILLRGN,*PEMRFILLRGN;
typedef struct tagEMRFORMAT {
	DWORD dSignature;
	DWORD nVersion;
	DWORD cbData;
	DWORD offData;
} EMRFORMAT;
typedef struct tagSIZE {
	LONG cx;
	LONG cy;
} SIZE,*PSIZE,*LPSIZE,SIZEL,*PSIZEL,*LPSIZEL;
typedef struct tagEMRFRAMERGN {
	EMR emr;
	RECTL rclBounds;
	DWORD cbRgnData;
	DWORD ihBrush;
	SIZEL szlStroke;
	BYTE RgnData[1];
} EMRFRAMERGN,*PEMRFRAMERGN;
typedef struct tagEMRGDICOMMENT {
	EMR emr;
	DWORD cbData;
	BYTE Data[1];
} EMRGDICOMMENT,*PEMRGDICOMMENT;
typedef struct tagEMRINVERTRGN {
	EMR emr;
	RECTL rclBounds;
	DWORD cbRgnData;
	BYTE RgnData[1];
} EMRINVERTRGN,*PEMRINVERTRGN,
EMRPAINTRGN,*PEMRPAINTRGN;
typedef struct tagEMRLINETO {
	EMR emr;
	POINTL ptl;
} EMRLINETO,*PEMRLINETO,
EMRMOVETOEX,*PEMRMOVETOEX;
typedef struct tagEMRMASKBLT {
	EMR emr;
	RECTL rclBounds;
	LONG xDest;
	LONG yDest;
	LONG cxDest;
	LONG cyDest;
	DWORD dwRop;
	LONG xSrc;
	LONG ySrc;
	XFORM xformSrc;
	COLORREF crBkColorSrc;
	DWORD iUsageSrc;
	DWORD offBmiSrc;
	DWORD cbBmiSrc;
	DWORD offBitsSrc;
	DWORD cbBitsSrc;
	LONG xMask;
	LONG yMask;
	DWORD iUsageMask;
	DWORD offBmiMask;
	DWORD cbBmiMask;
	DWORD offBitsMask;
	DWORD cbBitsMask;
} EMRMASKBLT,*PEMRMASKBLT;
typedef struct tagEMRMODIFYWORLDTRANSFORM {
	EMR emr;
	XFORM xform;
	DWORD iMode;
} EMRMODIFYWORLDTRANSFORM,
PEMRMODIFYWORLDTRANSFORM;
typedef struct tagEMROFFSETCLIPRGN {
	EMR emr;
	POINTL ptlOffset;
} EMROFFSETCLIPRGN,*PEMROFFSETCLIPRGN;
typedef struct tagEMRPLGBLT {
	EMR emr;
	RECTL rclBounds;
	POINTL aptlDest[3];
	LONG xSrc;
	LONG ySrc;
	LONG cxSrc;
	LONG cySrc;
	XFORM xformSrc;
	COLORREF crBkColorSrc;
	DWORD iUsageSrc;
	DWORD offBmiSrc;
	DWORD cbBmiSrc;
	DWORD offBitsSrc;
	DWORD cbBitsSrc;
	LONG xMask;
	LONG yMask;
	DWORD iUsageMask;
	DWORD offBmiMask;
	DWORD cbBmiMask;
	DWORD offBitsMask;
	DWORD cbBitsMask;
} EMRPLGBLT,*PEMRPLGBLT;
typedef struct tagEMRPOLYDRAW {
	EMR emr;
	RECTL rclBounds;
	DWORD cptl;
	POINTL aptl[1];
	BYTE abTypes[1];
} EMRPOLYDRAW,*PEMRPOLYDRAW;
typedef struct tagEMRPOLYDRAW16 {
	EMR emr;
	RECTL rclBounds;
	DWORD cpts;
	POINTS apts[1];
	BYTE abTypes[1];
} EMRPOLYDRAW16,*PEMRPOLYDRAW16;
typedef struct tagEMRPOLYLINE {
	EMR emr;
	RECTL rclBounds;
	DWORD cptl;
	POINTL aptl[1];
} EMRPOLYLINE,*PEMRPOLYLINE,
EMRPOLYBEZIER,*PEMRPOLYBEZIER,
EMRPOLYGON,*PEMRPOLYGON,
EMRPOLYBEZIERTO,*PEMRPOLYBEZIERTO,
EMRPOLYLINETO,*PEMRPOLYLINETO;
typedef struct tagEMRPOLYLINE16 {
	EMR emr;
	RECTL rclBounds;
	DWORD cpts;
	POINTL apts[1];
} EMRPOLYLINE16,*PEMRPOLYLINE16,
EMRPOLYBEZIER16,*PEMRPOLYBEZIER16,
EMRPOLYGON16,*PEMRPOLYGON16,
EMRPOLYBEZIERTO16,*PEMRPOLYBEZIERTO16,
EMRPOLYLINETO16,*PEMRPOLYLINETO16;
typedef struct tagEMRPOLYPOLYLINE {
	EMR emr;
	RECTL rclBounds;
	DWORD nPolys;
	DWORD cptl;
	DWORD aPolyCounts[1];
	POINTL aptl[1];
} EMRPOLYPOLYLINE,*PEMRPOLYPOLYLINE,
EMRPOLYPOLYGON,*PEMRPOLYPOLYGON;
typedef struct tagEMRPOLYPOLYLINE16 {
	EMR emr;
	RECTL rclBounds;
	DWORD nPolys;
	DWORD cpts;
	DWORD aPolyCounts[1];
	POINTS apts[1];
} EMRPOLYPOLYLINE16,*PEMRPOLYPOLYLINE16,
EMRPOLYPOLYGON16,*PEMRPOLYPOLYGON16;
typedef struct tagEMRPOLYTEXTOUTA {
	EMR emr;
	RECTL rclBounds;
	DWORD iGraphicsMode;
	FLOAT exScale;
	FLOAT eyScale;
	LONG cStrings;
	EMRTEXT aemrtext[1];
} EMRPOLYTEXTOUTA,*PEMRPOLYTEXTOUTA,
EMRPOLYTEXTOUTW,*PEMRPOLYTEXTOUTW;
typedef struct tagEMRRESIZEPALETTE {
	EMR emr;
	DWORD ihPal;
	DWORD cEntries;
} EMRRESIZEPALETTE,*PEMRRESIZEPALETTE;
typedef struct tagEMRRESTOREDC {
	EMR emr;
	LONG iRelative;
} EMRRESTOREDC,*PEMRRESTOREDC;
typedef struct tagEMRROUNDRECT {
	EMR emr;
	RECTL rclBox;
	SIZEL szlCorner;
} EMRROUNDRECT,*PEMRROUNDRECT;
typedef struct tagEMRSCALEVIEWPORTEXTEX {
	EMR emr;
	LONG xNum;
	LONG xDenom;
	LONG yNum;
	LONG yDenom;
} EMRSCALEVIEWPORTEXTEX,*PEMRSCALEVIEWPORTEXTEX,
EMRSCALEWINDOWEXTEX,*PEMRSCALEWINDOWEXTEX;
typedef struct tagEMRSELECTCOLORSPACE {
	EMR emr;
	DWORD ihCS;
} EMRSELECTCOLORSPACE,*PEMRSELECTCOLORSPACE,
EMRDELETECOLORSPACE,*PEMRDELETECOLORSPACE;
typedef struct tagEMRSELECTOBJECT {
	EMR emr;
	DWORD ihObject;
} EMRSELECTOBJECT,*PEMRSELECTOBJECT,
EMRDELETEOBJECT,*PEMRDELETEOBJECT;
typedef struct tagEMRSELECTPALETTE {
	EMR emr;
	DWORD ihPal;
} EMRSELECTPALETTE,*PEMRSELECTPALETTE;
typedef struct tagEMRSETARCDIRECTION {
	EMR emr;
	DWORD iArcDirection;
} EMRSETARCDIRECTION,*PEMRSETARCDIRECTION;
typedef struct tagEMRSETTEXTCOLOR {
	EMR emr;
	COLORREF crColor;
} EMRSETBKCOLOR,*PEMRSETBKCOLOR,
EMRSETTEXTCOLOR,*PEMRSETTEXTCOLOR;
typedef struct tagEMRSETCOLORADJUSTMENT {
	EMR emr;
	COLORADJUSTMENT ColorAdjustment;
} EMRSETCOLORADJUSTMENT,*PEMRSETCOLORADJUSTMENT;
typedef struct tagEMRSETDIBITSTODEVICE {
	EMR emr;
	RECTL rclBounds;
	LONG xDest;
	LONG yDest;
	LONG xSrc;
	LONG ySrc;
	LONG cxSrc;
	LONG cySrc;
	DWORD offBmiSrc;
	DWORD cbBmiSrc;
	DWORD offBitsSrc;
	DWORD cbBitsSrc;
	DWORD iUsageSrc;
	DWORD iStartScan;
	DWORD cScans;
} EMRSETDIBITSTODEVICE,*PEMRSETDIBITSTODEVICE;
typedef struct tagEMRSETMAPPERFLAGS {
	EMR emr;
	DWORD dwFlags;
} EMRSETMAPPERFLAGS,*PEMRSETMAPPERFLAGS;
typedef struct tagEMRSETMITERLIMIT {
	EMR emr;
	FLOAT eMiterLimit;
} EMRSETMITERLIMIT,*PEMRSETMITERLIMIT;
typedef struct tagEMRSETPALETTEENTRIES {
	EMR emr;
	DWORD ihPal;
	DWORD iStart;
	DWORD cEntries;
	PALETTEENTRY aPalEntries[1];
} EMRSETPALETTEENTRIES,*PEMRSETPALETTEENTRIES;
typedef struct tagEMRSETPIXELV {
	EMR emr;
	POINTL ptlPixel;
	COLORREF crColor;
} EMRSETPIXELV,*PEMRSETPIXELV;
typedef struct tagEMRSETVIEWPORTEXTEX {
	EMR emr;
	SIZEL szlExtent;
} EMRSETVIEWPORTEXTEX,*PEMRSETVIEWPORTEXTEX,
EMRSETWINDOWEXTEX,*PEMRSETWINDOWEXTEX;
typedef struct tagEMRSETVIEWPORTORGEX {
	EMR emr;
	POINTL ptlOrigin;
} EMRSETVIEWPORTORGEX,*PEMRSETVIEWPORTORGEX,
EMRSETWINDOWORGEX,*PEMRSETWINDOWORGEX,
EMRSETBRUSHORGEX,*PEMRSETBRUSHORGEX;
typedef struct tagEMRSETWORLDTRANSFORM {
	EMR emr;
	XFORM xform;
} EMRSETWORLDTRANSFORM,*PEMRSETWORLDTRANSFORM;
typedef struct tagEMRSTRETCHBLT {
	EMR emr;
	RECTL rclBounds;
	LONG xDest;
	LONG yDest;
	LONG cxDest;
	LONG cyDest;
	DWORD dwRop;
	LONG xSrc;
	LONG ySrc;
	XFORM xformSrc;
	COLORREF crBkColorSrc;
	DWORD iUsageSrc;
	DWORD offBmiSrc;
	DWORD cbBmiSrc;
	DWORD offBitsSrc;
	DWORD cbBitsSrc;
	LONG cxSrc;
	LONG cySrc;
} EMRSTRETCHBLT,*PEMRSTRETCHBLT;
typedef struct tagEMRSTRETCHDIBITS {
	EMR emr;
	RECTL rclBounds;
	LONG xDest;
	LONG yDest;
	LONG xSrc;
	LONG ySrc;
	LONG cxSrc;
	LONG cySrc;
	DWORD offBmiSrc;
	DWORD cbBmiSrc;
	DWORD offBitsSrc;
	DWORD cbBitsSrc;
	DWORD iUsageSrc;
	DWORD dwRop;
	LONG cxDest;
	LONG cyDest;
} EMRSTRETCHDIBITS,*PEMRSTRETCHDIBITS;
typedef struct tagABORTPATH {
	EMR emr;
} EMRABORTPATH,*PEMRABORTPATH,
EMRBEGINPATH,*PEMRBEGINPATH,
EMRENDPATH,*PEMRENDPATH,
EMRCLOSEFIGURE,*PEMRCLOSEFIGURE,
EMRFLATTENPATH,*PEMRFLATTENPATH,
EMRWIDENPATH,*PEMRWIDENPATH,
EMRSETMETARGN,*PEMRSETMETARGN,
EMRSAVEDC,*PEMRSAVEDC,
EMRREALIZEPALETTE,*PEMRREALIZEPALETTE;
typedef struct tagEMRSELECTCLIPPATH {
	EMR emr;
	DWORD iMode;
} EMRSELECTCLIPPATH,*PEMRSELECTCLIPPATH,
EMRSETBKMODE,*PEMRSETBKMODE,
EMRSETMAPMODE,*PEMRSETMAPMODE,
EMRSETPOLYFILLMODE,*PEMRSETPOLYFILLMODE,
EMRSETROP2,*PEMRSETROP2,
EMRSETSTRETCHBLTMODE,*PEMRSETSTRETCHBLTMODE,
EMRSETTEXTALIGN,*PEMRSETTEXTALIGN,
EMRENABLEICM,*PEMRENABLEICM;
typedef struct tagNMHDR {
	HWND hwndFrom;
	UINT idFrom;
	UINT code;
} NMHDR;
typedef NMHDR *LPNMHDR;
typedef struct _encorrecttext {
	NMHDR nmhdr;
	CHARRANGE chrg;
	WORD seltyp;
} ENCORRECTTEXT;
typedef struct _endropfiles {
	NMHDR nmhdr;
	HANDLE hDrop;
	LONG cp;
	BOOL fProtected;
} ENDROPFILES;
typedef struct {
	NMHDR nmhdr;
	LONG cObjectCount;
	LONG cch;
} ENSAVECLIPBOARD;
typedef struct {
	NMHDR nmhdr;
	LONG iob;
	LONG lOper;
	HRESULT hr;
} ENOLEOPFAILED;
typedef struct tagENHMETAHEADER {
	DWORD iType;
	DWORD nSize;
	RECTL rclBounds;
	RECTL rclFrame;
	DWORD dSignature;
	DWORD nVersion;
	DWORD nBytes;
	DWORD nRecords;
	WORD nHandles;
	WORD sReserved;
	DWORD nDescription;
	DWORD offDescription;
	DWORD nPalEntries;
	SIZEL szlDevice;
	SIZEL szlMillimeters;
} ENHMETAHEADER,*LPENHMETAHEADER;
typedef struct tagENHMETARECORD {
	DWORD iType;
	DWORD nSize;
	DWORD dParm[1];
} ENHMETARECORD,*LPENHMETARECORD;

typedef struct _enprotected {
	NMHDR nmhdr;
	UINT msg;
	WPARAM wParam;
	LPARAM lParam;
	CHARRANGE chrg;
} ENPROTECTED,*LPENPROTECTED;
typedef struct _SERVICE_STATUS {
	DWORD dwServiceType;
	DWORD dwCurrentState;
	DWORD dwControlsAccepted;
	DWORD dwWin32ExitCode;
	DWORD dwServiceSpecificExitCode;
	DWORD dwCheckPoint;
	DWORD dwWaitHint;
} SERVICE_STATUS,*LPSERVICE_STATUS;
typedef struct _ENUM_SERVICE_STATUS {
	LPTSTR lpServiceName;
	LPTSTR lpDisplayName;
	SERVICE_STATUS ServiceStatus;
} ENUM_SERVICE_STATUS,*LPENUM_SERVICE_STATUS;
typedef struct tagENUMLOGFONT {
	LOGFONT elfLogFont;
	BCHAR elfFullName[64];
	BCHAR elfStyle[32];
} ENUMLOGFONT;
typedef struct tagENUMLOGFONTEX {
	LOGFONT elfLogFont;
	BCHAR elfFullName[64];
	BCHAR elfStyle[32];
	BCHAR elfScript[32];
} ENUMLOGFONTEX;
typedef struct _EVENTLOGRECORD {
	DWORD Length;
	DWORD Reserved;
	DWORD RecordNumber;
	DWORD TimeGenerated;
	DWORD TimeWritten;
	DWORD EventID;
	WORD EventType;
	WORD NumStrings;
	WORD EventCategory;
	WORD ReservedFlags;
	DWORD ClosingRecordNumber;
	DWORD StringOffset;
	DWORD UserSidLength;
	DWORD UserSidOffset;
	DWORD DataLength;
	DWORD DataOffset;
} EVENTLOGRECORD;
typedef struct tagEVENTMSG {
	UINT message;
	UINT paramL;
	UINT paramH;
	DWORD time;
	HWND hwnd;
} EVENTMSG;
typedef struct _EXCEPTION_POINTERS {
	PEXCEPTION_RECORD ExceptionRecord;
	PCONTEXT ContextRecord;
} EXCEPTION_POINTERS,*PEXCEPTION_POINTERS,*LPEXCEPTION_POINTERS;
typedef struct _EXT_BUTTON {
	WORD idCommand;
	WORD idsHelp;
	WORD fsStyle;
} EXT_BUTTON,*LPEXT_BUTTON;
typedef struct tagFILTERKEYS {
	UINT cbSize;
	DWORD dwFlags;
	DWORD iWaitMSec;
	DWORD iDelayMSec;
	DWORD iRepeatMSec;
	DWORD iBounceMSec;
} FILTERKEYS;
typedef struct _FIND_NAME_BUFFER {
	UCHAR length;
	UCHAR access_control;
	UCHAR frame_control;
	UCHAR destination_addr[6];
	UCHAR source_addr[6];
	UCHAR routing_info[18];
} FIND_NAME_BUFFER;
typedef struct _FIND_NAME_HEADER {
	WORD node_count;
	UCHAR reserved;
	UCHAR unique_group;
} FIND_NAME_HEADER;
typedef struct {
	DWORD lStructSize;
	HWND hwndOwner;
	HINSTANCE hInstance;
	DWORD Flags;
	LPTSTR lpstrFindWhat;
	LPTSTR lpstrReplaceWith;
	WORD wFindWhatLen;
	WORD wReplaceWithLen;
	LPARAM lCustData;
	LPFRHOOKPROC lpfnHook;
	LPCTSTR lpTemplateName;
} FINDREPLACE,*LPFINDREPLACE;
typedef struct _findtext {
	CHARRANGE chrg;
	LPSTR lpstrText;
} FINDTEXT;
typedef struct _findtextex {
	CHARRANGE chrg;
	LPSTR lpstrText;
	CHARRANGE chrgText;
} FINDTEXTEX;
typedef struct _FMS_GETDRIVEINFO {
	DWORD dwTotalSpace;
	DWORD dwFreeSpace;
	TCHAR szPath[260];
	TCHAR szVolume[14];
	TCHAR szShare[128];
} FMS_GETDRIVEINFO;
typedef struct _FMS_GETFILESEL {
	FILETIME ftTime;
	DWORD dwSize;
	BYTE bAttr;
	TCHAR szName[260];
} FMS_GETFILESEL;
typedef struct _FMS_LOAD {
	DWORD dwSize;
	TCHAR szMenuName[40];
	HMENU hMenu;
	UINT wMenuDelta;
} FMS_LOAD;
typedef struct _FMS_TOOLBARLOAD {
	DWORD dwSize;
	LPEXT_BUTTON lpButtons;
	WORD cButtons;
	WORD cBitmaps;
	WORD idBitmap;
	HBITMAP hBitmap;
} FMS_TOOLBARLOAD;
typedef struct _FOCUS_EVENT_RECORD {
	BOOL bSetFocus;
} FOCUS_EVENT_RECORD;
typedef struct _FORM_INFO_1 {
	DWORD Flags;
	LPTSTR pName;
	SIZEL Size;
	RECTL ImageableArea;
} FORM_INFO_1;
typedef struct _formatrange {
	HDC hdc;
	HDC hdcTarget;
	RECT rc;
	RECT rcPage;
	CHARRANGE chrg;
} FORMATRANGE;
typedef struct tagGCP_RESULTS {
	DWORD lStructSize;
	LPTSTR lpOutString;
	UINT *lpOrder;
	INT *lpDx;
	INT *lpCaretPos;
	LPTSTR lpClass;
	UINT *lpGlyphs;
	UINT nGlyphs;
	UINT nMaxFit;
} GCP_RESULTS,*LPGCP_RESULTS;
typedef struct _GENERIC_MAPPING {
	ACCESS_MASK GenericRead;
	ACCESS_MASK GenericWrite;
	ACCESS_MASK GenericExecute;
	ACCESS_MASK GenericAll;
} GENERIC_MAPPING,*PGENERIC_MAPPING;
typedef struct _GLYPHMETRICS {
	UINT gmBlackBoxX;
	UINT gmBlackBoxY;
	POINT gmptGlyphOrigin;
	short gmCellIncX;
	short gmCellIncY;
} GLYPHMETRICS,*LPGLYPHMETRICS;
typedef struct tagHANDLETABLE {
	HGDIOBJ objectHandle[1];
} HANDLETABLE,*LPHANDLETABLE;
typedef struct _HD_HITTESTINFO {
	POINT pt;
	UINT flags;
	int iItem;
} HD_HITTESTINFO;
typedef struct _HD_ITEM {
	UINT mask;
	int cxy;
	LPTSTR pszText;
	HBITMAP hbm;
	int cchTextMax;
	int fmt;
	LPARAM lParam;
} HD_ITEM;
typedef struct _WINDOWPOS {
	HWND hwnd;
	HWND hwndInsertAfter;
	int x;
	int y;
	int cx;
	int cy;
	UINT flags;
} WINDOWPOS,*PWINDOWPOS,*LPWINDOWPOS;
typedef struct _HD_LAYOUT {
	RECT *prc;
	WINDOWPOS *pwpos;
} HD_LAYOUT;
typedef struct _HD_NOTIFY {
	NMHDR hdr;
	int iItem;
	int iButton;
	HD_ITEM *pitem;
} HD_NOTIFY;
typedef struct tagHELPINFO {
	UINT cbSize;
	int iContextType;
	int iCtrlId;
	HANDLE hItemHandle;
	DWORD dwContextId;
	POINT MousePos;
} HELPINFO,*LPHELPINFO;
typedef struct {
	int wStructSize;
	int x;
	int y;
	int dx;
	int dy;
	int wMax;
	TCHAR rgchMember[2];
} HELPWININFO;
typedef struct tagHIGHCONTRAST {
	UINT cbSize;
	DWORD dwFlags;
	LPTSTR lpszDefaultScheme;
} HIGHCONTRAST,*LPHIGHCONTRAST;
typedef struct tagHSZPAIR {
	HSZ hszSvc;
	HSZ hszTopic;
} HSZPAIR;
typedef struct _ICONINFO {
	BOOL fIcon;
	DWORD xHotspot;
	DWORD yHotspot;
	HBITMAP hbmMask;
	HBITMAP hbmColor;
} ICONINFO,*PICONINFO;
typedef struct tagICONMETRICS {
	UINT cbSize;
	int iHorzSpacing;
	int iVertSpacing;
	int iTitleWrap;
	LOGFONT lfFont;
} ICONMETRICS,*LPICONMETRICS;
typedef struct _IMAGEINFO {
	HBITMAP hbmImage;
	HBITMAP hbmMask;
	int Unused1;
	int Unused2;
	RECT rcImage;
} IMAGEINFO;
typedef struct _KEY_EVENT_RECORD {
	BOOL bKeyDown;
	WORD wRepeatCount;
	WORD wVirtualKeyCode;
	WORD wVirtualScanCode;
	union {
		WCHAR UnicodeChar;
		CHAR AsciiChar;
	} uChar;
	DWORD dwControlKeyState;
} KEY_EVENT_RECORD;
typedef struct _MOUSE_EVENT_RECORD {
	COORD dwMousePosition;
	DWORD dwButtonState;
	DWORD dwControlKeyState;
	DWORD dwEventFlags;
} MOUSE_EVENT_RECORD;
typedef struct _WINDOW_BUFFER_SIZE_RECORD {
	COORD dwSize;
} WINDOW_BUFFER_SIZE_RECORD;
typedef struct _MENU_EVENT_RECORD {
	UINT dwCommandId;
} MENU_EVENT_RECORD,*PMENU_EVENT_RECORD;
typedef struct _INPUT_RECORD {
	WORD EventType;
	WORD __alignmentDummy;
	union {
		KEY_EVENT_RECORD KeyEvent;
		MOUSE_EVENT_RECORD MouseEvent;
		WINDOW_BUFFER_SIZE_RECORD WindowBufferSizeEvent;
		MENU_EVENT_RECORD MenuEvent;
		FOCUS_EVENT_RECORD FocusEvent;
	} Event;
} INPUT_RECORD,*PINPUT_RECORD;
typedef struct _SYSTEMTIME {
	WORD wYear;
	WORD wMonth;
	WORD wDayOfWeek;
	WORD wDay;
	WORD wHour;
	WORD wMinute;
	WORD wSecond;
	WORD wMilliseconds;
} SYSTEMTIME,*LPSYSTEMTIME;
typedef struct _JOB_INFO_1 {
	DWORD JobId;
	LPTSTR pPrinterName;
	LPTSTR pMachineName;
	LPTSTR pUserName;
	LPTSTR pDocument;
	LPTSTR pDatatype;
	LPTSTR pStatus;
	DWORD Status;
	DWORD Priority;
	DWORD Position;
	DWORD TotalPages;
	DWORD PagesPrinted;
	SYSTEMTIME Submitted;
} JOB_INFO_1;
typedef struct _SID_IDENTIFIER_AUTHORITY {
	BYTE Value[6];
} SID_IDENTIFIER_AUTHORITY,*PSID_IDENTIFIER_AUTHORITY,
*LPSID_IDENTIFIER_AUTHORITY;
typedef struct _SID {
	BYTE Revision;
	BYTE SubAuthorityCount;
	SID_IDENTIFIER_AUTHORITY IdentifierAuthority;
	DWORD SubAuthority[1];
} SID,*PSID;
typedef WORD SECURITY_DESCRIPTOR_CONTROL,*PSECURITY_DESCRIPTOR_CONTROL;
typedef struct _SECURITY_DESCRIPTOR {
	BYTE Revision;
	BYTE Sbz1;
	SECURITY_DESCRIPTOR_CONTROL Control;
	PSID Owner;
	PSID Group;
	PACL Sacl;
	PACL Dacl;
} SECURITY_DESCRIPTOR,*PSECURITY_DESCRIPTOR;
typedef struct _JOB_INFO_2 {
	DWORD JobId;
	LPTSTR pPrinterName;
	LPTSTR pMachineName;
	LPTSTR pUserName;
	LPTSTR pDocument;
	LPTSTR pNotifyName;
	LPTSTR pDatatype;
	LPTSTR pPrintProcessor;
	LPTSTR pParameters;
	LPTSTR pDriverName;
	LPDEVMODE pDevMode;
	LPTSTR pStatus;
	PSECURITY_DESCRIPTOR pSecurityDescriptor;
	DWORD Status;
	DWORD Priority;
	DWORD Position;
	DWORD StartTime;
	DWORD UntilTime;
	DWORD TotalPages;
	DWORD Size;
	SYSTEMTIME Submitted;
	DWORD Time;
	DWORD PagesPrinted;
} JOB_INFO_2;
typedef struct tagKERNINGPAIR {
	WORD wFirst;
	WORD wSecond;
	int iKernAmount;
} KERNINGPAIR,*LPKERNINGPAIR;
typedef struct _LANA_ENUM {
	UCHAR length;
	UCHAR lana[254];
} LANA_ENUM;
typedef struct _LDT_ENTRY {
	WORD LimitLow;
	WORD BaseLow;
	union {
		struct {
			BYTE BaseMid;
			BYTE Flags1;
			BYTE Flags2;
			BYTE BaseHi;
		} Bytes;
		struct {
			DWORD BaseMid:8;
			DWORD Type:5;
			DWORD Dpl:2;
			DWORD Pres:1;
			DWORD LimitHi:4;
			DWORD Sys:1;
			DWORD Reserved_0:1;
			DWORD Default_Big:1;
			DWORD Granularity:1;
			DWORD BaseHi:8;
		} Bits;
	} HighWord;
} LDT_ENTRY,*PLDT_ENTRY,*LPLDT_ENTRY;
typedef struct tagLOCALESIGNATURE {
	DWORD lsUsb[4];
	DWORD lsCsbDefault[2];
	DWORD lsCsbSupported[2];
} LOCALESIGNATURE;
typedef struct _LOCALGROUP_MEMBERS_INFO_0 {
	PSID lgrmi0_sid;
} LOCALGROUP_MEMBERS_INFO_0;
typedef struct _LOCALGROUP_MEMBERS_INFO_3 {
	LPWSTR lgrmi3_domainandname;
} LOCALGROUP_MEMBERS_INFO_3;
typedef long FXPT16DOT16,*LPFXPT16DOT16;
typedef LARGE_INTEGER LUID,*PLUID;
typedef struct _LUID_AND_ATTRIBUTES {
	LUID Luid;
	DWORD Attributes;
} LUID_AND_ATTRIBUTES;
typedef LUID_AND_ATTRIBUTES LUID_AND_ATTRIBUTES_ARRAY[1];
typedef LUID_AND_ATTRIBUTES_ARRAY *PLUID_AND_ATTRIBUTES_ARRAY;
typedef struct _LV_COLUMN {
	UINT mask;
	int fmt;
	int cx;
	LPTSTR pszText;
	int cchTextMax;
	int iSubItem;
} LV_COLUMN;
typedef struct _LV_ITEM {
	UINT mask;
	int iItem;
	int iSubItem;
	UINT state;
	UINT stateMask;
	LPTSTR pszText;
	int cchTextMax;
	int iImage;
	LPARAM lParam;
} LV_ITEM;
typedef struct tagLV_DISPINFO {
	NMHDR hdr;
	LV_ITEM item;
} LV_DISPINFO;
typedef struct _LV_FINDINFO {
	UINT flags;
	LPCTSTR psz;
	LPARAM lParam;
	POINT pt;
	UINT vkDirection;
} LV_FINDINFO;
typedef struct _LV_HITTESTINFO {
	POINT pt;
	UINT flags;
	int iItem;
} LV_HITTESTINFO;
typedef struct tagLV_KEYDOWN {
	NMHDR hdr;
	WORD wVKey;
	UINT flags;
} LV_KEYDOWN;
typedef struct _MAT2 {
	FIXED eM11;
	FIXED eM12;
	FIXED eM21;
	FIXED eM22;
} MAT2;
typedef struct tagMDICREATESTRUCT {
	LPCTSTR szClass;
	LPCTSTR szTitle;
	HANDLE hOwner;
	int x;
	int y;
	int cx;
	int cy;
	DWORD style;
	LPARAM lParam;
} MDICREATESTRUCT;
typedef MDICREATESTRUCT *LPMDICREATESTRUCT;
typedef struct tagMEASUREITEMSTRUCT {
	UINT CtlType;
	UINT CtlID;
	UINT itemID;
	UINT itemWidth;
	UINT itemHeight;
	DWORD itemData;
} MEASUREITEMSTRUCT;
typedef MEASUREITEMSTRUCT *LPMEASUREITEMSTRUCT,*PMEASUREITEMSTRUCT;
typedef struct _MEMORY_BASIC_INFORMATION {
	PVOID BaseAddress;
	PVOID AllocationBase;
	DWORD AllocationProtect;
	DWORD RegionSize;
	DWORD State;
	DWORD Protect;
	DWORD Type;
} MEMORY_BASIC_INFORMATION;
typedef MEMORY_BASIC_INFORMATION *PMEMORY_BASIC_INFORMATION;
typedef struct _MEMORYSTATUS {
	DWORD dwLength;
	DWORD dwMemoryLoad;
	DWORD dwTotalPhys;
	DWORD dwAvailPhys;
	DWORD dwTotalPageFile;
	DWORD dwAvailPageFile;
	DWORD dwTotalVirtual;
	DWORD dwAvailVirtual;
} MEMORYSTATUS,*LPMEMORYSTATUS;
typedef struct {
	WORD wVersion;
	WORD wOffset;
	DWORD dwHelpId;
} MENUEX_TEMPLATE_HEADER;
typedef struct {
	DWORD dwType;
	DWORD dwState;
	UINT uId;
	BYTE bResInfo;
	WCHAR szText[1];
	DWORD dwHelpId;
} MENUEX_TEMPLATE_ITEM;
typedef struct tagMENUITEMINFO {
	UINT cbSize;
	UINT fMask;
	UINT fType;
	UINT fState;
	UINT wID;
	HMENU hSubMenu;
	HBITMAP hbmpChecked;
	HBITMAP hbmpUnchecked;
	DWORD dwItemData;
	LPTSTR dwTypeData;
	UINT cch;
} MENUITEMINFO,*LPMENUITEMINFO;
typedef MENUITEMINFO const *LPCMENUITEMINFO;
typedef struct {
	WORD mtOption;
	WORD mtID;
	WCHAR mtString[1];
} MENUITEMTEMPLATE;
typedef struct {
	WORD versionNumber;
	WORD offset;
} MENUITEMTEMPLATEHEADER;
typedef void MENUTEMPLATE,*LPMENUTEMPLATE;
typedef struct tagMETAFILEPICT {
	LONG mm;
	LONG xExt;
	LONG yExt;
	HMETAFILE hMF;
} METAFILEPICT,*LPMETAFILEPICT;
typedef struct tagMETAHEADER {
	WORD mtType;
	WORD mtHeaderSize;
	WORD mtVersion;
	DWORD mtSize;
	WORD mtNoObjects;
	DWORD mtMaxRecord;
	WORD mtNoParameters;
} METAHEADER,*LPMETAHEADER;
typedef struct tagMETARECORD {
	DWORD rdSize;
	WORD rdFunction;
	WORD rdParm[1];
} METARECORD,*LPMETARECORD;
typedef struct tagMINIMIZEDMETRICS {
	UINT cbSize;
	int iWidth;
	int iHorzGap;
	int iVertGap;
	int iArrange;
} MINIMIZEDMETRICS,*LPMINIMIZEDMETRICS;
typedef struct tagMINMAXINFO {
	POINT ptReserved;
	POINT ptMaxSize;
	POINT ptMaxPosition;
	POINT ptMinTrackSize;
	POINT ptMaxTrackSize;
} MINMAXINFO,*LPMINMAXINFO;
typedef struct modemdevcaps_tag {
	DWORD dwActualSize;
	DWORD dwRequiredSize;
	DWORD dwDevSpecificOffset;
	DWORD dwDevSpecificSize;
	DWORD dwModemProviderVersion;
	DWORD dwModemManufacturerOffset;
	DWORD dwModemManufacturerSize;
	DWORD dwModemModelOffset;
	DWORD dwModemModelSize;
	DWORD dwModemVersionOffset;
	DWORD dwModemVersionSize;
	DWORD dwDialOptions;
	DWORD dwCallSetupFailTimer;
	DWORD dwInactivityTimeout;
	DWORD dwSpeakerVolume;
	DWORD dwSpeakerMode;
	DWORD dwModemOptions;
	DWORD dwMaxDTERate;
	DWORD dwMaxDCERate;
	BYTE abVariablePortion[1];
} MODEMDEVCAPS,*PMODEMDEVCAPS,*LPMODEMDEVCAPS;
typedef struct modemsettings_tag {
	DWORD dwActualSize;
	DWORD dwRequiredSize;
	DWORD dwDevSpecificOffset;
	DWORD dwDevSpecificSize;
	DWORD dwCallSetupFailTimer;
	DWORD dwInactivityTimeout;
	DWORD dwSpeakerVolume;
	DWORD dwSpeakerMode;
	DWORD dwPreferredModemOptions;
	DWORD dwNegotiatedModemOptions;
	DWORD dwNegotiatedDCERate;
	BYTE abVariablePortion[1];
} MODEMSETTINGS,*PMODEMSETTINGS,*LPMODEMSETTINGS;
typedef struct tagMONCBSTRUCT {
	UINT cb;
	DWORD dwTime;
	HANDLE hTask;
	DWORD dwRet;
	UINT wType;
	UINT wFmt;
	HCONV hConv;
	HSZ hsz1;
	HSZ hsz2;
	HDDEDATA hData;
	DWORD dwData1;
	DWORD dwData2;
	CONVCONTEXT cc;
	DWORD cbData;
	DWORD Data[8];
} MONCBSTRUCT;
typedef struct tagMONCONVSTRUCT {
	UINT cb;
	BOOL fConnect;
	DWORD dwTime;
	HANDLE hTask;
	HSZ hszSvc;
	HSZ hszTopic;
	HCONV hConvClient;
	HCONV hConvServer;
} MONCONVSTRUCT;
typedef struct tagMONERRSTRUCT {
	UINT cb;
	UINT wLastError;
	DWORD dwTime;
	HANDLE hTask;
} MONERRSTRUCT;
typedef struct tagMONHSZSTRUCT {
	UINT cb;
	BOOL fsAction;
	DWORD dwTime;
	HSZ hsz;
	HANDLE hTask;
	TCHAR str[1];
} MONHSZSTRUCT;
typedef struct _MONITOR_INFO_1 {
	LPTSTR pName;
} MONITOR_INFO_1;
typedef struct _MONITOR_INFO_2 {
	LPTSTR pName;
	LPTSTR pEnvironment;
	LPTSTR pDLLName;
} MONITOR_INFO_2;
typedef struct tagMONLINKSTRUCT {
	UINT cb;
	DWORD dwTime;
	HANDLE hTask;
	BOOL fEstablished;
	BOOL fNoData;
	HSZ hszSvc;
	HSZ hszTopic;
	HSZ hszItem;
	UINT wFmt;
	BOOL fServer;
	HCONV hConvServer;
	HCONV hConvClient;
} MONLINKSTRUCT;
typedef struct tagMONMSGSTRUCT {
	UINT cb;
	HWND hwndTo;
	DWORD dwTime;
	HANDLE hTask;
	UINT wMsg;
	WPARAM wParam;
	LPARAM lParam;
	DDEML_MSG_HOOK_DATA dmhd;
} MONMSGSTRUCT;
typedef struct tagMOUSEHOOKSTRUCT {
	POINT pt;
	HWND hwnd;
	UINT wHitTestCode;
	DWORD dwExtraInfo;
} MOUSEHOOKSTRUCT,*PMOUSEHOOKSTRUCT;
typedef struct _MOUSEKEYS {
	DWORD cbSize;
	DWORD dwFlags;
	DWORD iMaxSpeed;
	DWORD iTimeToMaxSpeed;
	DWORD iCtrlSpeed;
	DWORD dwReserved1;
	DWORD dwReserved2;
} MOUSEKEYS;
typedef struct tagMSG {
	HWND hwnd;
	UINT message;
	WPARAM wParam;
	LPARAM lParam;
	DWORD time;
	POINT pt;
} MSG,*LPMSG,*PMSG;
typedef void (_stdcall * MSGBOXCALLBACK) (LPHELPINFO lpHelpInfo);
typedef struct {
	UINT cbSize;
	HWND hwndOwner;
	HINSTANCE hInstance;
	LPCSTR lpszText;
	LPCSTR lpszCaption;
	DWORD dwStyle;
	LPCSTR lpszIcon;
	DWORD dwContextHelpId;
	MSGBOXCALLBACK lpfnMsgBoxCallback;
	DWORD dwLanguageId;
} MSGBOXPARAMS,*PMSGBOXPARAMS,*LPMSGBOXPARAMS;
typedef struct _msgfilter {
	NMHDR nmhdr;
	UINT msg;
	WPARAM wParam;
	LPARAM lParam;
} MSGFILTER;
typedef struct tagMULTIKEYHELP {
	DWORD mkSize;
	TCHAR mkKeylist;
	TCHAR szKeyphrase[1];
} MULTIKEYHELP;
typedef struct _NAME_BUFFER {
	UCHAR name[16];
	UCHAR name_num;
	UCHAR name_flags;
} NAME_BUFFER;
typedef struct _NCB {
	UCHAR ncb_command;
	UCHAR ncb_retcode;
	UCHAR ncb_lsn;
	UCHAR ncb_num;
	PUCHAR ncb_buffer;
	WORD ncb_length;
	UCHAR ncb_callname[16];
	UCHAR ncb_name[16];
	UCHAR ncb_rto;
	UCHAR ncb_sto;
	void (*ncb_post) (struct _NCB *);
	UCHAR ncb_lana_num;
	UCHAR ncb_cmd_cplt;
	UCHAR ncb_reserve[10];
	HANDLE ncb_event;
} NCB;
typedef struct _NCCALCSIZE_PARAMS {
	RECT rgrc[3];
	PWINDOWPOS lppos;
} NCCALCSIZE_PARAMS;
typedef struct _NDDESHAREINFO {
	LONG lRevision;
	LPTSTR lpszShareName;
	LONG lShareType;
	LPTSTR lpszAppTopicList;
	LONG fSharedFlag;
	LONG fService;
	LONG fStartAppFlag;
	LONG nCmdShow;
	LONG qModifyId[2];
	LONG cNumItems;
	LPTSTR lpszItemList;
} NDDESHAREINFO;
typedef struct _NETRESOURCE {
	DWORD dwScope;
	DWORD dwType;
	DWORD dwDisplayType;
	DWORD dwUsage;
	LPTSTR lpLocalName;
	LPTSTR lpRemoteName;
	LPTSTR lpComment;
	LPTSTR lpProvider;
} NETRESOURCE,*LPNETRESOURCE;
typedef struct tagNEWCPLINFO {
	DWORD dwSize;
	DWORD dwFlags;
	DWORD dwHelpContext;
	LONG lData;
	HICON hIcon;
	TCHAR szName[32];
	TCHAR szInfo[64];
	TCHAR szHelpFile[128];
} NEWCPLINFO;
#pragma pack(push,4)
typedef struct tagNEWTEXTMETRIC {
	LONG tmHeight;
	LONG tmAscent;
	LONG tmDescent;
	LONG tmInternalLeading;
	LONG tmExternalLeading;
	LONG tmAveCharWidth;
	LONG tmMaxCharWidth;
	LONG tmWeight;
	LONG tmOverhang;
	LONG tmDigitizedAspectX;
	LONG tmDigitizedAspectY;
	BCHAR tmFirstChar;
	BCHAR tmLastChar;
	BCHAR tmDefaultChar;
	BCHAR tmBreakChar;
	BYTE tmItalic;
	BYTE tmUnderlined;
	BYTE tmStruckOut;
	BYTE tmPitchAndFamily;
	BYTE tmCharSet;
	DWORD ntmFlags;
	UINT ntmSizeEM;
	UINT ntmCellHeight;
	UINT ntmAvgWidth;
} NEWTEXTMETRIC;
#pragma pack(pop)
typedef struct tagNEWTEXTMETRICEX {
	NEWTEXTMETRIC ntmentm;
	FONTSIGNATURE ntmeFontSignature;
} NEWTEXTMETRICEX;
typedef struct tagNM_LISTVIEW {
	NMHDR hdr;
	int iItem;
	int iSubItem;
	UINT uNewState;
	UINT uOldState;
	UINT uChanged;
	POINT ptAction;
	LPARAM lParam;
} NM_LISTVIEW,*LPNMLISTVIEW;
typedef struct _TREEITEM *HTREEITEM;
typedef struct _TV_ITEM {
	UINT mask;
	HTREEITEM hItem;
	UINT state;
	UINT stateMask;
	LPTSTR pszText;
	int cchTextMax;
	int iImage;
	int iSelectedImage;
	int cChildren;
	LPARAM lParam;
} TV_ITEM,*LPTV_ITEM;
typedef struct _NM_TREEVIEW {
	NMHDR hdr;
	UINT action;
	TV_ITEM itemOld;
	TV_ITEM itemNew;
	POINT ptDrag;
} NM_TREEVIEW;
typedef NM_TREEVIEW *LPNM_TREEVIEW;
typedef struct _NM_UPDOWN {
	NMHDR hdr;
	int iPos;
	int iDelta;
} NM_UPDOWNW,*LPNM_UPDOWNW;
typedef struct tagNONCLIENTMETRICS {
	UINT cbSize;
	int iBorderWidth;
	int iScrollWidth;
	int iScrollHeight;
	int iCaptionWidth;
	int iCaptionHeight;
	LOGFONT lfCaptionFont;
	int iSmCaptionWidth;
	int iSmCaptionHeight;
	LOGFONT lfSmCaptionFont;
	int iMenuWidth;
	int iMenuHeight;
	LOGFONT lfMenuFont;
	LOGFONT lfStatusFont;
	LOGFONT lfMessageFont;
} NONCLIENTMETRICS,*LPNONCLIENTMETRICS;
typedef struct _SERVICE_ADDRESS {
	DWORD dwAddressType;
	DWORD dwAddressFlags;
	DWORD dwAddressLength;
	DWORD dwPrincipalLength;
	BYTE *lpAddress;
	BYTE *lpPrincipal;
} SERVICE_ADDRESS;
typedef struct _SERVICE_ADDRESSES {
	DWORD dwAddressCount;
	SERVICE_ADDRESS Addresses[1];
} SERVICE_ADDRESSES,*LPSERVICE_ADDRESSES;

typedef struct _GUID {
	unsigned long Data1;
	unsigned short Data2;
	unsigned short Data3;
	unsigned char Data4[8];
} GUID,*LPGUID;


typedef GUID IID;
typedef IID *LPIID;
typedef IID *REFIID;
typedef GUID CLSID,*LPCLSID;
typedef CLSID *REFCLSID;
typedef GUID *REFGUID;
typedef struct  tagRemHGLOBAL {
	long fNullHGlobal;
	unsigned long cbData;
	unsigned char data[1]; }   RemHGLOBAL;
typedef struct  tagRemHMETAFILEPICT {
	long mm;
	long xExt;
	long yExt;
	unsigned long cbData;
	unsigned char data[1];
}	RemHMETAFILEPICT;
typedef void *HMETAFILEPICT;
typedef struct  tagRemHENHMETAFILE {
	unsigned long cbData;
	unsigned char data[1];
	} RemHENHMETAFILE;
typedef struct  tagRemHBITMAP {
	unsigned long cbData;
	unsigned char data[1];
}	RemHBITMAP;
typedef struct  tagRemHPALETTE {
	unsigned long cbData;
	unsigned char data[1];
}	RemHPALETTE;
typedef struct  tagRemBRUSH {
	unsigned long cbData;
	unsigned char data[1];
}	RemHBRUSH;


















typedef struct _numberfmt {
	UINT NumDigits;
	UINT LeadingZero;
	UINT Grouping;
	LPTSTR lpDecimalSep;
	LPTSTR lpThousandSep;
	UINT NegativeOrder;
} NUMBERFMT;
typedef struct _OFSTRUCT {
	BYTE cBytes;
	BYTE fFixedDisk;
	WORD nErrCode;
	WORD Reserved1;
	WORD Reserved2;
	CHAR szPathName[128];
} OFSTRUCT,*LPOFSTRUCT;
typedef struct tagOFN {
	DWORD lStructSize;
	HWND hwndOwner;
	HINSTANCE hInstance;
	LPCTSTR lpstrFilter;
	LPTSTR lpstrCustomFilter;
	DWORD nMaxCustFilter;
	DWORD nFilterIndex;
	LPTSTR lpstrFile;
	DWORD nMaxFile;
	LPTSTR lpstrFileTitle;
	DWORD nMaxFileTitle;
	LPCTSTR lpstrInitialDir;
	LPCTSTR lpstrTitle;
	DWORD Flags;
	WORD nFileOffset;
	WORD nFileExtension;
	LPCTSTR lpstrDefExt;
	DWORD lCustData;
	LPOFNHOOKPROC lpfnHook;
	LPCTSTR lpTemplateName;
} OPENFILENAME,*LPOPENFILENAME;
typedef struct _OFNOTIFY {
	NMHDR hdr;
	LPOPENFILENAME lpOFN;
	LPTSTR pszFile;
} OFNOTIFY,*LPOFNOTIFY;
typedef struct _OSVERSIONINFO {
	DWORD dwOSVersionInfoSize;
	DWORD dwMajorVersion;
	DWORD dwMinorVersion;
	DWORD dwBuildNumber;
	DWORD dwPlatformId;
	TCHAR szCSDVersion[128];
} OSVERSIONINFO,*POSVERSIONINFO,*LPOSVERSIONINFO;
typedef struct tagTEXTMETRIC {
	LONG tmHeight;
	LONG tmAscent;
	LONG tmDescent;
	LONG tmInternalLeading;
	LONG tmExternalLeading;
	LONG tmAveCharWidth;
	LONG tmMaxCharWidth;
	LONG tmWeight;
	LONG tmOverhang;
	LONG tmDigitizedAspectX;
	LONG tmDigitizedAspectY;
	BCHAR tmFirstChar;
	BCHAR tmLastChar;
	BCHAR tmDefaultChar;
	BCHAR tmBreakChar;
	BYTE tmItalic;
	BYTE tmUnderlined;
	BYTE tmStruckOut;
	BYTE tmPitchAndFamily;
	BYTE tmCharSet;
	BYTE pad1;
	BYTE pad2;
	BYTE pad3;
} TEXTMETRIC,*LPTEXTMETRIC;
typedef int (_stdcall *OLDFONTENUMPROC)(LOGFONT *,TEXTMETRIC *,DWORD,LPARAM);
typedef struct tagTEXTMETRIC *PTEXTMETRIC;
typedef struct tagTEXTMETRICW {
	LONG	tmHeight;
	LONG	tmAscent;
	LONG	tmDescent;
	LONG	tmInternalLeading;
	LONG	tmExternalLeading;
	LONG	tmAveCharWidth;
	LONG	tmMaxCharWidth;
	LONG	tmWeight;
	LONG	tmOverhang;
	LONG	tmDigitizedAspectX;
	LONG	tmDigitizedAspectY;
	WCHAR	tmFirstChar;
	WCHAR	tmLastChar;
	WCHAR	tmDefaultChar;
	WCHAR	tmBreakChar;
	BYTE	tmItalic;
	BYTE	tmUnderlined;
	BYTE	tmStruckOut;
	BYTE	tmPitchAndFamily;
	BYTE	tmCharSet;
} TEXTMETRICW,*PTEXTMETRICW,*NPTEXTMETRICW,*LPTEXTMETRICW;
typedef struct _OUTLINETEXTMETRIC {
	UINT otmSize;
	TEXTMETRIC otmTextMetrics;
	BYTE otmFiller;
	PANOSE otmPanoseNumber;
	UINT otmfsSelection;
	UINT otmfsType;
	int otmsCharSlopeRise;
	int otmsCharSlopeRun;
	int otmItalicAngle;
	UINT otmEMSquare;
	int otmAscent;
	int otmDescent;
	UINT otmLineGap;
	UINT otmsCapEmHeight;
	UINT otmsXHeight;
	RECT otmrcFontBox;
	int otmMacAscent;
	int otmMacDescent;
	UINT otmMacLineGap;
	UINT otmusMinimumPPEM;
	POINT otmptSubscriptSize;
	POINT otmptSubscriptOffset;
	POINT otmptSuperscriptSize;
	POINT otmptSuperscriptOffset;
	UINT otmsStrikeoutSize;
	int otmsStrikeoutPosition;
	int otmsUnderscoreSize;
	int otmsUnderscorePosition;
	PSTR otmpFamilyName;
	PSTR otmpFaceName;
	PSTR otmpStyleName;
	PSTR otmpFullName;
} OUTLINETEXTMETRIC,*LPOUTLINETEXTMETRIC;
typedef struct _OVERLAPPED {
	DWORD Internal;
	DWORD InternalHigh;
	DWORD Offset;
	DWORD OffsetHigh;
	HANDLE hEvent;
} OVERLAPPED,*LPOVERLAPPED;
typedef struct tagPSD {
	DWORD lStructSize;
	HWND hwndOwner;
	HGLOBAL hDevMode;
	HGLOBAL hDevNames;
	DWORD Flags;
	POINT ptPaperSize;
	RECT rtMinMargin;
	RECT rtMargin;
	HINSTANCE hInstance;
	LPARAM lCustData;
	LPPAGESETUPHOOK lpfnPageSetupHook;
	LPPAGEPAINTHOOK lpfnPagePaintHook;
	LPCTSTR lpPageSetupTemplateName;
	HGLOBAL hPageSetupTemplate;
} PAGESETUPDLG,*LPPAGESETUPDLG;
typedef struct tagPAINTSTRUCT {
	HDC hdc;
	BOOL fErase;
	RECT rcPaint;
	BOOL fRestore;
	BOOL fIncUpdate;
	BYTE rgbReserved[32];
} PAINTSTRUCT,*LPPAINTSTRUCT;
typedef struct _paraformat {
	UINT cbSize;
	DWORD dwMask;
	WORD wNumbering;
	WORD wReserved;
	LONG dxStartIndent;
	LONG dxRightIndent;
	LONG dxOffset;
	WORD wAlignment;
	SHORT cTabCount;
	LONG rgxTabs[32];
} PARAFORMAT;
typedef struct _POLYTEXT {
	int x;
	int y;
	UINT n;
	LPCTSTR lpstr;
	UINT uiFlags;
	RECT rcl;
	int *pdx;
} POLYTEXT;
typedef struct _PORT_INFO_1 {
	LPTSTR pName;
} PORT_INFO_1;
typedef struct _PORT_INFO_2 {
	LPSTR pPortName;
	LPSTR pMonitorName;
	LPSTR pDescription;
	DWORD fPortType;
	DWORD Reserved;
} PORT_INFO_2;
typedef struct tagPD {
	DWORD lStructSize;
	HWND hwndOwner;
	HANDLE hDevMode;
	HANDLE hDevNames;
	HDC hDC;
	DWORD Flags;
	WORD nFromPage;
	WORD nToPage;
	WORD nMinPage;
	WORD nMaxPage;
	WORD nCopies;
	HINSTANCE hInstance;
	DWORD lCustData;
	LPPRINTHOOKPROC lpfnPrintHook;
	LPSETUPHOOKPROC lpfnSetupHook;
	LPCTSTR lpPrintTemplateName;
	LPCTSTR lpSetupTemplateName;
	HANDLE hPrintTemplate;
	HANDLE hSetupTemplate;
} PRINTDLG,*LPPRINTDLG;
typedef struct _PRINTER_DEFAULTS {
	LPTSTR pDatatype;
	LPDEVMODE pDevMode;
	ACCESS_MASK DesiredAccess;
} PRINTER_DEFAULTS;
typedef struct _PRINTPROCESSOR_INFO_1 {
	LPTSTR pName;
} PRINTPROCESSOR_INFO_1;
typedef struct _PRIVILEGE_SET {
	DWORD PrivilegeCount;
	DWORD Control;
	LUID_AND_ATTRIBUTES Privilege[1];
} PRIVILEGE_SET,*PPRIVILEGE_SET,*LPPRIVILEGE_SET;
typedef struct _PROCESS_HEAP_ENTRY {
	PVOID lpData;
	DWORD cbData;
	BYTE cbOverhead;
	BYTE iRegionIndex;
	WORD wFlags;
	DWORD dwCommittedSize;
	DWORD dwUnCommittedSize;
	LPVOID lpFirstBlock;
	LPVOID lpLastBlock;
	HANDLE hMem;
} PROCESS_HEAP_ENTRY,*LPPROCESS_HEAP_ENTRY;
typedef struct _PROCESS_INFORMATION {
	HANDLE hProcess;
	HANDLE hThread;
	DWORD dwProcessId;
	DWORD dwThreadId;
} PROCESS_INFORMATION,*LPPROCESS_INFORMATION;
typedef PROCESS_INFORMATION *PPROCESS_INFORMATION;
typedef UINT(_stdcall * LPFNPSPCALLBACK) (HWND,UINT,LPVOID);
typedef struct _PROPSHEETPAGE {
	DWORD dwSize;
	DWORD dwFlags;
	HINSTANCE hInstance;
	union {
		LPCTSTR pszTemplate;
		LPCDLGTEMPLATE pResource;
	};
	union {
		HICON hIcon;
		LPCTSTR pszIcon;
	};
	LPCTSTR pszTitle;
	DLGPROC pfnDlgProc;
	LPARAM lParam;
	LPFNPSPCALLBACK pfnCallback;
	UINT *pcRefParent;
} PROPSHEETPAGE,*LPPROPSHEETPAGE;
typedef const PROPSHEETPAGE *LPCPROPSHEETPAGE;
typedef struct _PSP *HPROPSHEETPAGE;
typedef struct _PROPSHEETHEADER {
	DWORD dwSize;
	DWORD dwFlags;
	HWND hwndParent;
	HINSTANCE hInstance;
	union {
		HICON hIcon;
		LPCTSTR pszIcon;
	};
	LPCTSTR pszCaption;
	UINT nPages;
	union {
		UINT nStartPage;
		LPCTSTR pStartPage;
	};
	union {
		LPCPROPSHEETPAGE ppsp;
		HPROPSHEETPAGE *phpage;
	};
	PFNPROPSHEETCALLBACK pfnCallback;
} PROPSHEETHEADER,*LPPROPSHEETHEADER;
typedef const PROPSHEETHEADER *LPCPROPSHEETHEADER;

typedef BOOL(_stdcall * LPFNADDPROPSHEETPAGE) (HPROPSHEETPAGE,LPARAM);
typedef
BOOL(_stdcall * LPFNADDPROPSHEETPAGES) (LPVOID,
										LPFNADDPROPSHEETPAGE,
										LPARAM);
typedef struct _PROTOCOL_INFO {
	DWORD dwServiceFlags;
	INT iAddressFamily;
	INT iMaxSockAddr;
	INT iMinSockAddr;
	INT iSocketType;
	INT iProtocol;
	DWORD dwMessageSize;
	LPTSTR lpProtocol;
} PROTOCOL_INFO;
typedef struct _PROVIDOR_INFO_1 {
	LPTSTR pName;
	LPTSTR pEnvironment;
	LPTSTR pDLLName;
} PROVIDOR_INFO_1;
typedef struct _PSHNOTIFY {
	NMHDR hdr;
	LPARAM lParam;
} PSHNOTIFY,*LPPSHNOTIFY;
typedef struct _punctuation {
	UINT iSize;
	LPSTR szPunctuation;
} PUNCTUATION;
typedef struct _QUERY_SERVICE_CONFIG {
	DWORD dwServiceType;
	DWORD dwStartType;
	DWORD dwErrorControl;
	LPTSTR lpBinaryPathName;
	LPTSTR lpLoadOrderGroup;
	DWORD dwTagId;
	LPTSTR lpDependencies;
	LPTSTR lpServiceStartName;
	LPTSTR lpDisplayName;
} QUERY_SERVICE_CONFIG,*LPQUERY_SERVICE_CONFIG;
typedef struct _QUERY_SERVICE_LOCK_STATUS {
	DWORD fIsLocked;
	LPTSTR lpLockOwner;
	DWORD dwLockDuration;
} QUERY_SERVICE_LOCK_STATUS,*LPQUERY_SERVICE_LOCK_STATUS;
typedef struct _RASAMB {
	DWORD dwSize;
	DWORD dwError;
	TCHAR szNetBiosError[16 + 1];
	BYTE bLana;
} RASAMB;
typedef struct _RASTERIZER_STATUS {
	short nSize;
	short wFlags;
	short nLanguageID;
} RASTERIZER_STATUS,*LPRASTERIZER_STATUS;
typedef struct _REMOTE_NAME_INFO {
	LPTSTR lpUniversalName;
	LPTSTR lpConnectionName;
	LPTSTR lpRemainingPath;
} REMOTE_NAME_INFO;
typedef struct _repastespecial {
	DWORD dwAspect;
	DWORD dwParam;
} REPASTESPECIAL;
typedef struct _reqresize {
	NMHDR nmhdr;
	RECT rc;
} REQRESIZE;
typedef struct _RGNDATAHEADER {
	DWORD dwSize;
	DWORD iType;
	DWORD nCount;
	DWORD nRgnSize;
	RECT rcBound;
} RGNDATAHEADER;
typedef struct _RGNDATA {
	RGNDATAHEADER rdh;
	char Buffer[1];
} RGNDATA,*LPRGNDATA;
typedef struct tagSCROLLINFO {
	UINT cbSize;
	UINT fMask;
	int nMin;
	int nMax;
	UINT nPage;
	int nPos;
	int nTrackPos;
} SCROLLINFO,*LPSCROLLINFO;
typedef SCROLLINFO const *LPCSCROLLINFO;
typedef struct _SECURITY_ATTRIBUTES {
	DWORD nLength;
	LPVOID lpSecurityDescriptor;
	BOOL bInheritHandle;
} SECURITY_ATTRIBUTES,*LPSECURITY_ATTRIBUTES;
typedef DWORD SECURITY_INFORMATION,*PSECURITY_INFORMATION;
typedef struct _selchange {
	NMHDR nmhdr;
	CHARRANGE chrg;
	WORD seltyp;
} SELCHANGE;
typedef struct tagSERIALKEYS {
	DWORD cbSize;
	DWORD dwFlags;
	LPSTR lpszActivePort;
	LPSTR lpszPort;
	DWORD iBaudRate;
	DWORD iPortState;
} SERIALKEYS,*LPSERIALKEYS;
typedef struct _SERVICE_TABLE_ENTRY {
	LPTSTR lpServiceName;
	LPSERVICE_MAIN_FUNCTION lpServiceProc;
} SERVICE_TABLE_ENTRY,*LPSERVICE_TABLE_ENTRY;
typedef struct _SERVICE_TYPE_VALUE_ABS {
	DWORD dwNameSpace;
	DWORD dwValueType;
	DWORD dwValueSize;
	LPTSTR lpValueName;
	PVOID lpValue;
} SERVICE_TYPE_VALUE_ABS;
typedef struct _SERVICE_TYPE_INFO_ABS {
	LPTSTR lpTypeName;
	DWORD dwValueCount;
	SERVICE_TYPE_VALUE_ABS Values[1];
} SERVICE_TYPE_INFO_ABS;
typedef struct _SESSION_BUFFER {
	UCHAR lsn;
	UCHAR state;
	UCHAR local_name[16];
	UCHAR remote_name[16];
	UCHAR rcvs_outstanding;
	UCHAR sends_outstanding;
} SESSION_BUFFER;
typedef struct _SESSION_HEADER {
	UCHAR sess_name;
	UCHAR num_sess;
	UCHAR rcv_dg_outstanding;
	UCHAR rcv_any_outstanding;
} SESSION_HEADER;
typedef enum tagSHCONTF {
	SHCONTF_FOLDERS = 32, SHCONTF_NONFOLDERS = 64, SHCONTF_INCLUDEHIDDEN = 128,
} SHCONTF;
typedef WORD FILEOP_FLAGS;
typedef enum tagSHGDN {
	SHGDN_NORMAL = 0, SHGDN_INFOLDER = 1, SHGDN_FORPARSING = 0x8000,
} SHGNO;
typedef struct _SID_AND_ATTRIBUTES {
	PSID Sid;
	DWORD Attributes;
} SID_AND_ATTRIBUTES;
typedef SID_AND_ATTRIBUTES SID_AND_ATTRIBUTES_ARRAY[1];
typedef SID_AND_ATTRIBUTES_ARRAY *PSID_AND_ATTRIBUTES_ARRAY;
typedef struct _SINGLE_LIST_ENTRY {
	struct _SINGLE_LIST_ENTRY *Next;
} SINGLE_LIST_ENTRY;
typedef struct tagSOUNDSENTRY {
	UINT cbSize;
	DWORD dwFlags;
	DWORD iFSTextEffect;
	DWORD iFSTextEffectMSec;
	DWORD iFSTextEffectColorBits;
	DWORD iFSGrafEffect;
	DWORD iFSGrafEffectMSec;
	DWORD iFSGrafEffectColor;
	DWORD iWindowsEffect;
	DWORD iWindowsEffectMSec;
	LPTSTR lpszWindowsEffectDLL;
	DWORD iWindowsEffectOrdinal;
} SOUNDSENTRY,*LPSOUNDSENTRY;
typedef struct _STARTUPINFO {
	DWORD cb;
	LPTSTR lpReserved;
	LPTSTR lpDesktop;
	LPTSTR lpTitle;
	DWORD dwX;
	DWORD dwY;
	DWORD dwXSize;
	DWORD dwYSize;
	DWORD dwXCountChars;
	DWORD dwYCountChars;
	DWORD dwFillAttribute;
	DWORD dwFlags;
	WORD wShowWindow;
	WORD cbReserved2;
	LPBYTE lpReserved2;
	HANDLE hStdInput;
	HANDLE hStdOutput;
	HANDLE hStdError;
} STARTUPINFO,*LPSTARTUPINFO;
typedef struct tagSTICKYKEYS {
	DWORD cbSize;
	DWORD dwFlags;
} STICKYKEYS,*LPSTICKYKEYS;
typedef struct _STRRET {
	UINT uType;
	union {
		LPWSTR pOleStr;
		UINT uOffset;
		char cStr[260];
	} ;
} STRRET,*LPSTRRET;
typedef struct _tagSTYLEBUF {
	DWORD dwStyle;
	CHAR szDescription[32];
} STYLEBUF,*LPSTYLEBUF;
typedef struct tagSTYLESTRUCT {
	DWORD styleOld;
	DWORD styleNew;
} STYLESTRUCT,*LPSTYLESTRUCT;
typedef struct _SYSTEM_AUDIT_ACE {
	ACE_HEADER Header;
	ACCESS_MASK Mask;
	DWORD SidStart;
} SYSTEM_AUDIT_ACE;
typedef struct _SYSTEM_INFO {
	WORD wProcessorArchitecture;
	WORD wReserved;
	DWORD dwPageSize;
	LPVOID lpMinimumApplicationAddress;
	LPVOID lpMaximumApplicationAddress;
	DWORD dwActiveProcessorMask;
	DWORD dwNumberOfProcessors;
	DWORD dwProcessorType;
	DWORD dwAllocationGranularity;
	WORD wProcessorLevel;
	WORD wProcessorRevision;
} SYSTEM_INFO,*LPSYSTEM_INFO;
typedef struct _SYSTEM_POWER_STATUS {
	BYTE ACLineStatus;
	BYTE BatteryFlag;
	BYTE BatteryLifePercent;
	BYTE Reserved1;
	DWORD BatteryLifeTime;
	DWORD BatteryFullLifeTime;
} SYSTEM_POWER_STATUS;
typedef struct SYSTEM_POWER_STATUS *LPSYSTEM_POWER_STATUS;
typedef struct _TAPE_ERASE {
	ULONG Type;
} TAPE_ERASE;
typedef struct _TAPE_GET_DRIVE_PARAMETERS {
	BOOLEAN ECC;
	BOOLEAN Compression;
	BOOLEAN DataPadding;
	BOOLEAN ReportSetmarks;
	ULONG DefaultBlockSize;
	ULONG MaximumBlockSize;
	ULONG MinimumBlockSize;
	ULONG MaximumPartitionCount;
	ULONG FeaturesLow;
	ULONG FeaturesHigh;
	ULONG EOTWarningZoneSize;
} TAPE_GET_DRIVE_PARAMETERS;
typedef struct _TAPE_GET_MEDIA_PARAMETERS {
	LARGE_INTEGER Capacity;
	LARGE_INTEGER Remaining;
	DWORD BlockSize;
	DWORD PartitionCount;
	BOOLEAN WriteProtected;
} TAPE_GET_MEDIA_PARAMETERS;
typedef struct _TAPE_GET_POSITION {
	ULONG Type;
	ULONG Partition;
	ULONG OffsetLow;
	ULONG OffsetHigh;
} TAPE_GET_POSITION;
typedef struct _TAPE_PREPARE {
	ULONG Operation;
} TAPE_PREPARE;
typedef struct _TAPE_SET_DRIVE_PARAMETERS {
	BOOLEAN ECC;
	BOOLEAN Compression;
	BOOLEAN DataPadding;
	BOOLEAN ReportSetmarks;
	ULONG EOTWarningZoneSize;
} TAPE_SET_DRIVE_PARAMETERS;
typedef struct _TAPE_SET_MEDIA_PARAMETERS {
	ULONG BlockSize;
} TAPE_SET_MEDIA_PARAMETERS;
typedef struct _TAPE_SET_POSITION {
	ULONG Method;
	ULONG Partition;
	ULONG OffsetLow;
	ULONG OffsetHigh;
} TAPE_SET_POSITION;
typedef struct _TAPE_WRITE_MARKS {
	ULONG Type;
	ULONG Count;
} TAPE_WRITE_MARKS;
typedef struct {
	HINSTANCE hInst;
	UINT nID;
} TBADDBITMAP,*LPTBADDBITMAP;
typedef struct _TBBUTTON {
	int iBitmap;
	int idCommand;
	BYTE fsState;
	BYTE fsStyle;
	BYTE bReserved[2];
	DWORD dwData;
	int iString;
} TBBUTTON,*PTBBUTTON,*LPTBBUTTON;
typedef const TBBUTTON *LPCTBBUTTON;
typedef struct {
	NMHDR hdr;
	int iItem;
	TBBUTTON tbButton;
	int cchText;
	LPTSTR pszText;
} TBNOTIFY,*LPTBNOTIFY;
typedef struct {
	HKEY hkr;
	LPCTSTR pszSubKey;
	LPCTSTR pszValueName;
} TBSAVEPARAMS;
typedef struct _TC_HITTESTINFO {
	POINT pt;
	UINT flags;
} TC_HITTESTINFO;
typedef struct _TC_ITEM {
	UINT mask;
	UINT lpReserved1;
	UINT lpReserved2;
	LPTSTR pszText;
	int cchTextMax;
	int iImage;
	LPARAM lParam;
} TC_ITEM;
typedef struct _TC_ITEMHEADER {
	UINT mask;
	UINT lpReserved1;
	UINT lpReserved2;
	LPTSTR pszText;
	int cchTextMax;
	int iImage;
} TC_ITEMHEADER;
typedef struct _TC_KEYDOWN {
	NMHDR hdr;
	WORD wVKey;
	UINT flags;
} TC_KEYDOWN;
typedef struct _textrange {
	CHARRANGE chrg;
	LPSTR lpstrText;
} TEXTRANGE;
typedef struct _TIME_ZONE_INFORMATION {
	LONG Bias;
	WCHAR StandardName[32];
	SYSTEMTIME StandardDate;
	LONG StandardBias;
	WCHAR DaylightName[32];
	SYSTEMTIME DaylightDate;
	LONG DaylightBias;
} TIME_ZONE_INFORMATION,*LPTIME_ZONE_INFORMATION;
typedef struct tagTOGGLEKEYS {
	DWORD cbSize;
	DWORD dwFlags;
} TOGGLEKEYS;
typedef struct _TOKEN_SOURCE {
	CHAR SourceName[8];
	LUID SourceIdentifier;
} TOKEN_SOURCE;
typedef struct _TOKEN_CONTROL {
	LUID TokenId;
	LUID AuthenticationId;
	LUID ModifiedId;
	TOKEN_SOURCE TokenSource;
} TOKEN_CONTROL;
typedef struct _TOKEN_DEFAULT_DACL {
	PACL DefaultDacl;
} TOKEN_DEFAULT_DACL;
typedef struct _TOKEN_GROUPS {
	DWORD GroupCount;
	SID_AND_ATTRIBUTES Groups[1];
} TOKEN_GROUPS,*PTOKEN_GROUPS,*LPTOKEN_GROUPS;
typedef struct _TOKEN_OWNER {
	PSID Owner;
} TOKEN_OWNER;
typedef struct _TOKEN_PRIMARY_GROUP {
	PSID PrimaryGroup;
} TOKEN_PRIMARY_GROUP;
typedef struct _TOKEN_PRIVILEGES {
	DWORD PrivilegeCount;
	LUID_AND_ATTRIBUTES Privileges[1];
} TOKEN_PRIVILEGES,*PTOKEN_PRIVILEGES,*LPTOKEN_PRIVILEGES;
typedef struct _TOKEN_STATISTICS {
	LUID TokenId;
	LUID AuthenticationId;
	LARGE_INTEGER ExpirationTime;
	TOKEN_TYPE TokenType;
	SECURITY_IMPERSONATION_LEVEL ImpersonationLevel;
	DWORD DynamicCharged;
	DWORD DynamicAvailable;
	DWORD GroupCount;
	DWORD PrivilegeCount;
	LUID ModifiedId;
} TOKEN_STATISTICS;
typedef struct _TOKEN_USER {
	SID_AND_ATTRIBUTES User;
} TOKEN_USER;
typedef struct {
	UINT cbSize;
	UINT uFlags;
	HWND hwnd;
	UINT uId;
	RECT rect;
	HINSTANCE hinst;
	LPTSTR lpszText;
} TOOLINFO,*PTOOLINFO,*LPTOOLINFO;
typedef struct {
	NMHDR hdr;
	LPTSTR lpszText;
	char szText[80];
	HINSTANCE hinst;
	UINT uFlags;
} TOOLTIPTEXT,*LPTOOLTIPTEXT;
typedef struct tagTPMPARAMS {
	UINT cbSize;
	RECT rcExclude;
} TPMPARAMS,*LPTPMPARAMS;
typedef struct _TT_HITTESTINFO {
	HWND hwnd;
	POINT pt;
	TOOLINFO ti;
} TTHITTESTINFO,*LPHITTESTINFO;
typedef struct tagTTPOLYCURVE {
	WORD wType;
	WORD cpfx;
	POINTFX apfx[1];
} TTPOLYCURVE,*LPTTPOLYCURVE;
typedef struct _TTPOLYGONHEADER {
	DWORD cb;
	DWORD dwType;
	POINTFX pfxStart;
} TTPOLYGONHEADER,*LPTTPOLYGONHEADER;
typedef struct _TV_DISPINFO {
	NMHDR hdr;
	TV_ITEM item;
} TV_DISPINFO;
typedef struct _TVHITTESTINFO {
	POINT pt;
	UINT flags;
	HTREEITEM hItem;
} TV_HITTESTINFO,*LPTV_HITTESTINFO;
typedef struct _TV_INSERTSTRUCT {
	HTREEITEM hParent;
	HTREEITEM hInsertAfter;
	TV_ITEM item;
} TV_INSERTSTRUCT,*LPTV_INSERTSTRUCT;
typedef struct _TV_KEYDOWN {
	NMHDR hdr;
	WORD wVKey;
	UINT flags;
} TV_KEYDOWN;
typedef struct _TV_SORTCB {
	HTREEITEM hParent;
	PFNTVCOMPARE lpfnCompare;
	LPARAM lParam;
} TV_SORTCB,*LPTV_SORTCB;
typedef struct {
	UINT nSec;
	UINT nInc;
} UDACCEL;
typedef struct _ULARGE_INTEGER {
	DWORD LowPart;
	DWORD HighPart;
} ULARGE_INTEGER,*PULARGE_INTEGER;
typedef struct _UNIVERSAL_NAME_INFO {
	LPTSTR lpUniversalName;
} UNIVERSAL_NAME_INFO;
typedef struct tagUSEROBJECTFLAGS {
	BOOL fInherit;
	BOOL fReserved;
	DWORD dwFlags;
} USEROBJECTFLAGS;
typedef struct value_ent {
	LPTSTR ve_valuename;
	DWORD ve_valuelen;
	DWORD ve_valueptr;
	DWORD ve_type;
} VALENT,*PVALENT;
typedef struct _WIN32_FIND_DATA {
	DWORD dwFileAttributes;
	FILETIME ftCreationTime;
	FILETIME ftLastAccessTime;
	FILETIME ftLastWriteTime;
	DWORD nFileSizeHigh;
	DWORD nFileSizeLow;
	DWORD dwReserved0;
	DWORD dwReserved1;
	TCHAR cFileName[260];
	TCHAR cAlternateFileName[14];
	WORD dummy;
} WIN32_FIND_DATA,*LPWIN32_FIND_DATA;
typedef struct _WIN32_STREAM_ID {
	DWORD dwStreamId;
	DWORD dwStreamAttributes;
	LARGE_INTEGER Size;
	DWORD dwStreamNameSize;
	WCHAR *cStreamName;
} WIN32_STREAM_ID;
typedef struct _WINDOWPLACEMENT {
	UINT length;
	UINT flags;
	UINT showCmd;
	POINT ptMinPosition;
	POINT ptMaxPosition;
	RECT rcNormalPosition;
} WINDOWPLACEMENT, *LPWINDOWPLACEMENT,*PWINDOWPLACEMENT;
typedef struct _WNDCLASS {
	UINT style;
	WNDPROC lpfnWndProc;
	int cbClsExtra;
	int cbWndExtra;
	HANDLE hInstance;
	HICON hIcon;
	HCURSOR hCursor;
	HBRUSH hbrBackground;
	LPCTSTR lpszMenuName;
	LPCTSTR lpszClassName;
} WNDCLASS,*LPWNDCLASS,*PWNDCLASS;
typedef struct _WNDCLASSEX {
	UINT cbSize;
	UINT style;
	WNDPROC lpfnWndProc;
	int cbClsExtra;
	int cbWndExtra;
	HANDLE hInstance;
	HICON hIcon;
	HCURSOR hCursor;
	HBRUSH hbrBackground;
	LPCTSTR lpszMenuName;
	LPCTSTR lpszClassName;
	HICON hIconSm;
} WNDCLASSEX,*LPWNDCLASSEX;
typedef struct _CONNECTDLGSTRUCT {
	DWORD cbStructure;
	HWND hwndOwner;
	LPNETRESOURCE lpConnRes;
	DWORD dwFlags;
	DWORD dwDevNum;
} CONNECTDLGSTRUCT,*LPCONNECTDLGSTRUCT;
typedef struct _DISCDLGSTRUCT {
	DWORD cbStructure;
	HWND hwndOwner;
	LPTSTR lpLocalName;
	LPTSTR lpRemoteName;
	DWORD dwFlags;
} DISCDLGSTRUCT,*LPDISCDLGSTRUCT;
typedef struct _NETINFOSTRUCT {
	DWORD cbStructure;
	DWORD dwProviderVersion;
	DWORD dwStatus;
	DWORD dwCharacteristics;
	DWORD dwHandle;
	WORD wNetType;
	DWORD dwPrinters;
	DWORD dwDrives;
} NETINFOSTRUCT,*LPNETINFOSTRUCT;
typedef struct _NETCONNECTINFOSTRUCT {
	DWORD cbStructure;
	DWORD dwFlags;
	DWORD dwSpeed;
	DWORD dwDelay;
	DWORD dwOptDataSize;
} NETCONNECTINFOSTRUCT,*LPNETCONNECTINFOSTRUCT;
typedef enum tagCLSCTX {CLSCTX_INPROC_SERVER=1,CLSCTX_INPROC_HANDLER=2,
	CLSCTX_LOCAL_SERVER=4,CLSCTX_INPROC_SERVER16=8} CLSCTX;
typedef enum tagMSHLFLAGS {MSHLFLAGS_NORMAL=0,MSHLFLAGS_TABLESTRONG= 1,
	MSHLFLAGS_TABLEWEAK=2} MSHLFLAGS;
typedef enum tagMSHCTX {MSHCTX_LOCAL=0,MSHCTX_NOSHAREDMEM=1,
	MSHCTX_DIFFERENTMACHINE=2,MSHCTX_INPROC=3} MSHCTX;
typedef enum tagDVASPECT {DVASPECT_CONTENT=1,DVASPECT_THUMBNAIL=2,
        DVASPECT_ICON=4,DVASPECT_DOCPRINT=8} DVASPECT;
typedef enum tagSTGC {STGC_DEFAULT=0,STGC_OVERWRITE=1,
	STGC_ONLYIFCURRENT=2,STGC_DANGEROUSLYCOMMITMERELYTODISKCACHE=4}STGC;
typedef enum tagSTGMOVE {STGMOVE_MOVE=0,STGMOVE_COPY=1}STGMOVE;
typedef enum tagSTATFLAG {STATFLAG_DEFAULT= 0,STATFLAG_NONAME=1} STATFLAG;
typedef void *HCONTEXT;
































#line 9115 "C:\MATLAB7\sys\lcc\include\win.h"























































































































































































typedef struct _IMAGE_DOS_HEADER {
	WORD e_magic;
	WORD e_cblp;
	WORD e_cp;
	WORD e_crlc;
	WORD e_cparhdr;
	WORD e_minalloc;
	WORD e_maxalloc;
	WORD e_ss;
	WORD e_sp;
	WORD e_csum;
	WORD e_ip;
	WORD e_cs;
	WORD e_lfarlc;
	WORD e_ovno;
	WORD e_res[4];
	WORD e_oemid;
	WORD e_oeminfo;
	WORD e_res2[10];
	LONG e_lfanew;
} IMAGE_DOS_HEADER,*PIMAGE_DOS_HEADER;
typedef struct _IMAGE_OS2_HEADER {
	WORD ne_magic;
	CHAR ne_ver;
	CHAR ne_rev;
	WORD ne_enttab;
	WORD ne_cbenttab;
	LONG ne_crc;
	WORD ne_flags;
	WORD ne_autodata;
	WORD ne_heap;
	WORD ne_stack;
	LONG ne_csip;
	LONG ne_sssp;
	WORD ne_cseg;
	WORD ne_cmod;
	WORD ne_cbnrestab;
	WORD ne_segtab;
	WORD ne_rsrctab;
	WORD ne_restab;
	WORD ne_modtab;
	WORD ne_imptab;
	LONG ne_nrestab;
	WORD ne_cmovent;
	WORD ne_align;
	WORD ne_cres;
	BYTE ne_exetyp;
	BYTE ne_flagsothers;
	WORD ne_pretthunks;
	WORD ne_psegrefbytes;
	WORD ne_swaparea;
	WORD ne_expver;
} IMAGE_OS2_HEADER,*PIMAGE_OS2_HEADER;
typedef struct _IMAGE_VXD_HEADER {
	WORD e32_magic;
	BYTE e32_border;
	BYTE e32_worder;
	DWORD e32_level;
	WORD e32_cpu;
	WORD e32_os;
	DWORD e32_ver;
	DWORD e32_mflags;
	DWORD e32_mpages;
	DWORD e32_startobj;
	DWORD e32_eip;
	DWORD e32_stackobj;
	DWORD e32_esp;
	DWORD e32_pagesize;
	DWORD e32_lastpagesize;
	DWORD e32_fixupsize;
	DWORD e32_fixupsum;
	DWORD e32_ldrsize;
	DWORD e32_ldrsum;
	DWORD e32_objtab;
	DWORD e32_objcnt;
	DWORD e32_objmap;
	DWORD e32_itermap;
	DWORD e32_rsrctab;
	DWORD e32_rsrccnt;
	DWORD e32_restab;
	DWORD e32_enttab;
	DWORD e32_dirtab;
	DWORD e32_dircnt;
	DWORD e32_fpagetab;
	DWORD e32_frectab;
	DWORD e32_impmod;
	DWORD e32_impmodcnt;
	DWORD e32_impproc;
	DWORD e32_pagesum;
	DWORD e32_datapage;
	DWORD e32_preload;
	DWORD e32_nrestab;
	DWORD e32_cbnrestab;
	DWORD e32_nressum;
	DWORD e32_autodata;
	DWORD e32_debuginfo;
	DWORD e32_debuglen;
	DWORD e32_instpreload;
	DWORD e32_instdemand;
	DWORD e32_heapsize;
	BYTE e32_res3[12];
	DWORD e32_winresoff;
	DWORD e32_winreslen;
	WORD e32_devid;
	WORD e32_ddkver;
} IMAGE_VXD_HEADER,*PIMAGE_VXD_HEADER;
typedef struct _IMAGE_FILE_HEADER {
	WORD Machine;
	WORD NumberOfSections;
	DWORD TimeDateStamp;
	DWORD PointerToSymbolTable;
	DWORD NumberOfSymbols;
	WORD SizeOfOptionalHeader;
	WORD Characteristics;
} IMAGE_FILE_HEADER,*PIMAGE_FILE_HEADER;
typedef struct _IMAGE_DATA_DIRECTORY {
	DWORD VirtualAddress;
	DWORD Size;
} IMAGE_DATA_DIRECTORY,*PIMAGE_DATA_DIRECTORY;
typedef struct _IMAGE_OPTIONAL_HEADER {
	WORD Magic;
	BYTE MajorLinkerVersion;
	BYTE MinorLinkerVersion;
	DWORD SizeOfCode;
	DWORD SizeOfInitializedData;
	DWORD SizeOfUninitializedData;
	DWORD AddressOfEntryPoint;
	DWORD BaseOfCode;
	DWORD BaseOfData;
	DWORD ImageBase;
	DWORD SectionAlignment;
	DWORD FileAlignment;
	WORD MajorOperatingSystemVersion;
	WORD MinorOperatingSystemVersion;
	WORD MajorImageVersion;
	WORD MinorImageVersion;
	WORD MajorSubsystemVersion;
	WORD MinorSubsystemVersion;
	DWORD Win32VersionValue;
	DWORD SizeOfImage;
	DWORD SizeOfHeaders;
	DWORD CheckSum;
	WORD Subsystem;
	WORD DllCharacteristics;
	DWORD SizeOfStackReserve;
	DWORD SizeOfStackCommit;
	DWORD SizeOfHeapReserve;
	DWORD SizeOfHeapCommit;
	DWORD LoaderFlags;
	DWORD NumberOfRvaAndSizes;
	IMAGE_DATA_DIRECTORY DataDirectory[16];
} IMAGE_OPTIONAL_HEADER,*PIMAGE_OPTIONAL_HEADER;
typedef struct _IMAGE_ROM_OPTIONAL_HEADER {
	WORD Magic;
	BYTE MajorLinkerVersion;
	BYTE MinorLinkerVersion;
	DWORD SizeOfCode;
	DWORD SizeOfInitializedData;
	DWORD SizeOfUninitializedData;
	DWORD AddressOfEntryPoint;
	DWORD BaseOfCode;
	DWORD BaseOfData;
	DWORD BaseOfBss;
	DWORD GprMask;
	DWORD CprMask[4];
	DWORD GpValue;
} IMAGE_ROM_OPTIONAL_HEADER,*PIMAGE_ROM_OPTIONAL_HEADER;





typedef struct _IMAGE_NT_HEADERS {
	DWORD Signature;
	IMAGE_FILE_HEADER FileHeader;
	IMAGE_OPTIONAL_HEADER OptionalHeader;
} IMAGE_NT_HEADERS,*PIMAGE_NT_HEADERS;

typedef struct _IMAGE_ROM_HEADERS {
	IMAGE_FILE_HEADER FileHeader;
	IMAGE_ROM_OPTIONAL_HEADER OptionalHeader;
} IMAGE_ROM_HEADERS,*PIMAGE_ROM_HEADERS;
typedef struct _IMAGE_SECTION_HEADER {
	BYTE Name[8];
	union {
		DWORD PhysicalAddress;
		DWORD VirtualSize;
	} Misc;
	DWORD VirtualAddress;
	DWORD SizeOfRawData;
	DWORD PointerToRawData;
	DWORD PointerToRelocations;
	DWORD PointerToLinenumbers;
	WORD NumberOfRelocations;
	WORD NumberOfLinenumbers;
	DWORD Characteristics;
} IMAGE_SECTION_HEADER,*PIMAGE_SECTION_HEADER;
typedef struct _IMAGE_SYMBOL {
	union {
		BYTE ShortName[8];
		struct {
			DWORD Short;
			DWORD Long;
		} Name;
		PBYTE LongName[2];
	} N;
	DWORD Value;
	SHORT SectionNumber;
	WORD Type;
	BYTE StorageClass;
	BYTE NumberOfAuxSymbols;
} IMAGE_SYMBOL;
typedef IMAGE_SYMBOL *PIMAGE_SYMBOL;
typedef union _IMAGE_AUX_SYMBOL {
	struct {
		DWORD TagIndex;
		union {
			struct {
				WORD Linenumber;
				WORD Size;
			} LnSz;
			DWORD TotalSize;
		} Misc;
		union {
			struct {
				DWORD PointerToLinenumber;
				DWORD PointerToNextFunction;
			} Function;
			struct {
				WORD Dimension[4];
			} Array;
		} FcnAry;
		WORD TvIndex;
	} Sym;
	struct {
		BYTE Name[18];
	} File;
	struct {
		DWORD Length;
		WORD NumberOfRelocations;
		WORD NumberOfLinenumbers;
		DWORD CheckSum;
		SHORT Number;
		BYTE Selection;
	} Section;
} IMAGE_AUX_SYMBOL;
typedef IMAGE_AUX_SYMBOL *PIMAGE_AUX_SYMBOL;
typedef struct _IMAGE_RELOCATION {

	DWORD VirtualAddress;






	DWORD SymbolTableIndex;
	WORD Type;
} IMAGE_RELOCATION;
typedef IMAGE_RELOCATION *PIMAGE_RELOCATION;
typedef struct _IMAGE_BASE_RELOCATION {
	DWORD VirtualAddress;
	DWORD SizeOfBlock;
} IMAGE_BASE_RELOCATION,*PIMAGE_BASE_RELOCATION;
typedef struct _IMAGE_LINENUMBER {
	union {
		DWORD SymbolTableIndex;
		DWORD VirtualAddress;
	} Type;
	WORD Linenumber;
} IMAGE_LINENUMBER;
typedef IMAGE_LINENUMBER *PIMAGE_LINENUMBER;
typedef struct _IMAGE_ARCHIVE_MEMBER_HEADER {
	BYTE Name[16];
	BYTE Date[12];
	BYTE UserID[6];
	BYTE GroupID[6];
	BYTE Mode[8];
	BYTE Size[10];
	BYTE EndHeader[2];
} IMAGE_ARCHIVE_MEMBER_HEADER,*PIMAGE_ARCHIVE_MEMBER_HEADER;
typedef struct _IMAGE_EXPORT_DIRECTORY {
	DWORD Characteristics;
	DWORD TimeDateStamp;
	WORD MajorVersion;
	WORD MinorVersion;
	DWORD Name;
	DWORD Base;
	DWORD NumberOfFunctions;
	DWORD NumberOfNames;
	PDWORD *AddressOfFunctions;
	PDWORD *AddressOfNames;
	PWORD *AddressOfNameOrdinals;
} IMAGE_EXPORT_DIRECTORY,*PIMAGE_EXPORT_DIRECTORY;
typedef struct _IMAGE_IMPORT_BY_NAME {
	WORD Hint;
	BYTE Name[1];
} IMAGE_IMPORT_BY_NAME,*PIMAGE_IMPORT_BY_NAME;
typedef struct _IMAGE_THUNK_DATA {
	union {
		PBYTE ForwarderString;
		PDWORD Function;
		DWORD Ordinal;
		PIMAGE_IMPORT_BY_NAME AddressOfData;
	} u1;
} IMAGE_THUNK_DATA,*PIMAGE_THUNK_DATA;
typedef struct _IMAGE_IMPORT_DESCRIPTOR {
	union {
		DWORD Characteristics;
		PIMAGE_THUNK_DATA OriginalFirstThunk;
	} u1;
	DWORD TimeDateStamp;
	DWORD ForwarderChain;
	DWORD Name;
	PIMAGE_THUNK_DATA FirstThunk;
} IMAGE_IMPORT_DESCRIPTOR,*PIMAGE_IMPORT_DESCRIPTOR;
typedef struct _IMAGE_BOUND_IMPORT_DESCRIPTOR {
	DWORD TimeDateStamp;
	WORD OffsetModuleName;
	WORD NumberOfModuleForwarderRefs;
} IMAGE_BOUND_IMPORT_DESCRIPTOR,*PIMAGE_BOUND_IMPORT_DESCRIPTOR;
typedef struct _IMAGE_BOUND_FORWARDER_REF {
	DWORD TimeDateStamp;
	WORD OffsetModuleName;
	WORD Reserved;
} IMAGE_BOUND_FORWARDER_REF,*PIMAGE_BOUND_FORWARDER_REF;
typedef void (_stdcall *PIMAGE_TLS_CALLBACK)(PVOID,DWORD,PVOID);
typedef struct _IMAGE_TLS_DIRECTORY {
	DWORD StartAddressOfRawData;
	DWORD EndAddressOfRawData;
	PDWORD AddressOfIndex;
	PIMAGE_TLS_CALLBACK *AddressOfCallBacks;
	DWORD SizeOfZeroFill;
	DWORD Characteristics;
} IMAGE_TLS_DIRECTORY,*PIMAGE_TLS_DIRECTORY;
typedef struct _IMAGE_RESOURCE_DIRECTORY {
	DWORD Characteristics;
	DWORD TimeDateStamp;
	WORD MajorVersion;
	WORD MinorVersion;
	WORD NumberOfNamedEntries;
	WORD NumberOfIdEntries;
} IMAGE_RESOURCE_DIRECTORY,*PIMAGE_RESOURCE_DIRECTORY;
typedef struct _IMAGE_RESOURCE_DIRECTORY_ENTRY {
	union {
		struct {
			DWORD NameOffset:31;
			DWORD NameIsString:1;
		};
		DWORD Name;
		WORD Id;
	} u1;
	union {
		DWORD OffsetToData;
		struct {
			DWORD OffsetToDirectory:31;
			DWORD DataIsDirectory:1;
		};
	} u2;
} IMAGE_RESOURCE_DIRECTORY_ENTRY,*PIMAGE_RESOURCE_DIRECTORY_ENTRY;
typedef struct _IMAGE_RESOURCE_DIRECTORY_STRING {
	WORD Length;
	CHAR NameString[1];
} IMAGE_RESOURCE_DIRECTORY_STRING,*PIMAGE_RESOURCE_DIRECTORY_STRING;
typedef struct _IMAGE_RESOURCE_DIR_STRING_U {
	WORD Length;
	WCHAR NameString[1];
} IMAGE_RESOURCE_DIR_STRING_U,*PIMAGE_RESOURCE_DIR_STRING_U;
typedef struct _IMAGE_RESOURCE_DATA_ENTRY {
	DWORD OffsetToData;
	DWORD Size;
	DWORD CodePage;
	DWORD Reserved;
} IMAGE_RESOURCE_DATA_ENTRY,*PIMAGE_RESOURCE_DATA_ENTRY;
typedef struct _IMAGE_LOAD_CONFIG_DIRECTORY {
	DWORD Characteristics;
	DWORD TimeDateStamp;
	WORD MajorVersion;
	WORD MinorVersion;
	DWORD GlobalFlagsClear;
	DWORD GlobalFlagsSet;
	DWORD CriticalSectionDefaultTimeout;
	DWORD DeCommitFreeBlockThreshold;
	DWORD DeCommitTotalFreeThreshold;
	PVOID LockPrefixTable;
	DWORD MaximumAllocationSize;
	DWORD VirtualMemoryThreshold;
	DWORD ProcessHeapFlags;
	DWORD Reserved[4];
} IMAGE_LOAD_CONFIG_DIRECTORY,*PIMAGE_LOAD_CONFIG_DIRECTORY;
typedef struct _IMAGE_RUNTIME_FUNCTION_ENTRY {
	DWORD BeginAddress;
	DWORD EndAddress;
	PVOID ExceptionHandler;
	PVOID HandlerData;
	DWORD PrologEndAddress;
} IMAGE_RUNTIME_FUNCTION_ENTRY,*PIMAGE_RUNTIME_FUNCTION_ENTRY;
typedef struct _IMAGE_DEBUG_DIRECTORY {
	DWORD Characteristics;
	DWORD TimeDateStamp;
	WORD MajorVersion;
	WORD MinorVersion;
	DWORD Type;
	DWORD SizeOfData;
	DWORD AddressOfRawData;
	DWORD PointerToRawData;
} IMAGE_DEBUG_DIRECTORY,*PIMAGE_DEBUG_DIRECTORY;
typedef struct _IMAGE_COFF_SYMBOLS_HEADER {
	DWORD NumberOfSymbols;
	DWORD LvaToFirstSymbol;
	DWORD NumberOfLinenumbers;
	DWORD LvaToFirstLinenumber;
	DWORD RvaToFirstByteOfCode;
	DWORD RvaToLastByteOfCode;
	DWORD RvaToFirstByteOfData;
	DWORD RvaToLastByteOfData;
} IMAGE_COFF_SYMBOLS_HEADER,*PIMAGE_COFF_SYMBOLS_HEADER;




typedef struct _FPO_DATA {
	DWORD ulOffStart;
	DWORD cbProcSize;
	DWORD cdwLocals;
	WORD cdwParams;
	WORD cbProlog:8;
	WORD cbRegs:3;
	WORD fHasSEH:1;
	WORD fUseBP:1;
	WORD reserved:1;
	WORD cbFrame:2;
} FPO_DATA,*PFPO_DATA;

typedef struct _IMAGE_DEBUG_MISC {
	DWORD DataType;
	DWORD Length;
	BOOLEAN Unicode;
	BYTE Reserved[3];
	BYTE Data[1];
} IMAGE_DEBUG_MISC,*PIMAGE_DEBUG_MISC;
typedef struct _IMAGE_FUNCTION_ENTRY {
	DWORD StartingAddress;
	DWORD EndingAddress;
	DWORD EndOfPrologue;
} IMAGE_FUNCTION_ENTRY,*PIMAGE_FUNCTION_ENTRY;
typedef struct _IMAGE_SEPARATE_DEBUG_HEADER {
	WORD Signature;
	WORD Flags;
	WORD Machine;
	WORD Characteristics;
	DWORD TimeDateStamp;
	DWORD CheckSum;
	DWORD ImageBase;
	DWORD SizeOfImage;
	DWORD NumberOfSections;
	DWORD ExportedNamesSize;
	DWORD DebugDirectorySize;
	DWORD SectionAlignment;
	DWORD Reserved[2];
} IMAGE_SEPARATE_DEBUG_HEADER,*PIMAGE_SEPARATE_DEBUG_HEADER;
typedef int (_stdcall *ENUMMETAFILEPROC)(HDC,HANDLETABLE,METARECORD,int,LPARAM);
typedef int (_stdcall *ENHMETAFILEPROC) (HDC,HANDLETABLE,ENHMETARECORD,int,LPARAM);
typedef int (_stdcall *ENUMFONTSPROC) (LPLOGFONT,LPTEXTMETRIC,DWORD,LPARAM);
typedef int (_stdcall *FONTENUMPROC)(ENUMLOGFONT *,NEWTEXTMETRIC *,int,LPARAM);
typedef int (_stdcall *FONTENUMEXPROC)(ENUMLOGFONTEX *,NEWTEXTMETRICEX *,int,LPARAM);
typedef void(_stdcall *LPOVERLAPPED_COMPLETION_ROUTINE)(DWORD,DWORD,LPOVERLAPPED);
typedef int (_stdcall * ENHMFENUMPROC)(HDC,HANDLETABLE *,ENHMETARECORD *, int,LPARAM);
typedef struct _NT_TIB {
	struct _EXCEPTION_REGISTRATION_RECORD *ExceptionList;
	PVOID StackBase;
	PVOID StackLimit;
	PVOID SubSystemTib;
	union { PVOID FiberData; DWORD Version; };
	PVOID ArbitraryUserPointer;
	struct _NT_TIB *Self;
} NT_TIB;
typedef NT_TIB *PNT_TIB;





typedef struct tagHEAPLIST32 {
	DWORD dwSize;
	DWORD th32ProcessID;
	DWORD th32HeapID;
	DWORD dwFlags;
} HEAPLIST32;
typedef HEAPLIST32 *PHEAPLIST32;
typedef HEAPLIST32 *LPHEAPLIST32;
typedef struct tagHEAPENTRY32 {
	DWORD dwSize;
	HANDLE hHandle;
	DWORD dwAddress;
	DWORD dwBlockSize;
	DWORD dwFlags;
	DWORD dwLockCount;
	DWORD dwResvd;
	DWORD th32ProcessID;
	DWORD th32HeapID;
} HEAPENTRY32;
typedef HEAPENTRY32 *PHEAPENTRY32;
typedef HEAPENTRY32 *LPHEAPENTRY32;
typedef struct tagPROCESSENTRY32 {
	DWORD dwSize;
	DWORD cntUsage;
	DWORD th32ProcessID;
	DWORD th32DefaultHeapID;
	DWORD th32ModuleID;
	DWORD cntThreads;
	DWORD th32ParentProcessID;
	LONG pcPriClassBase;
	DWORD dwFlags;
	char szExeFile[260];
} PROCESSENTRY32;
typedef PROCESSENTRY32 *PPROCESSENTRY32;
typedef PROCESSENTRY32 *LPPROCESSENTRY32;
typedef struct tagTHREADENTRY32 {
	DWORD dwSize;
	DWORD cntUsage;
	DWORD th32ThreadID;
	DWORD th32OwnerProcessID;
	LONG tpBasePri;
	LONG tpDeltaPri;
	DWORD dwFlags;
} THREADENTRY32;
typedef THREADENTRY32 *PTHREADENTRY32;
typedef THREADENTRY32 *LPTHREADENTRY32;
typedef struct tagMODULEENTRY32 {
	DWORD dwSize;
	DWORD th32ModuleID;
	DWORD th32ProcessID;
	DWORD GlblcntUsage;
	DWORD ProccntUsage;
	BYTE *modBaseAddr;
	DWORD modBaseSize;
	HMODULE hModule;
	char szModule[255 + 1];
	char szExePath[260];
} MODULEENTRY32;
typedef MODULEENTRY32 *PMODULEENTRY32;
typedef MODULEENTRY32 *LPMODULEENTRY32;
typedef struct tagPIXELFORMATDESCRIPTOR {
	WORD	nSize;
	WORD	nVersion;
	DWORD	dwFlags;
	BYTE	iPixelType;
	BYTE	cColorBits;
	BYTE	cRedBits;
	BYTE	cRedShift;
	BYTE	cGreenBits;
	BYTE	cGreenShift;
	BYTE	cBlueBits;
	BYTE	cBlueShift;
	BYTE	cAlphaBits;
	BYTE	cAlphaShift;
	BYTE	cAccumBits;
	BYTE	cAccumRedBits;
	BYTE	cAccumGreenBits;
	BYTE	cAccumBlueBits;
	BYTE	cAccumAlphaBits;
	BYTE	cDepthBits;
	BYTE	cStencilBits;
	BYTE	cAuxBuffers;
	BYTE	iLayerType;
	BYTE	bReserved;
	DWORD	dwLayerMask;
	DWORD	dwVisibleMask;
	DWORD	dwDamageMask;
} PIXELFORMATDESCRIPTOR,*PPIXELFORMATDESCRIPTOR,*LPPIXELFORMATDESCRIPTOR;
typedef struct _WIN_CERTIFICATE {
	DWORD	dwLength;
	WORD	wRevision;
	WORD	wCertificateType;
	BYTE	bCertificate[1];
} WIN_CERTIFICATE, *LPWIN_CERTIFICATE;




typedef LPVOID WIN_TRUST_SUBJECT;
typedef struct _WIN_TRUST_ACTDATA_CONTEXT_WITH_SUBJECT {
	HANDLE	hClientToken;
	GUID	*SubjectType;
	WIN_TRUST_SUBJECT Subject;
} WIN_TRUST_ACTDATA_CONTEXT_WITH_SUBJECT, *LPWIN_TRUST_ACTDATA_CONTEXT_WITH_SUBJECT;
typedef struct _WIN_TRUST_ACTDATA_SUBJECT_ONLY {
	GUID	*SubjectType;
	WIN_TRUST_SUBJECT Subject;
} WIN_TRUST_ACTDATA_SUBJECT_ONLY, *LPWIN_TRUST_ACTDATA_SUBJECT_ONLY;




typedef struct _WIN_TRUST_SUBJECT_FILE {
	HANDLE  hFile; LPCWSTR lpPath;
} WIN_TRUST_SUBJECT_FILE, *LPWIN_TRUST_SUBJECT_FILE;




typedef struct _WIN_SPUB_TRUSTED_PUBLISHER_DATA {
	HANDLE			hClientToken;
	LPWIN_CERTIFICATE	lpCertificate;
} WIN_SPUB_TRUSTED_PUBLISHER_DATA, *LPWIN_SPUB_TRUSTED_PUBLISHER_DATA;
typedef void (_stdcall *PFIBER_START_ROUTINE)(LPVOID);
typedef PFIBER_START_ROUTINE LPFIBER_START_ROUTINE;
typedef struct tagNMDATETIMECHANGE {
        NMHDR   nmhdr;
        DWORD   dwFlags;
        SYSTEMTIME      st;
} NMDATETIMECHANGE, *LPNMDATETIMECHANGE;
typedef struct tagNMDATETIMESTRINGA {
        NMHDR   nmhdr;
        LPCSTR  pszUserString;
        SYSTEMTIME      st;
        DWORD   dwFlags;
} NMDATETIMESTRINGA, * LPNMDATETIMESTRINGA;
typedef struct tagNMDATETIMESTRINGW {
        NMHDR   nmhdr;
        LPCWSTR pszUserString;
        SYSTEMTIME      st;
        DWORD   dwFlags;
} NMDATETIMESTRINGW, * LPNMDATETIMESTRINGW;
typedef struct tagNMDATETIMEWMKEYDOWNA {
	NMHDR	nmhdr;
	int	nVirtKey;
	LPCSTR	pszFormat;
	SYSTEMTIME	st;
} NMDATETIMEWMKEYDOWNA,* LPNMDATETIMEWMKEYDOWNA;
typedef struct tagNMDATETIMEWMKEYDOWNW {
	NMHDR	nmhdr;
	int	nVirtKey;
	LPCWSTR	pszFormat;
	SYSTEMTIME	st;
} NMDATETIMEWMKEYDOWNW,* LPNMDATETIMEWMKEYDOWNW;
typedef struct tagNMDATETIMEFORMATA {
	NMHDR	nmhdr;
	LPCSTR	pszFormat;
	SYSTEMTIME st;
	LPCSTR pszDisplay;
	CHAR szDisplay[64];
} NMDATETIMEFORMATA, * LPNMDATETIMEFORMATA;
typedef struct tagNMDATETIMEFORMATW {
	NMHDR nmhdr;
	LPCWSTR pszFormat;
	SYSTEMTIME st;
	LPCWSTR pszDisplay;
	WCHAR szDisplay[64];
} NMDATETIMEFORMATW, * LPNMDATETIMEFORMATW;
typedef struct tagNMDATETIMEFORMATQUERYA {
	NMHDR nmhdr;
	LPCSTR pszFormat;
	SIZE szMax;
} NMDATETIMEFORMATQUERYA, * LPNMDATETIMEFORMATQUERYA;
typedef struct tagNMDATETIMEFORMATQUERYW {
	NMHDR nmhdr;
	LPCWSTR pszFormat;
	SIZE szMax;
} NMDATETIMEFORMATQUERYW,* LPNMDATETIMEFORMATQUERYW;

#line 9962 "C:\MATLAB7\sys\lcc\include\win.h"
BOOL _stdcall GetBinaryTypeW(LPCWSTR,LPDWORD);
DWORD _stdcall GetShortPathNameW(LPCWSTR,LPWSTR,DWORD);
LPWSTR _stdcall GetEnvironmentStringsW(void);
BOOL _stdcall FreeEnvironmentStringsW(LPWSTR);
DWORD _stdcall FormatMessageW(DWORD,LPCVOID,DWORD,DWORD,LPWSTR,DWORD,va_list *);
HANDLE _stdcall CreateMailslotW(LPCWSTR,DWORD,DWORD,LPSECURITY_ATTRIBUTES);
int _stdcall lstrcmpW(LPCWSTR,LPCWSTR);
int _stdcall lstrcmpiW( LPCWSTR,LPCWSTR);
LPWSTR _stdcall lstrcpynW(LPWSTR,LPCWSTR,int);
LPWSTR _stdcall lstrcpyW(LPWSTR,LPCWSTR);
LPWSTR _stdcall lstrcatW(LPWSTR,LPCWSTR);
int _stdcall lstrlenW(LPCWSTR);
HANDLE _stdcall CreateMutexW(LPSECURITY_ATTRIBUTES,BOOL,LPCWSTR);
HANDLE _stdcall OpenMutexW(DWORD,BOOL,LPCWSTR);
HANDLE _stdcall CreateEventW(LPSECURITY_ATTRIBUTES,BOOL,BOOL,LPCWSTR);
HANDLE _stdcall OpenEventW(DWORD,BOOL,LPCWSTR);
HANDLE _stdcall CreateSemaphoreW(LPSECURITY_ATTRIBUTES,LONG,LONG,LPCWSTR);
HANDLE _stdcall OpenSemaphoreW(DWORD,BOOL,LPCWSTR);
HANDLE _stdcall CreateFileMappingW(HANDLE,LPSECURITY_ATTRIBUTES,DWORD,DWORD,DWORD,LPCWSTR);
HANDLE _stdcall OpenFileMappingW(DWORD,BOOL,LPCWSTR);
DWORD _stdcall GetLogicalDriveStringsW(DWORD,LPWSTR);
HINSTANCE _stdcall LoadLibraryW(LPCWSTR);
HINSTANCE _stdcall LoadLibraryExW(LPCWSTR,HANDLE,DWORD);
DWORD _stdcall GetModuleFileNameW(HINSTANCE,LPWSTR,DWORD);
HMODULE _stdcall GetModuleHandleW(LPCWSTR);
 void _stdcall FatalAppExitW(UINT,LPCWSTR);
LPWSTR _stdcall GetCommandLineW(void);
DWORD _stdcall GetEnvironmentVariableW(LPCWSTR,LPWSTR,DWORD);
BOOL _stdcall SetEnvironmentVariableW(LPCWSTR,LPCWSTR);
DWORD _stdcall ExpandEnvironmentStringsW(LPCWSTR,LPWSTR,DWORD);
 void _stdcall OutputDebugStringW(LPCWSTR);
HRSRC _stdcall FindResourceW(HINSTANCE,LPCWSTR,LPCWSTR);
HRSRC _stdcall FindResourceExW(HINSTANCE,LPCWSTR,LPCWSTR,WORD);
BOOL _stdcall EnumResourceTypesW(HINSTANCE,ENUMRESTYPEPROC,LONG);
BOOL _stdcall EnumResourceNamesW(HINSTANCE,LPCWSTR,ENUMRESNAMEPROC,LONG);
BOOL _stdcall EnumResourceLanguagesW(HINSTANCE,LPCWSTR,LPCWSTR,ENUMRESLANGPROC,LONG);
HANDLE _stdcall BeginUpdateResourceW(LPCWSTR,BOOL);
BOOL _stdcall UpdateResourceW(HANDLE,LPCWSTR,LPCWSTR,WORD,LPVOID,DWORD);
BOOL _stdcall EndUpdateResourceW(HANDLE,BOOL);
ATOM _stdcall GlobalAddAtomW( LPCWSTR);
ATOM _stdcall GlobalFindAtomW( LPCWSTR);
UINT _stdcall GlobalGetAtomNameW(ATOM,LPWSTR,int);
ATOM _stdcall AddAtomW(LPCWSTR);
ATOM _stdcall FindAtomW(LPCWSTR);
UINT _stdcall GetAtomNameW(ATOM,LPWSTR,int);
UINT _stdcall GetProfileIntW(LPCWSTR,LPCWSTR,INT);
DWORD _stdcall GetProfileStringW(LPCWSTR,LPCWSTR,LPCWSTR,LPWSTR,DWORD);
BOOL _stdcall WriteProfileStringW(LPCWSTR,LPCWSTR,LPCWSTR);
DWORD _stdcall GetProfileSectionW(LPCWSTR,LPWSTR,DWORD);
BOOL _stdcall WriteProfileSectionW(LPCWSTR,LPCWSTR);
UINT _stdcall GetPrivateProfileIntW(LPCWSTR,LPCWSTR,INT,LPCWSTR);
DWORD _stdcall GetPrivateProfileStringW(LPCWSTR,LPCWSTR,LPCWSTR,LPWSTR,DWORD,LPCWSTR);
BOOL _stdcall WritePrivateProfileStringW(LPCWSTR,LPCWSTR,LPCWSTR,LPCWSTR);
DWORD _stdcall GetPrivateProfileSectionW(LPCWSTR,LPWSTR,DWORD,LPCWSTR);
DWORD _stdcall GetPrivateProfileSectionNamesA(LPSTR,DWORD,LPCSTR);
DWORD _stdcall GetPrivateProfileSectionNamesW(LPWSTR,DWORD,LPCWSTR);
BOOL _stdcall WritePrivateProfileSectionW(LPCWSTR,LPCWSTR,LPCWSTR);
UINT _stdcall GetDriveTypeW(LPCWSTR);
UINT _stdcall GetSystemDirectoryW(LPWSTR,UINT);
DWORD _stdcall GetTempPathW(DWORD,LPWSTR);
UINT _stdcall GetTempFileNameW(LPCWSTR,LPCWSTR,UINT,LPWSTR);
UINT _stdcall GetWindowsDirectoryW(LPWSTR,UINT);
BOOL _stdcall SetCurrentDirectoryW(LPCWSTR);
DWORD _stdcall GetCurrentDirectoryW(DWORD,LPWSTR);
BOOL _stdcall GetDiskFreeSpaceW(LPCWSTR,LPDWORD,LPDWORD,LPDWORD,LPDWORD);
BOOL _stdcall CreateDirectoryW(LPCWSTR,LPSECURITY_ATTRIBUTES);
BOOL _stdcall CreateDirectoryExW(LPCWSTR,LPCWSTR,LPSECURITY_ATTRIBUTES);
BOOL _stdcall RemoveDirectoryW(LPCWSTR);
DWORD _stdcall GetFullPathNameW(LPCWSTR,DWORD,LPWSTR,LPWSTR *);
BOOL _stdcall DefineDosDeviceW(DWORD,LPCWSTR,LPCWSTR);
DWORD _stdcall QueryDosDeviceW(LPCWSTR,LPWSTR,DWORD);
HANDLE _stdcall CreateFileW(LPCWSTR,DWORD,DWORD,LPSECURITY_ATTRIBUTES,DWORD,DWORD,HANDLE);
BOOL _stdcall SetFileAttributesW(LPCWSTR,DWORD);
DWORD _stdcall GetFileAttributesW(LPCWSTR);
DWORD _stdcall GetCompressedFileSizeW(LPCWSTR,LPDWORD);
BOOL _stdcall DeleteFileW(LPCWSTR);
DWORD _stdcall SearchPathW(LPCWSTR,LPCWSTR,LPCWSTR,DWORD,LPWSTR,LPWSTR *);
BOOL _stdcall CopyFileW(LPCWSTR,LPCWSTR,BOOL);
BOOL _stdcall MoveFileW(LPCWSTR,LPCWSTR);
BOOL _stdcall MoveFileExW(LPCWSTR,LPCWSTR,DWORD);
HANDLE _stdcall CreateNamedPipeW(LPCWSTR,DWORD,DWORD,DWORD,DWORD,DWORD,DWORD,LPSECURITY_ATTRIBUTES);
BOOL _stdcall GetNamedPipeHandleStateW(HANDLE,LPDWORD,LPDWORD,LPDWORD,LPDWORD,LPWSTR,DWORD);
BOOL _stdcall CallNamedPipeW(LPCWSTR,LPVOID,DWORD,LPVOID,DWORD,LPDWORD,DWORD);
BOOL _stdcall WaitNamedPipeW(LPCWSTR,DWORD);
BOOL _stdcall SetVolumeLabelW(LPCWSTR,LPCWSTR);
BOOL _stdcall GetVolumeInformationW(LPCWSTR,LPWSTR,DWORD,LPDWORD,LPDWORD,LPDWORD,LPWSTR,DWORD);
BOOL _stdcall ClearEventLogW(HANDLE,LPCWSTR);
BOOL _stdcall BackupEventLogW(HANDLE,LPCWSTR);
HANDLE _stdcall OpenEventLogW(LPCWSTR,LPCWSTR);
HANDLE _stdcall RegisterEventSourceW(LPCWSTR,LPCWSTR);
HANDLE _stdcall OpenBackupEventLogW(LPCWSTR,LPCWSTR);
BOOL _stdcall ReadEventLogW(HANDLE,DWORD,DWORD,LPVOID,DWORD,DWORD *,DWORD *);
BOOL _stdcall ReportEventW(HANDLE,WORD,WORD,DWORD,PSID,WORD,DWORD,LPCWSTR *,LPVOID);
BOOL _stdcall AccessCheckAndAuditAlarmW(LPCWSTR,LPVOID HandleId,LPWSTR,LPWSTR,PSECURITY_DESCRIPTOR,DWORD,PGENERIC_MAPPING,BOOL,LPDWORD,LPBOOL,LPBOOL);
BOOL _stdcall ObjectOpenAuditAlarmW(LPCWSTR,LPVOID,LPWSTR,LPWSTR,PSECURITY_DESCRIPTOR,HANDLE,DWORD,DWORD,PPRIVILEGE_SET,BOOL,BOOL,LPBOOL);
BOOL _stdcall ObjectPrivilegeAuditAlarmW(LPCWSTR,LPVOID,HANDLE,DWORD,PPRIVILEGE_SET,BOOL);
BOOL _stdcall ObjectCloseAuditAlarmW(LPCWSTR,LPVOID,BOOL);
BOOL _stdcall PrivilegedServiceAuditAlarmW(LPCWSTR,LPCWSTR,HANDLE,PPRIVILEGE_SET,BOOL);
BOOL _stdcall SetFileSecurityW(LPCWSTR,SECURITY_INFORMATION,PSECURITY_DESCRIPTOR);
BOOL _stdcall GetFileSecurityW(LPCWSTR,SECURITY_INFORMATION,PSECURITY_DESCRIPTOR,DWORD,LPDWORD);
HANDLE _stdcall FindFirstChangeNotificationW(LPCWSTR,BOOL,DWORD);
BOOL _stdcall IsBadStringPtrW(LPCWSTR,UINT);
BOOL _stdcall LookupAccountSidW(LPCWSTR,PSID,LPWSTR,LPDWORD,LPWSTR,LPDWORD,PSID_NAME_USE);
BOOL _stdcall LookupAccountNameW(LPCWSTR,LPCWSTR,PSID,LPDWORD,LPWSTR,LPDWORD,PSID_NAME_USE);
BOOL _stdcall LookupPrivilegeValueW(LPCWSTR,LPCWSTR,PLUID);
BOOL _stdcall LookupPrivilegeNameW(LPCWSTR,PLUID,LPWSTR,LPDWORD);
BOOL _stdcall LookupPrivilegeDisplayNameW(LPCWSTR,LPCWSTR,LPWSTR,LPDWORD,LPDWORD);
BOOL _stdcall BuildCommDCBW(LPCWSTR,LPDCB);
BOOL _stdcall BuildCommDCBAndTimeoutsW(LPCWSTR,LPDCB,LPCOMMTIMEOUTS);
BOOL _stdcall CommConfigDialogW(LPCWSTR,HWND,LPCOMMCONFIG);
BOOL _stdcall GetDefaultCommConfigW(LPCWSTR,LPCOMMCONFIG,LPDWORD);
BOOL _stdcall SetDefaultCommConfigW(LPCWSTR,LPCOMMCONFIG,DWORD);
BOOL _stdcall GetComputerNameW(LPWSTR,LPDWORD);
BOOL _stdcall SetComputerNameW(LPCWSTR);
BOOL _stdcall GetUserNameW(LPWSTR,LPDWORD);
int _stdcall wvsprintfW(LPWSTR,LPCWSTR,va_list arglist);
int wsprintfW(LPWSTR,LPCWSTR,...);
HKL _stdcall LoadKeyboardLayoutW(LPCWSTR,UINT);
BOOL _stdcall GetKeyboardLayoutNameW(LPWSTR);
HDESK _stdcall CreateDesktopW(LPWSTR,LPWSTR,LPDEVMODE,DWORD,DWORD,LPSECURITY_ATTRIBUTES);
HDESK _stdcall OpenDesktopW(LPWSTR,DWORD,BOOL,DWORD);
BOOL _stdcall EnumDesktopsW(HWINSTA,DESKTOPENUMPROCA,LPARAM);
HWINSTA _stdcall CreateWindowStationW(LPWSTR,DWORD,DWORD,LPSECURITY_ATTRIBUTES);
HWINSTA _stdcall OpenWindowStationW(LPWSTR,BOOL,DWORD);
BOOL _stdcall EnumWindowStationsW(ENUMWINDOWSTATIONPROC,LPARAM);
BOOL _stdcall GetUserObjectInformationW(HANDLE,int,PVOID,DWORD,LPDWORD);
BOOL _stdcall SetUserObjectInformationW(HANDLE,int,PVOID,DWORD);
UINT _stdcall RegisterWindowMessageW(LPCWSTR);
BOOL _stdcall GetMessageW(LPMSG,HWND,UINT,UINT);
LONG _stdcall DispatchMessageW(const MSG *);
BOOL _stdcall PeekMessageW(LPMSG,HWND,UINT,UINT,UINT);
LRESULT _stdcall SendMessageW(HWND,UINT,WPARAM,LPARAM);
LRESULT _stdcall SendMessageTimeoutW(HWND,UINT,WPARAM,LPARAM,UINT,UINT,LPDWORD);
BOOL _stdcall SendNotifyMessageW(HWND,UINT,WPARAM,LPARAM);
BOOL _stdcall SendMessageCallbackW(HWND,UINT,WPARAM,LPARAM,SENDASYNCPROC,DWORD);
BOOL _stdcall PostMessageW(HWND,UINT,WPARAM,LPARAM);
BOOL _stdcall PostThreadMessageW(DWORD,UINT,WPARAM,LPARAM);
LRESULT _stdcall DefWindowProcW(HWND,UINT,WPARAM,LPARAM);
LRESULT _stdcall CallWindowProcW(WNDPROC,HWND,UINT,WPARAM,LPARAM);
ATOM _stdcall RegisterClassW(const WNDCLASS *);
BOOL _stdcall UnregisterClassW(LPCWSTR,HINSTANCE);
BOOL _stdcall GetClassInfoW(HINSTANCE,LPCWSTR,LPWNDCLASS);
ATOM _stdcall RegisterClassExW(const WNDCLASSEX *);
BOOL _stdcall GetClassInfoExW(HINSTANCE,LPCWSTR,LPWNDCLASSEX);
HWND _stdcall CreateWindowExW(DWORD,LPCWSTR,LPCWSTR,DWORD,int,int,int,int,HWND,HMENU,HINSTANCE,LPVOID);
HWND _stdcall CreateDialogParamW(HINSTANCE,LPCWSTR,HWND,DLGPROC,LPARAM);
HWND _stdcall CreateDialogIndirectParamW(HINSTANCE,LPCDLGTEMPLATE,HWND,DLGPROC,LPARAM);
int _stdcall DialogBoxParamW(HINSTANCE,LPCWSTR,HWND,DLGPROC,LPARAM);
int _stdcall DialogBoxIndirectParamW(HINSTANCE,LPCDLGTEMPLATE,HWND,DLGPROC,LPARAM);
BOOL _stdcall SetDlgItemTextW(HWND,int,LPCWSTR);
UINT _stdcall GetDlgItemTextW(HWND,int,LPWSTR,int);
LONG _stdcall SendDlgItemMessageW(HWND,int,UINT,WPARAM,LPARAM);
LRESULT _stdcall DefDlgProcW(HWND,UINT,WPARAM,LPARAM);
BOOL _stdcall CallMsgFilterW(LPMSG,int);
UINT _stdcall RegisterClipboardFormatW(LPCWSTR);
int _stdcall GetClipboardFormatNameW(UINT,LPWSTR,int);
BOOL _stdcall CharToOemW(LPCWSTR,LPSTR);
BOOL _stdcall OemToCharW(LPCSTR,LPWSTR);
BOOL _stdcall CharToOemBuffW(LPCWSTR,LPSTR,DWORD);
BOOL _stdcall OemToCharBuffW(LPCSTR,LPWSTR,DWORD);
LPWSTR _stdcall CharUpperW(LPWSTR);
DWORD _stdcall CharUpperBuffW(LPWSTR,DWORD);
LPWSTR _stdcall CharLowerW(LPWSTR);
DWORD _stdcall CharLowerBuffW(LPWSTR,DWORD);
LPWSTR _stdcall CharNextW(LPCWSTR);
LPWSTR _stdcall CharPrevW(LPCWSTR,LPCWSTR);
BOOL _stdcall IsCharAlphaW(WCHAR);
BOOL _stdcall IsCharAlphaNumericW(WCHAR);
BOOL _stdcall IsCharUpperW(WCHAR);
BOOL _stdcall IsCharLowerW(WCHAR);
int _stdcall GetKeyNameTextW(LONG,LPWSTR,int);
SHORT _stdcall VkKeyScanW(WCHAR);
SHORT _stdcall VkKeyScanExW(WCHAR,HKL);
UINT _stdcall MapVirtualKeyW(UINT,UINT);
UINT _stdcall MapVirtualKeyExW(UINT,UINT,HKL);
HACCEL _stdcall LoadAcceleratorsW(HINSTANCE,LPCWSTR);
HACCEL _stdcall CreateAcceleratorTableW(LPACCEL,int);
int _stdcall CopyAcceleratorTableW(HACCEL,LPACCEL,int);
int _stdcall TranslateAcceleratorW(HWND,HACCEL,LPMSG);
HMENU _stdcall LoadMenuW(HINSTANCE,LPCWSTR);
HMENU _stdcall LoadMenuIndirectW(const MENUTEMPLATE *);
BOOL _stdcall ChangeMenuW(HMENU,UINT,LPCWSTR,UINT,UINT);
int _stdcall GetMenuStringW(HMENU,UINT,LPWSTR,int,UINT);
BOOL _stdcall InsertMenuW(HMENU,UINT,UINT,UINT,LPCWSTR);
BOOL _stdcall AppendMenuW(HMENU,UINT,UINT,LPCWSTR);
BOOL _stdcall ModifyMenuW(HMENU,UINT,UINT,UINT,LPCWSTR);
BOOL _stdcall InsertMenuItemW(HMENU,UINT,BOOL,LPCMENUITEMINFO);
BOOL _stdcall GetMenuItemInfoW(HMENU,UINT,BOOL,LPMENUITEMINFO);
BOOL _stdcall SetMenuItemInfoW( HMENU,UINT,BOOL,LPCMENUITEMINFO);
int _stdcall DrawTextW(HDC,LPCWSTR,int,LPRECT,UINT);
int _stdcall DrawTextExW(HDC,LPWSTR,int,LPRECT,UINT,LPDRAWTEXTPARAMS);
BOOL _stdcall GrayStringW(HDC,HBRUSH,GRAYSTRINGPROC,LPARAM,int,int,int,int,int);
BOOL _stdcall DrawStateW(HDC,HBRUSH,DRAWSTATEPROC,LPARAM,WPARAM,int,int,int,int,UINT);
LONG _stdcall TabbedTextOutW(HDC,int,int,LPCWSTR,int,int,LPINT,int);
DWORD _stdcall GetTabbedTextExtentW(HDC,LPCWSTR,int,int,LPINT);
BOOL _stdcall SetPropW(HWND,LPCWSTR,HANDLE);
HANDLE _stdcall GetPropW(HWND,LPCWSTR);
HANDLE _stdcall RemovePropW(HWND,LPCWSTR);
int _stdcall EnumPropsExW(HWND,PROPENUMPROCEX,LPARAM);
int _stdcall EnumPropsW(HWND,PROPENUMPROC);
BOOL _stdcall SetWindowTextW(HWND,LPCWSTR);
int _stdcall GetWindowTextW(HWND,LPWSTR,int);
int _stdcall GetWindowTextLengthW(HWND);
int _stdcall MessageBoxW(HWND,LPCWSTR,LPCWSTR,UINT);
int _stdcall MessageBoxExW(HWND,LPCWSTR,LPCWSTR,UINT,WORD);
int _stdcall MessageBoxIndirectW(LPMSGBOXPARAMS);
LONG _stdcall GetWindowLongW(HWND,int);
LONG _stdcall SetWindowLongW(HWND,int,LONG);
DWORD _stdcall GetClassLongW(HWND,int);
DWORD _stdcall SetClassLongW(HWND,int,LONG);
HWND _stdcall FindWindowW(LPCWSTR,LPCWSTR);
HWND _stdcall FindWindowExW(HWND,HWND,LPCWSTR,LPCWSTR);
int _stdcall GetClassNameW(HWND,LPWSTR,int);
HHOOK _stdcall SetWindowsHookExW(int,HOOKPROC,HINSTANCE,DWORD);

HBITMAP _stdcall LoadBitmapW(HINSTANCE,LPCWSTR);
HCURSOR _stdcall LoadCursorW(HINSTANCE,LPCWSTR);
HCURSOR _stdcall LoadCursorFromFileW(LPCWSTR);
HICON _stdcall LoadIconW(HINSTANCE,LPCWSTR);
HANDLE _stdcall LoadImageW(HINSTANCE,LPCWSTR,UINT,int,int,UINT);
int _stdcall LoadStringW(HINSTANCE,UINT,LPWSTR,int);
BOOL _stdcall IsDialogMessageW(HWND,LPMSG);
int _stdcall DlgDirListW(HWND,LPWSTR,int,int,UINT);
BOOL _stdcall DlgDirSelectExW(HWND,LPWSTR,int,int);
int _stdcall DlgDirListComboBoxW(HWND,LPWSTR,int,int,UINT);
BOOL _stdcall DlgDirSelectComboBoxExW(HWND,LPWSTR,int,int);
LRESULT _stdcall DefFrameProcW(HWND,HWND,UINT,WPARAM,LPARAM);
LRESULT _stdcall DefMDIChildProcW(HWND,UINT,WPARAM,LPARAM);
HWND _stdcall CreateMDIWindowW(LPWSTR,LPWSTR,DWORD,int,int,int,int,HWND,HINSTANCE,LPARAM);
BOOL _stdcall WinHelpW(HWND,LPCWSTR,UINT,DWORD);
LONG _stdcall ChangeDisplaySettingsW(LPDEVMODE,DWORD);
BOOL _stdcall EnumDisplaySettingsW(LPCWSTR,DWORD,LPDEVMODE);
BOOL _stdcall SystemParametersInfoW(UINT,UINT,PVOID,UINT);
int _stdcall AddFontResourceW(LPCWSTR);
HMETAFILE _stdcall CopyMetaFileW(HMETAFILE,LPCWSTR);
HFONT _stdcall CreateFontIndirectW(const LOGFONT *);
HFONT _stdcall CreateFontW(int,int,int,int,int,DWORD,DWORD,DWORD,DWORD,DWORD,DWORD,DWORD,DWORD,LPCWSTR);
HDC _stdcall CreateICW(LPCWSTR,LPCWSTR,LPCWSTR,const DEVMODE *);
HDC _stdcall CreateMetaFileW(LPCWSTR);
BOOL _stdcall CreateScalableFontResourceW(DWORD,LPCWSTR,LPCWSTR,LPCWSTR);
int _stdcall DeviceCapabilitiesW(LPCWSTR,LPCWSTR,WORD,LPWSTR,const DEVMODE *);
int _stdcall EnumFontFamiliesExW(HDC,LPLOGFONT,FONTENUMEXPROC,LPARAM,DWORD);
int _stdcall EnumFontFamiliesW(HDC,LPCWSTR,FONTENUMPROC,LPARAM);
int _stdcall EnumFontsW(HDC,LPCWSTR,ENUMFONTSPROC,LPARAM);
BOOL _stdcall GetCharWidthW(HDC,UINT,UINT,LPINT);
BOOL _stdcall GetCharWidth32W(HDC,UINT,UINT,LPINT);
BOOL _stdcall GetCharWidthFloatW(HDC,UINT,UINT,PFLOAT);
BOOL _stdcall GetCharABCWidthsW(HDC,UINT,UINT,LPABC);
BOOL _stdcall GetCharABCWidthsFloatW(HDC,UINT,UINT,LPABCFLOAT);
DWORD _stdcall GetGlyphOutlineW(HDC,UINT,UINT,LPGLYPHMETRICS,DWORD,LPVOID,const MAT2 *);
HMETAFILE _stdcall GetMetaFileW(LPCWSTR);
UINT _stdcall GetOutlineTextMetricsW(HDC,UINT,LPOUTLINETEXTMETRIC);
BOOL _stdcall GetTextExtentPointW(HDC,LPCWSTR,int,LPSIZE);
BOOL _stdcall GetTextExtentPoint32W( HDC,LPCWSTR,int,LPSIZE);
BOOL _stdcall GetTextExtentExPointW( HDC,LPCWSTR,int,int,LPINT,LPINT,LPSIZE );
DWORD _stdcall GetCharacterPlacementW(HDC,LPCWSTR,int,int,LPGCP_RESULTS,DWORD);
HDC _stdcall ResetDCW(HDC,const DEVMODE *);
BOOL _stdcall RemoveFontResourceW(LPCWSTR);
HENHMETAFILE _stdcall CopyEnhMetaFileW(HENHMETAFILE,LPCWSTR);
HDC _stdcall CreateEnhMetaFileW(HDC,LPCWSTR,const RECT *,LPCWSTR);
HENHMETAFILE _stdcall GetEnhMetaFileW(LPCWSTR);
UINT _stdcall GetEnhMetaFileDescriptionW(HENHMETAFILE,UINT,LPWSTR );
BOOL _stdcall GetTextMetricsW(HDC,LPTEXTMETRIC);
int _stdcall StartDocW(HDC,const DOCINFO *);
int _stdcall GetObjectW(HGDIOBJ,int,LPVOID);
BOOL _stdcall TextOutW(HDC,int,int,LPCWSTR,int);
BOOL _stdcall ExtTextOutW(HDC,int,int,UINT,const RECT *,LPCWSTR,UINT,const INT *);
BOOL _stdcall PolyTextOutW(HDC,const POLYTEXT *,int);
int _stdcall GetTextFaceW(HDC,int,LPWSTR);
DWORD _stdcall GetKerningPairsW(HDC,DWORD,LPKERNINGPAIR);
BOOL _stdcall GetLogColorSpaceW(HCOLORSPACE,LPLOGCOLORSPACE,DWORD);
HCOLORSPACE _stdcall CreateColorSpaceW(LPLOGCOLORSPACE);
BOOL _stdcall GetICMProfileW(HDC,DWORD,LPWSTR);
BOOL _stdcall SetICMProfileW(HDC,LPWSTR);
BOOL _stdcall UpdateICMRegKeyW(DWORD,DWORD,LPWSTR,UINT);
int _stdcall EnumICMProfilesW(HDC,ICMENUMPROC,LPARAM);
HPROPSHEETPAGE _stdcall CreatePropertySheetPageW(LPCPROPSHEETPAGE);
int _stdcall PropertySheetW(LPCPROPSHEETHEADER);
HIMAGELIST _stdcall ImageList_LoadImageW(HINSTANCE,LPCWSTR,int,int,COLORREF,UINT,UINT);

HWND _stdcall CreateStatusWindowW(LONG,LPCWSTR,HWND,UINT *);
void _stdcall DrawStatusTextW(HDC,LPRECT,LPCWSTR,UINT);
BOOL _stdcall GetOpenFileNameW(LPOPENFILENAME);
BOOL _stdcall GetSaveFileNameW(LPOPENFILENAME);
short _stdcall GetFileTitleW(LPCWSTR,LPWSTR,WORD);
BOOL _stdcall ChooseColorW(LPCHOOSECOLOR);
HWND _stdcall ReplaceTextW(LPFINDREPLACE);
BOOL _stdcall ChooseFontW(LPCHOOSEFONT);
HWND _stdcall FindTextW(LPFINDREPLACE);
BOOL _stdcall PrintDlgW(LPPRINTDLG);
BOOL _stdcall PageSetupDlgW(LPPAGESETUPDLG);
BOOL _stdcall CreateProcessW(LPCWSTR,LPWSTR,LPSECURITY_ATTRIBUTES,LPSECURITY_ATTRIBUTES,BOOL,DWORD,LPVOID,LPCWSTR,LPSTARTUPINFO,LPPROCESS_INFORMATION);
 void _stdcall GetStartupInfoW(LPSTARTUPINFO);
HANDLE _stdcall FindFirstFileW(LPCWSTR,LPWIN32_FIND_DATA);
BOOL _stdcall FindNextFileW(HANDLE,LPWIN32_FIND_DATA);
BOOL _stdcall GetVersionExW(LPOSVERSIONINFO);





HDC _stdcall CreateDCW(LPCWSTR,LPCWSTR,LPCWSTR,const DEVMODE *);
HFONT _stdcall CreateFontA(int,int,int,int,int,DWORD,DWORD,DWORD,DWORD,DWORD,DWORD,DWORD,DWORD,LPCSTR);
DWORD _stdcall VerInstallFileW(DWORD,LPWSTR,LPWSTR,LPWSTR,LPWSTR,LPWSTR,LPWSTR,PUINT);
DWORD _stdcall GetFileVersionInfoSizeW(LPWSTR,LPDWORD);
BOOL _stdcall GetFileVersionInfoW(LPWSTR,DWORD,DWORD,LPVOID);
DWORD _stdcall VerLanguageNameW(DWORD,LPWSTR,DWORD);
DWORD _stdcall VerFindFileW(DWORD,LPWSTR,LPWSTR,LPWSTR,LPWSTR,PUINT,LPWSTR,PUINT);
LONG _stdcall RegSetValueExW(HKEY,LPCWSTR,DWORD,DWORD,const BYTE*,DWORD);
LONG _stdcall RegUnLoadKeyW(HKEY,LPCWSTR);
BOOL _stdcall InitiateSystemShutdownW(LPWSTR,LPWSTR,DWORD,BOOL,BOOL);
BOOL _stdcall AbortSystemShutdownW(LPWSTR);
LONG _stdcall RegRestoreKeyW(HKEY,LPCWSTR,DWORD);
LONG _stdcall RegSaveKeyW(HKEY,LPCWSTR,LPSECURITY_ATTRIBUTES);
LONG _stdcall RegSetValueW(HKEY,LPCWSTR,DWORD,LPCWSTR,DWORD);
LONG _stdcall RegQueryValueW(HKEY,LPCWSTR,LPWSTR,PLONG);
LONG _stdcall RegQueryMultipleValuesW(HKEY,PVALENT,DWORD,LPWSTR,LPDWORD);
LONG _stdcall RegQueryValueExW(HKEY,LPCWSTR,LPDWORD,LPDWORD,LPBYTE,LPDWORD);
LONG _stdcall RegReplaceKeyW(HKEY,LPCWSTR,LPCWSTR,LPCWSTR);
LONG _stdcall RegConnectRegistryW(LPWSTR,HKEY,PHKEY);
LONG _stdcall RegCreateKeyW(HKEY,LPCWSTR,PHKEY);
LONG _stdcall RegCreateKeyExW(HKEY,LPCWSTR,DWORD,LPWSTR,DWORD,REGSAM,LPSECURITY_ATTRIBUTES,PHKEY,LPDWORD);
LONG _stdcall RegDeleteKeyW(HKEY,LPCWSTR);
LONG _stdcall RegDeleteValueW(HKEY,LPCWSTR);
LONG _stdcall RegEnumKeyW(HKEY,DWORD,LPWSTR,DWORD);
LONG _stdcall RegEnumKeyExW(HKEY,DWORD,LPWSTR,LPDWORD,LPDWORD,LPWSTR,LPDWORD,PFILETIME);
LONG _stdcall RegEnumValueW(HKEY,DWORD,LPWSTR,LPDWORD,LPDWORD,LPDWORD,LPBYTE,LPDWORD);
LONG _stdcall RegLoadKeyW(HKEY,LPCWSTR,LPCWSTR);
LONG _stdcall RegOpenKeyW(HKEY,LPCWSTR,PHKEY);
LONG _stdcall RegOpenKeyExW(HKEY,LPCWSTR,DWORD,REGSAM,PHKEY);
LONG _stdcall RegQueryInfoKeyW(HKEY,LPWSTR,LPDWORD,LPDWORD,LPDWORD,LPDWORD,LPDWORD,LPDWORD,LPDWORD,LPDWORD,LPDWORD,PFILETIME);
int _stdcall CompareStringW(LCID,DWORD,LPCWSTR,int,LPCWSTR,int);
int _stdcall LCMapStringW(LCID,DWORD,LPCWSTR,int,LPWSTR,int);
int _stdcall GetLocaleInfoW(LCID,LCTYPE,LPWSTR,int);
BOOL _stdcall SetLocaleInfoW(LCID,LCTYPE,LPCWSTR);
int _stdcall GetTimeFormatW(LCID,DWORD,const SYSTEMTIME *,LPCWSTR,LPWSTR,int);
int _stdcall GetDateFormatW(LCID,DWORD,const SYSTEMTIME *,LPCWSTR,LPWSTR,int);
int _stdcall GetNumberFormatW(LCID,DWORD,LPCWSTR,const NUMBERFMT *,LPWSTR,int);
int _stdcall GetCurrencyFormatW(LCID,DWORD,LPCWSTR,const CURRENCYFMT *,LPWSTR,int);
BOOL _stdcall EnumCalendarInfoW(CALINFO_ENUMPROC,LCID,CALID,CALTYPE);
BOOL _stdcall EnumTimeFormatsW(TIMEFMT_ENUMPROC,LCID,DWORD);
BOOL _stdcall EnumDateFormatsW(DATEFMT_ENUMPROC,LCID,DWORD);
BOOL _stdcall GetStringTypeExW(LCID,DWORD,LPCWSTR,int,LPWORD);
BOOL _stdcall GetStringTypeW(DWORD,LPCWSTR,int,LPWORD);
int _stdcall FoldStringW(DWORD,LPCWSTR,int,LPWSTR,int);
BOOL _stdcall EnumSystemLocalesW(LOCALE_ENUMPROC,DWORD);
BOOL _stdcall EnumSystemCodePagesW(CODEPAGE_ENUMPROC,DWORD);
BOOL _stdcall PeekConsoleInputW(HANDLE,PINPUT_RECORD,DWORD,LPDWORD);
BOOL _stdcall ReadConsoleInputW(HANDLE,PINPUT_RECORD,DWORD,LPDWORD);
BOOL _stdcall WriteConsoleInputW(HANDLE,const INPUT_RECORD *,DWORD,LPDWORD);
BOOL _stdcall ReadConsoleOutputW(HANDLE,PCHAR_INFO,COORD,COORD,PSMALL_RECT);
BOOL _stdcall WriteConsoleOutputW(HANDLE,const CHAR_INFO *,COORD,COORD,PSMALL_RECT);
BOOL _stdcall ReadConsoleOutputCharacterW(HANDLE,LPWSTR,DWORD,COORD,LPDWORD);
BOOL _stdcall WriteConsoleOutputCharacterW(HANDLE,LPCWSTR,DWORD,COORD,LPDWORD);
BOOL _stdcall FillConsoleOutputCharacterW(HANDLE,WCHAR,DWORD,COORD,LPDWORD);
BOOL _stdcall ScrollConsoleScreenBufferW(HANDLE,const SMALL_RECT *,const SMALL_RECT *,COORD,const CHAR_INFO *);
DWORD _stdcall GetConsoleTitleW(LPWSTR,DWORD);
BOOL _stdcall SetConsoleTitleW(LPCWSTR);
BOOL _stdcall ReadConsoleW(HANDLE,LPVOID,DWORD,LPDWORD,LPVOID);
BOOL _stdcall WriteConsoleW(HANDLE,const void *,DWORD,LPDWORD,LPVOID);
DWORD _stdcall WNetAddConnectionW(LPCWSTR,LPCWSTR,LPCWSTR);
DWORD _stdcall WNetAddConnection2W(LPNETRESOURCE,LPCWSTR,LPCWSTR,DWORD);
DWORD _stdcall WNetAddConnection3W(HWND,LPNETRESOURCE,LPCWSTR,LPCWSTR,DWORD);
DWORD _stdcall WNetCancelConnectionW(LPCWSTR,BOOL);
DWORD _stdcall WNetCancelConnection2W(LPCWSTR,DWORD,BOOL);
DWORD _stdcall WNetGetConnectionW(LPCWSTR,LPWSTR,LPDWORD);
DWORD _stdcall WNetUseConnectionW(HWND,LPNETRESOURCE,LPCWSTR,LPCWSTR,DWORD,LPWSTR,LPDWORD,LPDWORD);
DWORD _stdcall WNetSetConnectionW(LPCWSTR,DWORD,LPVOID);
DWORD _stdcall WNetConnectionDialog1W(LPCONNECTDLGSTRUCT);
DWORD _stdcall WNetDisconnectDialog1W(LPDISCDLGSTRUCT);
DWORD _stdcall WNetOpenEnumW(DWORD,DWORD,DWORD,LPNETRESOURCE,LPHANDLE);
DWORD _stdcall WNetEnumResourceW(HANDLE,LPDWORD,LPVOID,LPDWORD);
DWORD _stdcall WNetGetUniversalNameW(LPCWSTR,DWORD,LPVOID,LPDWORD);
DWORD _stdcall WNetGetUserW(LPCWSTR,LPWSTR,LPDWORD);
DWORD _stdcall WNetGetProviderNameW(DWORD,LPWSTR,LPDWORD);
DWORD _stdcall WNetGetNetworkInformationW(LPCWSTR,LPNETINFOSTRUCT);
DWORD _stdcall WNetGetLastErrorW(LPDWORD,LPWSTR,DWORD,LPWSTR,DWORD);
DWORD _stdcall MultinetGetConnectionPerformanceW(LPNETRESOURCE,LPNETCONNECTINFOSTRUCT);
BOOL _stdcall ChangeServiceConfigW(SC_HANDLE,DWORD,DWORD,DWORD,LPCWSTR,LPCWSTR,LPDWORD,LPCWSTR,LPCWSTR,LPCWSTR,LPCWSTR);
SC_HANDLE _stdcall CreateServiceW(SC_HANDLE,LPCWSTR,LPCWSTR,DWORD,DWORD,DWORD,DWORD,LPCWSTR,LPCWSTR,LPDWORD,LPCWSTR,LPCWSTR,LPCWSTR);
BOOL _stdcall EnumDependentServicesW(SC_HANDLE,DWORD,LPENUM_SERVICE_STATUS,DWORD,LPDWORD,LPDWORD);
BOOL _stdcall EnumServicesStatusW(SC_HANDLE,DWORD,DWORD,LPENUM_SERVICE_STATUS,DWORD,LPDWORD,LPDWORD,LPDWORD);
BOOL _stdcall GetServiceKeyNameW(SC_HANDLE,LPCWSTR,LPWSTR,LPDWORD);
BOOL _stdcall GetServiceDisplayNameW(SC_HANDLE,LPCWSTR,LPWSTR,LPDWORD);
SC_HANDLE _stdcall OpenSCManagerW(LPCWSTR,LPCWSTR,DWORD);
SC_HANDLE _stdcall OpenServiceW(SC_HANDLE,LPCWSTR,DWORD);
BOOL _stdcall QueryServiceConfigW(SC_HANDLE,LPQUERY_SERVICE_CONFIG,DWORD,LPDWORD);
BOOL _stdcall QueryServiceLockStatusW(SC_HANDLE,LPQUERY_SERVICE_LOCK_STATUS,DWORD,LPDWORD);
SERVICE_STATUS_HANDLE _stdcall RegisterServiceCtrlHandlerW(LPCWSTR,LPHANDLER_FUNCTION);
BOOL _stdcall StartServiceCtrlDispatcherW(LPSERVICE_TABLE_ENTRY);
BOOL _stdcall StartServiceW(SC_HANDLE,DWORD,LPCWSTR);

BOOL _stdcall GetBinaryTypeA(LPCSTR,LPDWORD);
DWORD _stdcall GetShortPathNameA(LPCSTR,LPSTR,DWORD);
BOOL _stdcall FreeEnvironmentStringsA(LPSTR);
DWORD _stdcall FormatMessageA(DWORD,LPCVOID,DWORD,DWORD,LPSTR,DWORD,va_list *);
HANDLE _stdcall CreateMailslotA(LPCSTR,DWORD,DWORD,LPSECURITY_ATTRIBUTES);
int _stdcall lstrcmpA(LPCSTR,LPCSTR);
int _stdcall lstrcmpiA(LPCSTR,LPCSTR);
LPSTR _stdcall lstrcpynA(LPSTR,LPCSTR,int);
LPSTR _stdcall lstrcpyA(LPSTR,LPCSTR);
LPSTR _stdcall lstrcatA(LPSTR,LPCSTR);
int _stdcall lstrlenA(LPCSTR);
HANDLE _stdcall CreateMutexA(LPSECURITY_ATTRIBUTES,BOOL,LPCSTR);
HANDLE _stdcall OpenMutexA(DWORD,BOOL,LPCSTR);
HANDLE _stdcall CreateEventA(LPSECURITY_ATTRIBUTES,BOOL,BOOL,LPCSTR);
HANDLE _stdcall OpenEventA(DWORD,BOOL,LPCSTR);
HANDLE _stdcall CreateSemaphoreA(LPSECURITY_ATTRIBUTES,LONG,LONG,LPCSTR);
HANDLE _stdcall OpenSemaphoreA(DWORD,BOOL,LPCSTR);
HANDLE _stdcall CreateFileMappingA(HANDLE,LPSECURITY_ATTRIBUTES,DWORD,DWORD,DWORD,LPCSTR);
HANDLE _stdcall OpenFileMappingA(DWORD,BOOL,LPCSTR);
DWORD _stdcall GetLogicalDriveStringsA(DWORD,LPSTR);
HINSTANCE _stdcall LoadLibraryA(LPCSTR);
HINSTANCE _stdcall LoadLibraryExA(LPCSTR,HANDLE,DWORD);
DWORD _stdcall GetModuleFileNameA(HINSTANCE,LPSTR,DWORD);
HMODULE _stdcall GetModuleHandleA(LPCSTR);
 void _stdcall FatalAppExitA(UINT,LPCSTR);
LPSTR _stdcall GetCommandLineA(void);
DWORD _stdcall GetEnvironmentVariableA(LPCSTR,LPSTR,DWORD);
BOOL _stdcall SetEnvironmentVariableA(LPCSTR,LPCSTR);
DWORD _stdcall ExpandEnvironmentStringsA(LPCSTR,LPSTR,DWORD);
 void _stdcall OutputDebugStringA(LPCSTR);
HRSRC _stdcall FindResourceA(HMODULE,LPCSTR,LPCSTR);
HRSRC _stdcall FindResourceExA(HINSTANCE,LPCSTR,LPCSTR,WORD);
BOOL _stdcall EnumResourceTypesA(HINSTANCE,ENUMRESTYPEPROC,LONG);
BOOL _stdcall EnumResourceNamesA(HINSTANCE,LPCSTR,ENUMRESNAMEPROC,LONG);
BOOL _stdcall EnumResourceLanguagesA(HINSTANCE,LPCSTR,LPCSTR,ENUMRESLANGPROC,LONG);
HANDLE _stdcall BeginUpdateResourceA(LPCSTR,BOOL);
BOOL _stdcall UpdateResourceA(HANDLE,LPCSTR,LPCSTR,WORD,LPVOID,DWORD);
BOOL _stdcall EndUpdateResourceA(HANDLE,BOOL);
ATOM _stdcall GlobalAddAtomA(LPCSTR);
ATOM _stdcall GlobalFindAtomA(LPCSTR);
UINT _stdcall GlobalGetAtomNameA(ATOM,LPSTR,int);
ATOM _stdcall AddAtomA(LPCSTR);
ATOM _stdcall FindAtomA(LPCSTR);
UINT _stdcall GetAtomNameA(ATOM,LPSTR,int);
UINT _stdcall GetProfileIntA(LPCSTR,LPCSTR,INT);
DWORD _stdcall GetProfileStringA(LPCSTR,LPCSTR,LPCSTR,LPSTR,DWORD);
BOOL _stdcall WriteProfileStringA(LPCSTR,LPCSTR,LPCSTR);
DWORD _stdcall GetProfileSectionA(LPCSTR,LPSTR,DWORD);
BOOL _stdcall WriteProfileSectionA(LPCSTR,LPCSTR);
UINT _stdcall GetPrivateProfileIntA(LPCSTR,LPCSTR,INT,LPCSTR);
DWORD _stdcall GetPrivateProfileStringA(LPCSTR,LPCSTR,LPCSTR,LPSTR,DWORD,LPCSTR);
BOOL _stdcall WritePrivateProfileStringA(LPCSTR,LPCSTR,LPCSTR,LPCSTR);
DWORD _stdcall GetPrivateProfileSectionA(LPCSTR,LPSTR,DWORD,LPCSTR);
BOOL _stdcall WritePrivateProfileSectionA(LPCSTR,LPCSTR,LPCSTR);
UINT _stdcall GetDriveTypeA(LPCSTR);
UINT _stdcall GetSystemDirectoryA(LPSTR,UINT);
DWORD _stdcall GetTempPathA(DWORD,LPSTR);
UINT _stdcall GetTempFileNameA(LPCSTR,LPCSTR,UINT,LPSTR);
UINT _stdcall GetWindowsDirectoryA(LPSTR,UINT);
BOOL _stdcall SetCurrentDirectoryA(LPCSTR);
DWORD _stdcall GetCurrentDirectoryA(DWORD,LPSTR);
BOOL _stdcall GetDiskFreeSpaceA(LPCSTR,LPDWORD,LPDWORD,LPDWORD,LPDWORD);
BOOL _stdcall CreateDirectoryA(LPCSTR,LPSECURITY_ATTRIBUTES);
BOOL _stdcall CreateDirectoryExA(LPCSTR,LPCSTR,LPSECURITY_ATTRIBUTES);
BOOL _stdcall RemoveDirectoryA(LPCSTR);
DWORD _stdcall GetFullPathNameA(LPCSTR,DWORD,LPSTR,LPSTR *);
BOOL _stdcall DefineDosDeviceA(DWORD,LPCSTR,LPCSTR);
DWORD _stdcall QueryDosDeviceA(LPCSTR,LPSTR,DWORD);
HANDLE _stdcall CreateFileA(LPCSTR,DWORD,DWORD,LPSECURITY_ATTRIBUTES,DWORD,DWORD,HANDLE);
BOOL _stdcall SetFileAttributesA(LPCSTR,DWORD);
DWORD _stdcall GetFileAttributesA(LPCSTR);
DWORD _stdcall GetCompressedFileSizeA(LPCSTR,LPDWORD);
BOOL _stdcall DeleteFileA(LPCSTR);
DWORD _stdcall SearchPathA(LPCSTR,LPCSTR,LPCSTR,DWORD,LPSTR,LPSTR *);
BOOL _stdcall CopyFileA(LPCSTR,LPCSTR,BOOL);
BOOL _stdcall MoveFileA(LPCSTR,LPCSTR);
BOOL _stdcall MoveFileExA(LPCSTR,LPCSTR,DWORD);
HANDLE _stdcall CreateNamedPipeA(LPCSTR,DWORD,DWORD,DWORD,DWORD,DWORD,DWORD,LPSECURITY_ATTRIBUTES);
BOOL _stdcall GetNamedPipeHandleStateA(HANDLE,LPDWORD,LPDWORD,LPDWORD,LPDWORD,LPSTR,DWORD);
BOOL _stdcall CallNamedPipeA(LPCSTR,LPVOID,DWORD,LPVOID,DWORD,LPDWORD,DWORD);
BOOL _stdcall WaitNamedPipeA(LPCSTR,DWORD);
BOOL _stdcall SetVolumeLabelA(LPCSTR,LPCSTR);
BOOL _stdcall GetVolumeInformationA(LPCSTR,LPSTR,DWORD,LPDWORD,LPDWORD,LPDWORD,LPSTR,DWORD);
BOOL _stdcall ClearEventLogA(HANDLE,LPCSTR);
BOOL _stdcall BackupEventLogA(HANDLE,LPCSTR);
HANDLE _stdcall OpenEventLogA (LPCSTR,LPCSTR);
HANDLE _stdcall RegisterEventSourceA (LPCSTR,LPCSTR);
HANDLE _stdcall OpenBackupEventLogA(LPCSTR,LPCSTR);
BOOL _stdcall ReadEventLogA(HANDLE,DWORD,DWORD,LPVOID,DWORD,DWORD *,DWORD *);
BOOL _stdcall ReportEventA(HANDLE,WORD,WORD,DWORD,PSID,WORD,DWORD,LPCSTR *,LPVOID);
BOOL _stdcall AccessCheckAndAuditAlarmA(LPCSTR,LPVOID,LPSTR,LPSTR,PSECURITY_DESCRIPTOR,
	DWORD,PGENERIC_MAPPING,BOOL,LPDWORD,LPBOOL,LPBOOL);
BOOL _stdcall ObjectOpenAuditAlarmA(LPCSTR,LPVOID,LPSTR,LPSTR,PSECURITY_DESCRIPTOR,HANDLE,DWORD,DWORD,PPRIVILEGE_SET,BOOL,BOOL,LPBOOL);
BOOL _stdcall ObjectPrivilegeAuditAlarmA(LPCSTR,LPVOID,HANDLE,DWORD,PPRIVILEGE_SET,BOOL);
BOOL _stdcall ObjectCloseAuditAlarmA(LPCSTR,LPVOID,BOOL);
BOOL _stdcall PrivilegedServiceAuditAlarmA(LPCSTR,LPCSTR,HANDLE,PPRIVILEGE_SET,BOOL);
BOOL _stdcall SetFileSecurityA(LPCSTR,SECURITY_INFORMATION,PSECURITY_DESCRIPTOR);
BOOL _stdcall GetFileSecurityA(LPCSTR,SECURITY_INFORMATION,PSECURITY_DESCRIPTOR,DWORD,LPDWORD);
HANDLE _stdcall FindFirstChangeNotificationA(LPCSTR,BOOL,DWORD);
BOOL _stdcall IsBadStringPtrA(LPCSTR,UINT);
BOOL _stdcall LookupAccountSidA(LPCSTR,PSID,LPSTR,LPDWORD,LPSTR,LPDWORD,PSID_NAME_USE);
BOOL _stdcall LookupAccountNameA(LPCSTR,LPCSTR,PSID,LPDWORD,LPSTR,LPDWORD,PSID_NAME_USE);
BOOL _stdcall LookupPrivilegeValueA(LPCSTR,LPCSTR,PLUID);
BOOL _stdcall LookupPrivilegeNameA(LPCSTR,PLUID,LPSTR,LPDWORD);
BOOL _stdcall LookupPrivilegeDisplayNameA(LPCSTR,LPCSTR,LPSTR,LPDWORD,LPDWORD);
BOOL _stdcall BuildCommDCBA(LPCSTR lpDef,LPDCB lpDCB);
BOOL _stdcall BuildCommDCBAndTimeoutsA(LPCSTR,LPDCB,LPCOMMTIMEOUTS);
BOOL _stdcall CommConfigDialogA(LPCSTR,HWND,LPCOMMCONFIG);
BOOL _stdcall GetDefaultCommConfigA(LPCSTR,LPCOMMCONFIG,LPDWORD);
BOOL _stdcall SetDefaultCommConfigA(LPCSTR,LPCOMMCONFIG,DWORD);
BOOL _stdcall GetComputerNameA (LPSTR,LPDWORD);
BOOL _stdcall SetComputerNameA (LPCSTR);
BOOL _stdcall GetUserNameA (LPSTR,LPDWORD);
int _stdcall wvsprintfA(LPSTR,LPCSTR,va_list arglist);
int wsprintfA(LPSTR,LPCSTR,...);
HKL _stdcall LoadKeyboardLayoutA(LPCSTR,UINT);
BOOL _stdcall GetKeyboardLayoutNameA(LPSTR);
HDESK _stdcall CreateDesktopA(LPSTR,LPSTR,LPDEVMODE,DWORD,DWORD,LPSECURITY_ATTRIBUTES);
HDESK _stdcall OpenDesktopA(LPSTR,DWORD,BOOL,DWORD);
BOOL _stdcall EnumDesktopsA(HWINSTA,DESKTOPENUMPROCA,LPARAM);
HWINSTA _stdcall CreateWindowStationA(LPSTR,DWORD,DWORD,LPSECURITY_ATTRIBUTES);
HWINSTA _stdcall OpenWindowStationA(LPSTR,BOOL,DWORD);
BOOL _stdcall EnumWindowStationsA(ENUMWINDOWSTATIONPROC,LPARAM);
BOOL _stdcall GetUserObjectInformationA(HANDLE,int,PVOID,DWORD,LPDWORD);
BOOL _stdcall SetUserObjectInformationA(HANDLE,int,PVOID,DWORD);
UINT _stdcall RegisterWindowMessageA(LPCSTR);
BOOL _stdcall GetMessageA(LPMSG,HWND,UINT,UINT);
LONG _stdcall DispatchMessageA(const MSG *);
BOOL _stdcall PeekMessageA(LPMSG,HWND,UINT,UINT,UINT);
LRESULT _stdcall SendMessageA(HWND,UINT,WPARAM,LPARAM);
LRESULT _stdcall SendMessageTimeoutA(HWND,UINT,WPARAM,LPARAM,UINT,UINT,LPDWORD);
BOOL _stdcall SendNotifyMessageA(HWND,UINT,WPARAM,LPARAM);
BOOL _stdcall SendMessageCallbackA(HWND,UINT,WPARAM,LPARAM,SENDASYNCPROC,DWORD);
BOOL _stdcall PostMessageA(HWND,UINT,WPARAM,LPARAM);
BOOL _stdcall PostThreadMessageA(DWORD,UINT,WPARAM,LPARAM);
LRESULT _stdcall DefWindowProcA(HWND,UINT,WPARAM,LPARAM);
LRESULT _stdcall CallWindowProcA(WNDPROC,HWND,UINT,WPARAM,LPARAM);
ATOM _stdcall RegisterClassA(const WNDCLASS *);
BOOL _stdcall UnregisterClassA(LPCSTR,HINSTANCE);
BOOL _stdcall GetClassInfoA(HINSTANCE,LPCSTR,LPWNDCLASS);
ATOM _stdcall RegisterClassExA(const WNDCLASSEX *);
BOOL _stdcall GetClassInfoExA(HINSTANCE,LPCSTR,LPWNDCLASSEX);
HWND _stdcall CreateWindowExA(DWORD,LPCSTR,LPCSTR,DWORD,int,int,int,int,HWND,HMENU,HINSTANCE,LPVOID);
HWND _stdcall CreateDialogParamA(HINSTANCE,LPCSTR,HWND,DLGPROC,LPARAM);
HWND _stdcall CreateDialogIndirectParamA(HINSTANCE,LPCDLGTEMPLATE,HWND,DLGPROC,LPARAM);
int _stdcall DialogBoxParamA(HINSTANCE,LPCSTR,HWND,DLGPROC,LPARAM);
int _stdcall DialogBoxIndirectParamA(HINSTANCE,LPCDLGTEMPLATE,HWND,DLGPROC,LPARAM);
BOOL _stdcall SetDlgItemTextA(HWND,int,LPCSTR);
UINT _stdcall GetDlgItemTextA(HWND,int,LPSTR,int);
LONG _stdcall SendDlgItemMessageA(HWND,int,UINT,WPARAM,LPARAM);
LRESULT _stdcall DefDlgProcA(HWND,UINT,WPARAM,LPARAM);
BOOL _stdcall CallMsgFilterA(LPMSG,int);
UINT _stdcall RegisterClipboardFormatA(LPCSTR);
int _stdcall GetClipboardFormatNameA(UINT,LPSTR,int);
BOOL _stdcall CharToOemA(LPCSTR,LPSTR);
BOOL _stdcall OemToCharA(LPCSTR,LPSTR);
BOOL _stdcall CharToOemBuffA(LPCSTR,LPSTR,DWORD);
BOOL _stdcall OemToCharBuffA(LPCSTR,LPSTR,DWORD);
LPSTR _stdcall CharUpperA(LPSTR);
DWORD _stdcall CharUpperBuffA(LPSTR,DWORD);
LPSTR _stdcall CharLowerA(LPSTR);
DWORD _stdcall CharLowerBuffA(LPSTR,DWORD);
LPSTR _stdcall CharNextA(LPCSTR);
LPSTR _stdcall CharPrevA(LPCSTR,LPCSTR);
BOOL _stdcall IsCharAlphaA(CHAR ch);
BOOL _stdcall IsCharAlphaNumericA(CHAR);
BOOL _stdcall IsCharUpperA(CHAR);
BOOL _stdcall IsCharLowerA(CHAR);
int _stdcall GetKeyNameTextA(LONG,LPSTR,int);
SHORT _stdcall VkKeyScanA(CHAR);
SHORT _stdcall VkKeyScanExA(CHAR,HKL);
UINT _stdcall MapVirtualKeyA(UINT,UINT);
UINT _stdcall MapVirtualKeyExA(UINT,UINT,HKL);
HACCEL _stdcall LoadAcceleratorsA(HINSTANCE,LPCSTR);
HACCEL _stdcall CreateAcceleratorTableA(LPACCEL,int);
int _stdcall CopyAcceleratorTableA(HACCEL,LPACCEL,int);
int _stdcall TranslateAcceleratorA(HWND,HACCEL,LPMSG);
HMENU _stdcall LoadMenuA(HINSTANCE,LPCSTR);
HMENU _stdcall LoadMenuIndirectA(const MENUTEMPLATE *);
BOOL _stdcall ChangeMenuA(HMENU,UINT,LPCSTR,UINT,UINT);
int _stdcall GetMenuStringA(HMENU,UINT,LPSTR,int,UINT);
BOOL _stdcall InsertMenuA(HMENU,UINT,UINT,UINT,LPCSTR);
BOOL _stdcall AppendMenuA(HMENU,UINT,UINT,LPCSTR);
BOOL _stdcall ModifyMenuA(HMENU,UINT,UINT,UINT,LPCSTR);
BOOL _stdcall InsertMenuItemA(HMENU,UINT,BOOL,LPCMENUITEMINFO);
BOOL _stdcall GetMenuItemInfoA(HMENU,UINT,BOOL,LPMENUITEMINFO);
BOOL _stdcall SetMenuItemInfoA(HMENU,UINT,BOOL,LPCMENUITEMINFO);
int _stdcall DrawTextA(HDC,LPCSTR,int,LPRECT,UINT);
int _stdcall DrawTextExA(HDC,LPSTR,int,LPRECT,UINT,LPDRAWTEXTPARAMS);
BOOL _stdcall GrayStringA(HDC,HBRUSH,GRAYSTRINGPROC,LPARAM,int,int,int,int,int);
BOOL _stdcall DrawStateA(HDC,HBRUSH,DRAWSTATEPROC,LPARAM,WPARAM,int,int,int,int,UINT);
LONG _stdcall TabbedTextOutA(HDC,int,int,LPCSTR,int,int,LPINT,int);
DWORD _stdcall GetTabbedTextExtentA(HDC,LPCSTR,int,int,LPINT);
BOOL _stdcall SetPropA(HWND,LPCSTR,HANDLE);
HANDLE _stdcall GetPropA(HWND,LPCSTR);
HANDLE _stdcall RemovePropA(HWND,LPCSTR);
int _stdcall EnumPropsExA(HWND,PROPENUMPROCEX,LPARAM);
int _stdcall EnumPropsA(HWND,PROPENUMPROC);
BOOL _stdcall SetWindowTextA(HWND,LPCSTR);
int _stdcall GetWindowTextA(HWND,LPSTR,int);
int _stdcall GetWindowTextLengthA(HWND);
int _stdcall MessageBoxA(HWND,LPCSTR,LPCSTR,UINT);
int _stdcall MessageBoxExA(HWND,LPCSTR,LPCSTR,UINT,WORD);
int _stdcall MessageBoxIndirectA(LPMSGBOXPARAMS);
LONG _stdcall GetWindowLongA(HWND,int);
LONG _stdcall SetWindowLongA(HWND,int,LONG);
DWORD _stdcall GetClassLongA(HWND,int);
DWORD _stdcall SetClassLongA(HWND,int,LONG);
HWND _stdcall FindWindowA(LPCSTR,LPCSTR);
HWND _stdcall FindWindowExA(HWND,HWND,LPCSTR,LPCSTR);
int _stdcall GetClassNameA(HWND,LPSTR,int);
HHOOK _stdcall SetWindowsHookExA(int,HOOKPROC,HINSTANCE,DWORD);
HOOKPROC _stdcall SetWindowsHookA(int,HOOKPROC);
HBITMAP _stdcall LoadBitmapA(HINSTANCE,LPCSTR);
HCURSOR _stdcall LoadCursorA(HINSTANCE,LPCSTR);
HCURSOR _stdcall LoadCursorFromFileA(LPCSTR);
HICON _stdcall LoadIconA(HINSTANCE,LPCSTR);
HANDLE _stdcall LoadImageA(HINSTANCE,LPCSTR,UINT,int,int,UINT);
int _stdcall LoadStringA(HINSTANCE,UINT,LPSTR,int);
BOOL _stdcall IsDialogMessageA(HWND,LPMSG);
int _stdcall DlgDirListA(HWND,LPSTR,int,int,UINT);
BOOL _stdcall DlgDirSelectExA(HWND,LPSTR,int,int);
int _stdcall DlgDirListComboBoxA(HWND,LPSTR,int,int,UINT);
BOOL _stdcall DlgDirSelectComboBoxExA(HWND,LPSTR,int,int);
LRESULT _stdcall DefFrameProcA(HWND,HWND,UINT,WPARAM,LPARAM);
LRESULT _stdcall DefMDIChildProcA(HWND,UINT,WPARAM,LPARAM);
HWND _stdcall CreateMDIWindowA(LPSTR,LPSTR,DWORD,int,int,int,int,HWND,HINSTANCE,LPARAM);
BOOL _stdcall WinHelpA(HWND,LPCSTR,UINT,DWORD);
LONG _stdcall ChangeDisplaySettingsA(LPDEVMODE,DWORD);
BOOL _stdcall EnumDisplaySettingsA(LPCSTR,DWORD,LPDEVMODE);
BOOL _stdcall SystemParametersInfoA(UINT,UINT,PVOID,UINT);
int _stdcall AddFontResourceA(LPCSTR);
int _stdcall ChoosePixelFormat(HDC,PIXELFORMATDESCRIPTOR *);
BOOL _stdcall SetPixelFormat(HDC,int,PIXELFORMATDESCRIPTOR *);
HMETAFILE _stdcall CopyMetaFileA(HMETAFILE,LPCSTR);
HFONT _stdcall CreateFontIndirectA(const LOGFONT *);
HDC _stdcall CreateICA(LPCSTR,LPCSTR,LPCSTR,const DEVMODE *);
HDC _stdcall CreateMetaFileA(LPCSTR);
BOOL _stdcall CreateScalableFontResourceA(DWORD,LPCSTR,LPCSTR,LPCSTR);
int _stdcall DeviceCapabilitiesA(LPCSTR,LPCSTR,WORD,LPSTR,const DEVMODE *);
int _stdcall EnumFontFamiliesExA(HDC,LPLOGFONT,FONTENUMEXPROC,LPARAM,DWORD);
int _stdcall EnumFontFamiliesA(HDC,LPCSTR,FONTENUMPROC,LPARAM);
int _stdcall EnumFontsA(HDC,LPCSTR,ENUMFONTSPROC,LPARAM);
BOOL _stdcall GetCharWidthA(HDC,UINT,UINT,LPINT);
BOOL _stdcall GetCharWidth32A(HDC,UINT,UINT,LPINT);
BOOL _stdcall GetCharWidthFloatA(HDC,UINT,UINT,PFLOAT);
BOOL _stdcall GetCharABCWidthsA(HDC,UINT,UINT,LPABC);
BOOL _stdcall GetCharABCWidthsFloatA(HDC,UINT,UINT,LPABCFLOAT);
DWORD _stdcall GetGlyphOutlineA(HDC,UINT,UINT,LPGLYPHMETRICS,DWORD,LPVOID,const MAT2 *);
HMETAFILE _stdcall GetMetaFileA(LPCSTR);
UINT _stdcall GetOutlineTextMetricsA(HDC,UINT,LPOUTLINETEXTMETRIC);
BOOL _stdcall GetTextExtentPointA(HDC,LPCSTR,int,LPSIZE);
BOOL _stdcall GetTextExtentPoint32A(HDC,LPCSTR,int,LPSIZE);
BOOL _stdcall GetTextExtentExPointA(HDC,LPCSTR,int,int,LPINT,LPINT,LPSIZE);
DWORD _stdcall GetCharacterPlacementA(HDC,LPCSTR,int,int,LPGCP_RESULTS,DWORD);
HDC _stdcall ResetDCA(HDC,const DEVMODE *);
BOOL _stdcall RemoveFontResourceA(LPCSTR);
HENHMETAFILE _stdcall CopyEnhMetaFileA(HENHMETAFILE,LPCSTR);
HDC _stdcall CreateEnhMetaFileA(HDC,LPCSTR,const RECT *,LPCSTR);
HENHMETAFILE _stdcall GetEnhMetaFileA(LPCSTR);
UINT _stdcall GetEnhMetaFileDescriptionA(HENHMETAFILE,UINT,LPSTR);
BOOL _stdcall GetTextMetricsA(HDC,LPTEXTMETRIC);
int _stdcall StartDocA(HDC,const DOCINFO *);
int _stdcall GetObjectA(HGDIOBJ,int,LPVOID);
BOOL _stdcall TextOutA(HDC,int,int,LPCSTR,int);
BOOL _stdcall ExtTextOutA(HDC,int,int,UINT,const RECT *,LPCSTR,UINT,const INT *);
BOOL _stdcall PolyTextOutA(HDC,const POLYTEXT *,int);
int _stdcall GetTextFaceA(HDC,int,LPSTR);
DWORD _stdcall GetKerningPairsA(HDC,DWORD,LPKERNINGPAIR);
HCOLORSPACE _stdcall CreateColorSpaceA(LPLOGCOLORSPACE);
BOOL _stdcall GetLogColorSpaceA(HCOLORSPACE,LPLOGCOLORSPACE,DWORD);
BOOL _stdcall GetICMProfileA(HDC,DWORD,LPSTR);
BOOL _stdcall SetICMProfileA(HDC,LPSTR);
BOOL _stdcall UpdateICMRegKeyA(DWORD,DWORD,LPSTR,UINT);
int _stdcall EnumICMProfilesA(HDC,ICMENUMPROC,LPARAM);
int _stdcall PropertySheetA(LPCPROPSHEETHEADER);
HIMAGELIST _stdcall ImageList_LoadImageA(HINSTANCE,LPCSTR,int,int,COLORREF,UINT,UINT);
HWND _stdcall CreateStatusWindowA(LONG,LPCSTR,HWND,UINT);
void _stdcall DrawStatusTextA(HDC,LPRECT,LPCSTR,UINT);
BOOL _stdcall GetOpenFileNameA(LPOPENFILENAME);
BOOL _stdcall GetSaveFileNameA(LPOPENFILENAME);
short _stdcall GetFileTitleA(LPCSTR,LPSTR,WORD);
BOOL _stdcall ChooseColorA(LPCHOOSECOLOR);
HWND _stdcall FindTextA(LPFINDREPLACE);
HWND _stdcall ReplaceTextA(LPFINDREPLACE);
BOOL _stdcall ChooseFontA(LPCHOOSEFONT);
BOOL _stdcall PrintDlgA(LPPRINTDLG);
BOOL _stdcall PageSetupDlgA(LPPAGESETUPDLG);
BOOL _stdcall CreateProcessA(LPCSTR,LPSTR,LPSECURITY_ATTRIBUTES,
	LPSECURITY_ATTRIBUTES,BOOL,DWORD,LPVOID,LPCSTR,
	LPSTARTUPINFO,LPPROCESS_INFORMATION);
 void _stdcall GetStartupInfoA(LPSTARTUPINFO);
HANDLE _stdcall FindFirstFileA(LPCSTR,LPWIN32_FIND_DATA);
BOOL _stdcall FindNextFileA(HANDLE,LPWIN32_FIND_DATA);
BOOL _stdcall GetVersionExA(LPOSVERSIONINFO);





HDC _stdcall CreateDCA(LPCSTR,LPCSTR,LPCSTR,const DEVMODE *);
DWORD _stdcall VerInstallFileA(DWORD,LPSTR,LPSTR,LPSTR,LPSTR,LPSTR,LPSTR,PUINT);
DWORD _stdcall GetFileVersionInfoSizeA(LPSTR,LPDWORD);
BOOL _stdcall GetFileVersionInfoA(LPSTR,DWORD,DWORD,LPVOID);
DWORD _stdcall VerLanguageNameA(DWORD,LPSTR,DWORD);
DWORD _stdcall VerFindFileA(DWORD,LPSTR,LPSTR,LPSTR,LPSTR,PUINT,LPSTR,PUINT);
LONG _stdcall RegConnectRegistryA(LPSTR,HKEY,PHKEY);
LONG _stdcall RegCreateKeyA(HKEY,LPCSTR,PHKEY);
LONG _stdcall RegCreateKeyExA(HKEY,LPCSTR,DWORD,LPSTR,DWORD,REGSAM,LPSECURITY_ATTRIBUTES,PHKEY,LPDWORD);
LONG _stdcall RegDeleteKeyA(HKEY,LPCSTR);
LONG _stdcall RegDeleteValueA (HKEY,LPCSTR);
LONG _stdcall RegEnumKeyA (HKEY,DWORD,LPSTR,DWORD);
LONG _stdcall RegEnumKeyExA(HKEY,DWORD,LPSTR,LPDWORD,LPDWORD,LPSTR,LPDWORD,PFILETIME);
LONG _stdcall RegEnumValueA(HKEY,DWORD,LPSTR,LPDWORD,LPDWORD,LPDWORD,LPBYTE,LPDWORD);
LONG _stdcall RegLoadKeyA(HKEY,LPCSTR,LPCSTR);
LONG _stdcall RegOpenKeyA(HKEY,LPCSTR,PHKEY);
LONG _stdcall RegOpenKeyExA(HKEY,LPCSTR,DWORD,REGSAM,PHKEY);
LONG _stdcall RegQueryInfoKeyA(HKEY,LPSTR,LPDWORD,LPDWORD,LPDWORD,LPDWORD,
	LPDWORD,LPDWORD,LPDWORD,LPDWORD,LPDWORD,PFILETIME);
LONG _stdcall RegQueryValueA(HKEY,LPCSTR,LPSTR,PLONG);
LONG _stdcall RegQueryMultipleValuesA(HKEY,PVALENT,DWORD,LPSTR,LPDWORD);
LONG _stdcall RegQueryValueExA (HKEY,LPCSTR,LPDWORD,LPDWORD,LPBYTE,LPDWORD);
LONG _stdcall RegReplaceKeyA(HKEY,LPCSTR,LPCSTR,LPCSTR);
LONG _stdcall RegRestoreKeyA (HKEY,LPCSTR,DWORD);
LONG _stdcall RegSaveKeyA(HKEY,LPCSTR,LPSECURITY_ATTRIBUTES);
LONG _stdcall RegSetValueA(HKEY,LPCSTR,DWORD,LPCSTR,DWORD);
LONG _stdcall RegSetValueExA(HKEY,LPCSTR,DWORD,DWORD,const BYTE*,DWORD);
LONG _stdcall RegUnLoadKeyA(HKEY,LPCSTR);
BOOL _stdcall InitiateSystemShutdownA(LPSTR,LPSTR,DWORD,BOOL,BOOL);
BOOL _stdcall AbortSystemShutdownA(LPSTR);
int _stdcall CompareStringA(LCID,DWORD,LPCSTR,int,LPCSTR,int);
int _stdcall LCMapStringA(LCID,DWORD,LPCSTR,int,LPSTR,int);
int _stdcall GetLocaleInfoA(LCID,LCTYPE,LPSTR,int);
BOOL _stdcall SetLocaleInfoA(LCID,LCTYPE,LPCSTR);
int _stdcall GetTimeFormatA(LCID,DWORD,const SYSTEMTIME *,LPCSTR,LPSTR,int);
int _stdcall GetDateFormatA(LCID,DWORD,const SYSTEMTIME *,LPCSTR,LPSTR,int);
int _stdcall GetNumberFormatA(LCID,DWORD,LPCSTR,const NUMBERFMT *,LPSTR,int);
int _stdcall GetCurrencyFormatA(LCID,DWORD,LPCSTR,const CURRENCYFMT *,LPSTR,int);
BOOL _stdcall EnumCalendarInfoA(CALINFO_ENUMPROC,LCID,CALID,CALTYPE);
BOOL _stdcall EnumTimeFormatsA(TIMEFMT_ENUMPROC,LCID,DWORD);
BOOL _stdcall EnumDateFormatsA(DATEFMT_ENUMPROC,LCID,DWORD);
BOOL _stdcall GetStringTypeExA(LCID,DWORD,LPCSTR,int,LPWORD);
BOOL _stdcall GetStringTypeA(LCID,DWORD,LPCSTR,int,LPWORD);
int _stdcall FoldStringA(DWORD,LPCSTR,int,LPSTR,int);
BOOL _stdcall EnumSystemLocalesA(LOCALE_ENUMPROC,DWORD);
BOOL _stdcall EnumSystemCodePagesA(CODEPAGE_ENUMPROC,DWORD);
BOOL _stdcall PeekConsoleInputA(HANDLE,PINPUT_RECORD,DWORD,LPDWORD);
BOOL _stdcall ReadConsoleInputA(HANDLE,PINPUT_RECORD,DWORD,LPDWORD);
BOOL _stdcall WriteConsoleInputA(HANDLE,const INPUT_RECORD *,DWORD,LPDWORD);
BOOL _stdcall ReadConsoleOutputA(HANDLE,PCHAR_INFO,COORD,COORD,PSMALL_RECT);
BOOL _stdcall WriteConsoleOutputA(HANDLE,const CHAR_INFO *,COORD,COORD,PSMALL_RECT);
BOOL _stdcall ReadConsoleOutputCharacterA(HANDLE,LPSTR,DWORD,COORD,LPDWORD);
BOOL _stdcall WriteConsoleOutputCharacterA(HANDLE,LPCSTR,DWORD,COORD,LPDWORD);
BOOL _stdcall FillConsoleOutputCharacterA(HANDLE,CHAR,DWORD,COORD,LPDWORD);
BOOL _stdcall ScrollConsoleScreenBufferA(HANDLE,const SMALL_RECT *,const SMALL_RECT *,COORD,const CHAR_INFO *);
DWORD _stdcall GetConsoleTitleA(LPSTR,DWORD);
BOOL _stdcall SetConsoleTitleA(LPCSTR);
BOOL _stdcall ReadConsoleA(HANDLE,LPVOID,DWORD,LPDWORD,LPVOID);
BOOL _stdcall WriteConsoleA(HANDLE,const void *,DWORD,LPDWORD,LPVOID);
DWORD _stdcall WNetAddConnectionA(LPCSTR,LPCSTR,LPCSTR);
DWORD _stdcall WNetAddConnection2A(LPNETRESOURCE,LPCSTR,LPCSTR,DWORD);
DWORD _stdcall WNetAddConnection3A(HWND,LPNETRESOURCE,LPCSTR,LPCSTR,DWORD);
DWORD _stdcall WNetCancelConnectionA(LPCSTR,BOOL);
DWORD _stdcall WNetCancelConnection2A(LPCSTR,DWORD,BOOL);
DWORD _stdcall WNetGetConnectionA(LPCSTR,LPSTR,LPDWORD);
DWORD _stdcall WNetUseConnectionA(HWND,LPNETRESOURCE,LPCSTR,LPCSTR,DWORD,LPSTR,LPDWORD,LPDWORD);
DWORD _stdcall WNetSetConnectionA(LPCSTR,DWORD,LPVOID);
DWORD _stdcall WNetConnectionDialog1A(LPCONNECTDLGSTRUCT);
DWORD _stdcall WNetDisconnectDialog1A(LPDISCDLGSTRUCT);
DWORD _stdcall WNetOpenEnumA(DWORD,DWORD,DWORD,LPNETRESOURCE,LPHANDLE);
DWORD _stdcall WNetEnumResourceA(HANDLE,LPDWORD,LPVOID,LPDWORD);
DWORD _stdcall WNetGetUniversalNameA(LPCSTR,DWORD,LPVOID,LPDWORD);
DWORD _stdcall WNetGetUserA(LPCSTR,LPSTR,LPDWORD);
DWORD _stdcall WNetGetProviderNameA(DWORD,LPSTR,LPDWORD);
DWORD _stdcall WNetGetNetworkInformationA(LPCSTR,LPNETINFOSTRUCT);
DWORD _stdcall WNetGetLastErrorA(LPDWORD,LPSTR,DWORD,LPSTR,DWORD);
DWORD _stdcall MultinetGetConnectionPerformanceA(LPNETRESOURCE,LPNETCONNECTINFOSTRUCT);
BOOL _stdcall ChangeServiceConfigA(SC_HANDLE,DWORD,DWORD,DWORD,LPCSTR,LPCSTR,LPDWORD,LPCSTR,LPCSTR,LPCSTR,LPCSTR);
SC_HANDLE _stdcall CreateServiceA(SC_HANDLE,LPCSTR,LPCSTR,DWORD,DWORD,DWORD,DWORD,LPCSTR,LPCSTR,LPDWORD,LPCSTR,LPCSTR,LPCSTR);
BOOL _stdcall EnumDependentServicesA(SC_HANDLE,DWORD,LPENUM_SERVICE_STATUS,DWORD,LPDWORD,LPDWORD);
BOOL _stdcall EnumServicesStatusA(SC_HANDLE,DWORD,DWORD,LPENUM_SERVICE_STATUS,DWORD,LPDWORD,LPDWORD,LPDWORD);
BOOL _stdcall GetServiceKeyNameA(SC_HANDLE,LPCSTR,LPSTR,LPDWORD);
BOOL _stdcall GetServiceDisplayNameA(SC_HANDLE,LPCSTR,LPSTR,LPDWORD);
SC_HANDLE _stdcall OpenSCManagerA(LPCSTR,LPCSTR,DWORD);
SC_HANDLE _stdcall OpenServiceA(SC_HANDLE,LPCSTR,DWORD);
BOOL _stdcall QueryServiceConfigA(SC_HANDLE,LPQUERY_SERVICE_CONFIG,DWORD,LPDWORD);
BOOL _stdcall QueryServiceLockStatusA(SC_HANDLE,LPQUERY_SERVICE_LOCK_STATUS,DWORD,LPDWORD);
SERVICE_STATUS_HANDLE _stdcall RegisterServiceCtrlHandlerA(LPCSTR,LPHANDLER_FUNCTION);
BOOL _stdcall StartServiceCtrlDispatcherA(LPSERVICE_TABLE_ENTRY);
BOOL _stdcall StartServiceA(SC_HANDLE,DWORD,LPCSTR *);












































































































































































































































































































































































































































































































































































































































































































































































































































BOOL AbnormalTermination(void);
int _stdcall AbortDoc(HDC);
BOOL AbortPrinter(HANDLE);
BOOL _stdcall AbortProc(HDC,int);
LONG _stdcall InterlockedIncrement(LPLONG);
LONG _stdcall InterlockedDecrement(LPLONG);
LONG _stdcall InterlockedExchange(LPLONG,LONG);
BOOL _stdcall FreeResource(HGLOBAL);
LPVOID _stdcall LockResource(HGLOBAL);
int _stdcall WinMain(HINSTANCE,HINSTANCE,LPSTR,int);
BOOL _stdcall FreeLibrary(HINSTANCE);
 void _stdcall FreeLibraryAndExitThread(HMODULE,DWORD);
BOOL _stdcall DisableThreadLibraryCalls(HMODULE);
FARPROC _stdcall GetProcAddress(HINSTANCE,LPCSTR);
DWORD _stdcall GetVersion(void);
HGLOBAL _stdcall GlobalAlloc(UINT,DWORD);
HGLOBAL GlobalDiscard(HGLOBAL);
HGLOBAL _stdcall GlobalReAlloc(HGLOBAL,DWORD,UINT);
DWORD _stdcall GlobalSize(HGLOBAL);
UINT _stdcall GlobalFlags(HGLOBAL);
LPVOID _stdcall GlobalLock(HGLOBAL);
HGLOBAL _stdcall GlobalHandle(LPCVOID);
BOOL _stdcall GlobalUnlock(HGLOBAL);
HGLOBAL _stdcall GlobalFree(HGLOBAL);
UINT _stdcall GlobalCompact(DWORD);
 void _stdcall GlobalFix(HGLOBAL);
 void _stdcall GlobalUnfix(HGLOBAL);
LPVOID _stdcall GlobalWire(HGLOBAL);
BOOL _stdcall GlobalUnWire(HGLOBAL);
 void _stdcall GlobalMemoryStatus(LPMEMORYSTATUS);
HLOCAL _stdcall LocalAlloc(UINT,UINT);
HLOCAL LocalDiscard(HLOCAL);
HLOCAL _stdcall LocalReAlloc(HLOCAL,UINT,UINT);
LPVOID _stdcall LocalLock(HLOCAL);
HLOCAL _stdcall LocalHandle(LPCVOID);
BOOL _stdcall LocalUnlock(HLOCAL);
UINT _stdcall LocalSize(HLOCAL);
UINT _stdcall LocalFlags(HLOCAL);
HLOCAL _stdcall LocalFree(HLOCAL);
UINT _stdcall LocalShrink(HLOCAL,UINT);
UINT _stdcall LocalCompact(UINT);
BOOL _stdcall FlushInstructionCache(HANDLE,LPCVOID,DWORD);
LPVOID _stdcall VirtualAlloc(LPVOID,DWORD,DWORD,DWORD);
BOOL _stdcall VirtualFree(LPVOID,DWORD,DWORD);
BOOL _stdcall VirtualProtect(LPVOID,DWORD,DWORD,PDWORD);
DWORD _stdcall VirtualQuery(LPCVOID,PMEMORY_BASIC_INFORMATION,DWORD);
BOOL _stdcall VirtualProtectEx(HANDLE,LPVOID,DWORD,DWORD,PDWORD);
DWORD _stdcall VirtualQueryEx(HANDLE,LPCVOID,PMEMORY_BASIC_INFORMATION,DWORD);
HANDLE _stdcall HeapCreate(DWORD,DWORD,DWORD);
BOOL _stdcall HeapDestroy(HANDLE);
LPVOID _stdcall HeapAlloc(HANDLE,DWORD,DWORD);
LPVOID _stdcall HeapReAlloc(HANDLE,DWORD,LPVOID,DWORD);
BOOL _stdcall HeapFree(HANDLE,DWORD,LPVOID);
DWORD _stdcall HeapSize(HANDLE,DWORD,LPCVOID);
BOOL _stdcall HeapValidate(HANDLE,DWORD,LPCVOID);
UINT _stdcall HeapCompact(HANDLE,DWORD);
HANDLE _stdcall GetProcessHeap(void);
DWORD _stdcall GetProcessHeaps(DWORD,PHANDLE);
DWORD _stdcall GetProcessVersion(DWORD);
BOOL _stdcall HeapLock(HANDLE);
BOOL _stdcall HeapUnlock(HANDLE);
BOOL _stdcall HeapWalk(HANDLE,LPPROCESS_HEAP_ENTRY);
BOOL _stdcall GetProcessAffinityMask(HANDLE,LPDWORD,LPDWORD);
BOOL _stdcall GetProcessTimes(HANDLE,LPFILETIME,LPFILETIME,LPFILETIME,LPFILETIME);
BOOL _stdcall GetProcessWorkingSetSize(HANDLE,LPDWORD,LPDWORD);
BOOL _stdcall SetProcessWorkingSetSize(HANDLE,DWORD,DWORD);
HANDLE _stdcall OpenProcess(DWORD,BOOL,DWORD);
HANDLE _stdcall GetCurrentProcess(void);
DWORD _stdcall GetCurrentProcessId(void);
 void _stdcall ExitProcess(UINT);
BOOL _stdcall TerminateProcess(HANDLE,UINT);
BOOL _stdcall GetExitCodeProcess(HANDLE,LPDWORD);
 void _stdcall FatalExit(int);
LPTSTR _stdcall GetEnvironmentStringsA(void);
 void _stdcall RaiseException(DWORD,DWORD,DWORD,const DWORD *);
LONG _stdcall UnhandledExceptionFilter(struct _EXCEPTION_POINTERS *);
LPTOP_LEVEL_EXCEPTION_FILTER _stdcall SetUnhandledExceptionFilter(LPTOP_LEVEL_EXCEPTION_FILTER);
HANDLE _stdcall CreateThread(LPSECURITY_ATTRIBUTES,DWORD,LPTHREAD_START_ROUTINE,LPVOID,DWORD,LPDWORD);
HANDLE _stdcall CreateRemoteThread(HANDLE,LPSECURITY_ATTRIBUTES,DWORD,LPTHREAD_START_ROUTINE,LPVOID,DWORD,LPDWORD);
HANDLE _stdcall GetCurrentThread(void);
DWORD _stdcall GetCurrentThreadId(void);
DWORD _stdcall SetThreadAffinityMask(HANDLE,DWORD);
BOOL _stdcall SetThreadPriority(HANDLE,int);
int _stdcall GetThreadPriority(HANDLE);
BOOL _stdcall GetThreadTimes(HANDLE,LPFILETIME,LPFILETIME,LPFILETIME,LPFILETIME);
 void _stdcall ExitThread(DWORD);
BOOL _stdcall TerminateThread(HANDLE,DWORD);
BOOL _stdcall GetExitCodeThread(HANDLE,LPDWORD);
BOOL _stdcall GetThreadSelectorEntry(HANDLE,DWORD,LPLDT_ENTRY);
DWORD _stdcall GetLastError(void);
 void _stdcall SetLastError(DWORD);
BOOL _stdcall GetOverlappedResult(HANDLE,LPOVERLAPPED,LPDWORD,BOOL);
HANDLE _stdcall CreateIoCompletionPort(HANDLE,HANDLE,DWORD,DWORD);
BOOL _stdcall GetQueuedCompletionStatus(HANDLE,LPDWORD,LPDWORD,LPOVERLAPPED *,DWORD);
UINT _stdcall SetErrorMode(UINT);
BOOL _stdcall ReadProcessMemory(HANDLE,LPCVOID,LPVOID,DWORD,LPDWORD);
BOOL _stdcall WriteProcessMemory(HANDLE,LPVOID,LPVOID,DWORD,LPDWORD);
BOOL _stdcall GetThreadContext(HANDLE,LPCONTEXT);
BOOL _stdcall SetThreadContext(HANDLE,const CONTEXT *);
DWORD _stdcall SuspendThread(HANDLE);
DWORD _stdcall ResumeThread(HANDLE);
 void _stdcall DebugBreak(void);
BOOL _stdcall WaitForDebugEvent(LPDEBUG_EVENT,DWORD);
BOOL _stdcall ContinueDebugEvent(DWORD,DWORD,DWORD);
BOOL _stdcall DebugActiveProcess(DWORD);
 void _stdcall InitializeCriticalSection(LPCRITICAL_SECTION);
 void _stdcall EnterCriticalSection(LPCRITICAL_SECTION);
 void _stdcall LeaveCriticalSection(LPCRITICAL_SECTION);
 void _stdcall DeleteCriticalSection(LPCRITICAL_SECTION);
BOOL _stdcall SetEvent(HANDLE);
BOOL _stdcall ResetEvent(HANDLE);
BOOL _stdcall PulseEvent(HANDLE);
BOOL _stdcall ReleaseSemaphore(HANDLE,LONG,LPLONG);
BOOL _stdcall ReleaseMutex(HANDLE);
DWORD _stdcall WaitForSingleObject(HANDLE,DWORD);
DWORD _stdcall WaitForMultipleObjects(DWORD,const HANDLE *,BOOL,DWORD);
 void _stdcall Sleep(DWORD);
HGLOBAL _stdcall LoadResource(HINSTANCE,HRSRC);
DWORD _stdcall SizeofResource(HINSTANCE,HRSRC);
ATOM _stdcall GlobalDeleteAtom(ATOM);
BOOL _stdcall InitAtomTable(DWORD);
ATOM _stdcall DeleteAtom(ATOM);
UINT _stdcall SetHandleCount(UINT);
DWORD _stdcall GetLogicalDrives(void);
BOOL _stdcall LockFile( HANDLE,DWORD,DWORD,DWORD,DWORD);
BOOL _stdcall UnlockFile(HANDLE,DWORD,DWORD,DWORD,DWORD);
BOOL _stdcall LockFileEx(HANDLE,DWORD,DWORD,DWORD,DWORD,LPOVERLAPPED);
BOOL _stdcall UnlockFileEx(HANDLE,DWORD,DWORD,DWORD,LPOVERLAPPED);
BOOL _stdcall GetFileInformationByHandle(HANDLE,LPBY_HANDLE_FILE_INFORMATION);
DWORD _stdcall GetFileType(HANDLE);
DWORD _stdcall GetFileSize(HANDLE,LPDWORD);
HANDLE _stdcall GetStdHandle(DWORD);
BOOL _stdcall SetStdHandle(DWORD,HANDLE);
BOOL _stdcall WriteFile(HANDLE,LPCVOID,DWORD,LPDWORD,LPOVERLAPPED);
BOOL _stdcall ReadFile(HANDLE,LPVOID,DWORD,LPDWORD,LPOVERLAPPED);
BOOL _stdcall FlushFileBuffers(HANDLE);
BOOL _stdcall DeviceIoControl(HANDLE,DWORD,LPVOID,DWORD,LPVOID,DWORD,LPDWORD,LPOVERLAPPED);
BOOL _stdcall SetEndOfFile(HANDLE);
DWORD _stdcall SetFilePointer(HANDLE,LONG,PLONG,DWORD);
BOOL _stdcall FindClose(HANDLE);
BOOL _stdcall GetFileTime(HANDLE,LPFILETIME,LPFILETIME,LPFILETIME);
BOOL _stdcall SetFileTime(HANDLE,const FILETIME *,const FILETIME *,const FILETIME *);
BOOL _stdcall CloseHandle(HANDLE);
BOOL _stdcall DuplicateHandle(HANDLE,HANDLE,HANDLE,LPHANDLE,DWORD,BOOL,DWORD);
BOOL _stdcall GetHandleInformation(HANDLE,LPDWORD);
BOOL _stdcall SetHandleInformation(HANDLE,DWORD,DWORD);
DWORD _stdcall LoadModule(LPCSTR,LPVOID);
UINT _stdcall WinExec(LPCSTR,UINT);
BOOL _stdcall ClearCommBreak(HANDLE);
BOOL _stdcall ClearCommError(HANDLE,LPDWORD,LPCOMSTAT);
BOOL _stdcall SetupComm(HANDLE,DWORD,DWORD);
BOOL _stdcall EscapeCommFunction(HANDLE,DWORD);
BOOL _stdcall GetCommConfig(HANDLE,LPCOMMCONFIG,LPDWORD);
BOOL _stdcall GetCommMask(HANDLE,LPDWORD);
BOOL _stdcall GetCommProperties(HANDLE,LPCOMMPROP);
BOOL _stdcall GetCommModemStatus(HANDLE,LPDWORD);
BOOL _stdcall GetCommState(HANDLE,LPDCB);
BOOL _stdcall GetCommTimeouts(HANDLE,LPCOMMTIMEOUTS);
BOOL _stdcall PurgeComm(HANDLE,DWORD);
BOOL _stdcall SetCommBreak(HANDLE);
BOOL _stdcall SetCommConfig(HANDLE,LPCOMMCONFIG,DWORD);
BOOL _stdcall SetCommMask(HANDLE,DWORD);
BOOL _stdcall SetCommState(HANDLE,LPDCB);
BOOL _stdcall SetCommTimeouts(HANDLE,LPCOMMTIMEOUTS);
BOOL _stdcall TransmitCommChar(HANDLE,char);
BOOL _stdcall WaitCommEvent(HANDLE,LPDWORD,LPOVERLAPPED);
DWORD _stdcall SetTapePosition(HANDLE,DWORD,DWORD,DWORD,DWORD,BOOL);
DWORD _stdcall GetTapePosition(HANDLE,DWORD,LPDWORD,LPDWORD,LPDWORD);
DWORD _stdcall PrepareTape(HANDLE,DWORD,BOOL);
DWORD _stdcall EraseTape(HANDLE,DWORD,BOOL);
DWORD _stdcall CreateTapePartition(HANDLE,DWORD,DWORD,DWORD);
DWORD _stdcall WriteTapemark(HANDLE,DWORD,DWORD,BOOL);
DWORD _stdcall GetTapeStatus(HANDLE);
DWORD _stdcall GetTapeParameters(HANDLE,DWORD,LPDWORD,LPVOID);
DWORD _stdcall SetTapeParameters( HANDLE,DWORD,LPVOID);
BOOL _stdcall Beep(DWORD,DWORD);
 void _stdcall OpenSound(void);
 void _stdcall CloseSound(void);
 void _stdcall StartSound(void);
 void _stdcall StopSound(void);
DWORD _stdcall WaitSoundState(DWORD);
DWORD _stdcall SyncAllVoices(void);
DWORD _stdcall CountVoiceNotes(DWORD nVoice);
LPDWORD _stdcall GetThresholdEvent(void);
DWORD _stdcall GetThresholdStatus(void);
DWORD _stdcall SetSoundNoise(DWORD,DWORD);
DWORD _stdcall SetVoiceAccent(DWORD,DWORD,DWORD,DWORD,DWORD);
DWORD _stdcall SetVoiceEnvelope(DWORD,DWORD,DWORD);
DWORD _stdcall SetVoiceNote(DWORD,DWORD,DWORD,DWORD);
DWORD _stdcall SetVoiceQueueSize(DWORD,DWORD);
DWORD _stdcall SetVoiceSound(DWORD,DWORD,DWORD);
DWORD _stdcall SetVoiceThreshold(DWORD,DWORD);
int _stdcall MulDiv(int,int,int);
 void _stdcall GetSystemTime(LPSYSTEMTIME);
BOOL _stdcall SetSystemTime(const SYSTEMTIME *);
 void _stdcall GetLocalTime(LPSYSTEMTIME);
BOOL _stdcall SetLocalTime(const SYSTEMTIME *);
 void _stdcall GetSystemInfo(LPSYSTEM_INFO);
BOOL _stdcall SystemTimeToTzSpecificLocalTime(LPTIME_ZONE_INFORMATION,LPSYSTEMTIME,LPSYSTEMTIME);
DWORD _stdcall GetTimeZoneInformation(LPTIME_ZONE_INFORMATION);
BOOL _stdcall SetTimeZoneInformation(const TIME_ZONE_INFORMATION *);
BOOL _stdcall SystemTimeToFileTime(const SYSTEMTIME *,LPFILETIME);
BOOL _stdcall FileTimeToLocalFileTime(FILETIME *,LPFILETIME);
BOOL _stdcall LocalFileTimeToFileTime(const FILETIME *,LPFILETIME);
BOOL _stdcall FileTimeToSystemTime(const FILETIME *,LPSYSTEMTIME);
LONG _stdcall CompareFileTime(const FILETIME *,const FILETIME *);
BOOL _stdcall FileTimeToDosDateTime(const FILETIME *,LPWORD,LPWORD);
BOOL _stdcall DosDateTimeToFileTime(WORD,WORD,LPFILETIME);
DWORD _stdcall GetTickCount(void);
BOOL _stdcall SetSystemTimeAdjustment(DWORD,BOOL);
BOOL _stdcall GetSystemTimeAdjustment(PDWORD,PDWORD,PWINBOOL);
BOOL _stdcall CreatePipe(PHANDLE,PHANDLE,LPSECURITY_ATTRIBUTES,DWORD);
BOOL _stdcall ConnectNamedPipe(HANDLE,LPOVERLAPPED);
BOOL _stdcall DisconnectNamedPipe(HANDLE);
BOOL _stdcall SetNamedPipeHandleState(HANDLE,LPDWORD,LPDWORD,LPDWORD);
BOOL _stdcall GetNamedPipeInfo(HANDLE,LPDWORD,LPDWORD,LPDWORD,LPDWORD);
BOOL _stdcall PeekNamedPipe(HANDLE,LPVOID,DWORD,LPDWORD,LPDWORD,LPDWORD);
BOOL _stdcall TransactNamedPipe(HANDLE,LPVOID,DWORD,LPVOID,DWORD,LPDWORD,LPOVERLAPPED);
BOOL _stdcall GetMailslotInfo(HANDLE,LPDWORD,LPDWORD,LPDWORD,LPDWORD);
BOOL _stdcall SetMailslotInfo(HANDLE,DWORD);
LPVOID _stdcall MapViewOfFile(HANDLE,DWORD,DWORD,DWORD,DWORD);
BOOL _stdcall FlushViewOfFile(LPCVOID,DWORD);
BOOL _stdcall UnmapViewOfFile(LPVOID);
HFILE _stdcall OpenFile(LPCSTR,LPOFSTRUCT,UINT);
HFILE _stdcall _lopen( LPCSTR,int);
HFILE _stdcall _lcreat(LPCSTR,int);
UINT _stdcall _lread(HFILE,LPVOID,UINT);
UINT _stdcall _lwrite(HFILE,LPCSTR,UINT);
long _stdcall _hread(HFILE,LPVOID,long);
long _stdcall _hwrite(HFILE,LPCSTR,long);
HFILE _stdcall _lclose(HFILE);
LONG _stdcall _llseek(HFILE,LONG,int);
BOOL _stdcall IsTextUnicode(const LPVOID,int,LPINT);
DWORD _stdcall TlsAlloc(void);
LPVOID _stdcall TlsGetValue(DWORD);
BOOL _stdcall TlsSetValue(DWORD,LPVOID);
BOOL _stdcall TlsFree(DWORD);
DWORD _stdcall SleepEx(DWORD,BOOL);
DWORD _stdcall WaitForSingleObjectEx(HANDLE,DWORD,BOOL);
DWORD _stdcall WaitForMultipleObjectsEx(DWORD,const HANDLE *,BOOL,DWORD,BOOL);
BOOL _stdcall ReadFileEx(HANDLE,LPVOID,DWORD,LPOVERLAPPED,LPOVERLAPPED_COMPLETION_ROUTINE);
BOOL _stdcall WriteFileEx( HANDLE,LPCVOID,DWORD,LPOVERLAPPED,LPOVERLAPPED_COMPLETION_ROUTINE);
BOOL _stdcall BackupRead(HANDLE,LPBYTE,DWORD,LPDWORD,BOOL,BOOL,LPVOID *);
BOOL _stdcall BackupSeek(HANDLE,DWORD,DWORD,LPDWORD,LPDWORD,LPVOID *);
BOOL _stdcall BackupWrite(HANDLE,LPBYTE,DWORD,LPDWORD,BOOL,BOOL,LPVOID *);
BOOL _stdcall SetProcessShutdownParameters(DWORD,DWORD);
BOOL _stdcall GetProcessShutdownParameters(LPDWORD,LPDWORD);
 void _stdcall SetFileApisToOEM(void);
 void _stdcall SetFileApisToANSI(void);
BOOL _stdcall AreFileApisANSI(void);
BOOL _stdcall CloseEventLog(HANDLE);
BOOL _stdcall DeregisterEventSource(HANDLE);
BOOL _stdcall NotifyChangeEventLog (HANDLE,HANDLE);
BOOL _stdcall GetNumberOfEventLogRecords(HANDLE,PDWORD);
BOOL _stdcall GetOldestEventLogRecord(HANDLE,PDWORD);
BOOL _stdcall DuplicateToken(HANDLE,SECURITY_IMPERSONATION_LEVEL,PHANDLE);
BOOL _stdcall GetKernelObjectSecurity(HANDLE,SECURITY_INFORMATION,PSECURITY_DESCRIPTOR,DWORD,LPDWORD);
BOOL _stdcall ImpersonateNamedPipeClient(HANDLE);
BOOL _stdcall ImpersonateSelf(SECURITY_IMPERSONATION_LEVEL);
BOOL _stdcall RevertToSelf(void);
BOOL _stdcall SetThreadToken (PHANDLE,HANDLE);
BOOL _stdcall AccessCheck(PSECURITY_DESCRIPTOR,HANDLE,DWORD,PGENERIC_MAPPING,PPRIVILEGE_SET,LPDWORD,LPDWORD,LPBOOL);
BOOL _stdcall OpenProcessToken(HANDLE,DWORD,PHANDLE);
BOOL _stdcall OpenThreadToken(HANDLE,DWORD,BOOL,PHANDLE);
BOOL _stdcall GetTokenInformation(HANDLE,TOKEN_INFORMATION_CLASS,LPVOID,DWORD,PDWORD);
BOOL _stdcall SetTokenInformation(HANDLE,TOKEN_INFORMATION_CLASS,LPVOID,DWORD);
BOOL _stdcall AdjustTokenPrivileges(HANDLE,BOOL,PTOKEN_PRIVILEGES,DWORD,PTOKEN_PRIVILEGES,PDWORD);
BOOL _stdcall AdjustTokenGroups (HANDLE,BOOL,PTOKEN_GROUPS,DWORD,PTOKEN_GROUPS,PDWORD);
BOOL _stdcall PrivilegeCheck (HANDLE,PPRIVILEGE_SET,LPBOOL);
BOOL _stdcall IsValidSid (PSID);
BOOL _stdcall EqualSid(PSID,PSID);
BOOL _stdcall EqualPrefixSid (PSID,PSID);
DWORD _stdcall GetSidLengthRequired(UCHAR);
BOOL _stdcall AllocateAndInitializeSid(PSID_IDENTIFIER_AUTHORITY,BYTE,DWORD,DWORD,DWORD,DWORD,DWORD,DWORD,DWORD,DWORD,PSID *);
PVOID _stdcall FreeSid(PSID);
BOOL _stdcall InitializeSid (PSID,PSID_IDENTIFIER_AUTHORITY,BYTE);
PSID_IDENTIFIER_AUTHORITY _stdcall GetSidIdentifierAuthority(PSID);
PDWORD _stdcall GetSidSubAuthority (PSID,DWORD);
PUCHAR _stdcall GetSidSubAuthorityCount (PSID);
DWORD _stdcall GetLengthSid (PSID);
BOOL _stdcall CopySid(DWORD,PSID,PSID);
BOOL _stdcall AreAllAccessesGranted (DWORD,DWORD);
BOOL _stdcall AreAnyAccessesGranted (DWORD,DWORD);
 void _stdcall MapGenericMask(PDWORD,PGENERIC_MAPPING);
BOOL _stdcall IsValidAcl(PACL);
BOOL _stdcall InitializeAcl(PACL,DWORD,DWORD);
BOOL _stdcall GetAclInformation(PACL,LPVOID,DWORD,ACL_INFORMATION_CLASS);
BOOL _stdcall SetAclInformation (PACL,LPVOID,DWORD,ACL_INFORMATION_CLASS);
BOOL _stdcall AddAce(PACL,DWORD,DWORD,LPVOID,DWORD);
BOOL _stdcall DeleteAce(PACL,DWORD);
BOOL _stdcall GetAce (PACL,DWORD,LPVOID *);
BOOL _stdcall AddAccessAllowedAce(PACL,DWORD,DWORD,PSID);
BOOL _stdcall AddAccessDeniedAce(PACL,DWORD,DWORD,PSID);
BOOL _stdcall AddAuditAccessAce(PACL,DWORD,DWORD,PSID,BOOL,BOOL);
BOOL _stdcall FindFirstFreeAce (PACL,LPVOID *);
BOOL _stdcall InitializeSecurityDescriptor(PSECURITY_DESCRIPTOR,DWORD);
BOOL _stdcall IsValidSecurityDescriptor(PSECURITY_DESCRIPTOR);
DWORD _stdcall GetSecurityDescriptorLength(PSECURITY_DESCRIPTOR);
BOOL _stdcall GetSecurityDescriptorControl(PSECURITY_DESCRIPTOR,PSECURITY_DESCRIPTOR_CONTROL,LPDWORD);
BOOL _stdcall SetSecurityDescriptorDacl(PSECURITY_DESCRIPTOR,BOOL,PACL,BOOL);
BOOL _stdcall GetSecurityDescriptorDacl(PSECURITY_DESCRIPTOR,LPBOOL,PACL *,LPBOOL);
BOOL _stdcall SetSecurityDescriptorSacl(PSECURITY_DESCRIPTOR,BOOL,PACL,BOOL);
BOOL _stdcall GetSecurityDescriptorSacl(PSECURITY_DESCRIPTOR,LPBOOL,PACL *,LPBOOL);
BOOL _stdcall SetSecurityDescriptorOwner(PSECURITY_DESCRIPTOR,PSID pOwner,BOOL);
BOOL _stdcall GetSecurityDescriptorOwner(PSECURITY_DESCRIPTOR,PSID *,LPBOOL);
BOOL _stdcall SetSecurityDescriptorGroup(PSECURITY_DESCRIPTOR,PSID,BOOL);
BOOL _stdcall GetSecurityDescriptorGroup(PSECURITY_DESCRIPTOR,PSID *,LPBOOL);
BOOL _stdcall CreatePrivateObjectSecurity(PSECURITY_DESCRIPTOR,PSECURITY_DESCRIPTOR,PSECURITY_DESCRIPTOR *,BOOL,HANDLE,PGENERIC_MAPPING);
BOOL _stdcall SetPrivateObjectSecurity(SECURITY_INFORMATION,PSECURITY_DESCRIPTOR,PSECURITY_DESCRIPTOR *,PGENERIC_MAPPING,HANDLE);
BOOL _stdcall GetPrivateObjectSecurity(PSECURITY_DESCRIPTOR,SECURITY_INFORMATION,PSECURITY_DESCRIPTOR,DWORD,PDWORD);
BOOL _stdcall DestroyPrivateObjectSecurity(PSECURITY_DESCRIPTOR *);
BOOL _stdcall MakeSelfRelativeSD(PSECURITY_DESCRIPTOR,PSECURITY_DESCRIPTOR,LPDWORD);
BOOL _stdcall MakeAbsoluteSD(PSECURITY_DESCRIPTOR,PSECURITY_DESCRIPTOR,LPDWORD,PACL,LPDWORD,PACL,LPDWORD,PSID,LPDWORD,PSID,LPDWORD);
BOOL _stdcall SetKernelObjectSecurity(HANDLE,SECURITY_INFORMATION,PSECURITY_DESCRIPTOR);
BOOL _stdcall FindNextChangeNotification(HANDLE);
BOOL _stdcall FindCloseChangeNotification(HANDLE);
BOOL _stdcall VirtualLock(LPVOID,DWORD);
BOOL _stdcall VirtualUnlock(LPVOID,DWORD);
LPVOID _stdcall MapViewOfFileEx(HANDLE,DWORD,DWORD,DWORD,DWORD,LPVOID);
BOOL _stdcall SetPriorityClass(HANDLE,DWORD);
DWORD _stdcall GetPriorityClass(HANDLE);
BOOL _stdcall IsBadReadPtr(const void *,UINT);
BOOL _stdcall IsBadWritePtr(LPVOID,UINT);
BOOL _stdcall IsBadHugeReadPtr(const void *,UINT);
BOOL _stdcall IsBadHugeWritePtr(LPVOID,UINT);
BOOL _stdcall IsBadCodePtr(FARPROC);
BOOL _stdcall AllocateLocallyUniqueId(PLUID);
BOOL _stdcall QueryPerformanceCounter(LARGE_INTEGER *);
BOOL _stdcall QueryPerformanceFrequency(LARGE_INTEGER *);
 void _stdcall MoveMemory(PVOID,const void *,DWORD);
 void _stdcall FillMemory(PVOID,DWORD,BYTE);
 void _stdcall ZeroMemory(PVOID,DWORD);



BOOL _stdcall ActivateKeyboardLayout(HKL,UINT);

int _stdcall ToUnicodeEx(UINT,UINT,PBYTE,LPWSTR,int,UINT,HKL);
BOOL _stdcall UnloadKeyboardLayout(HKL);
int _stdcall GetKeyboardLayoutList(int,HKL *);
HKL _stdcall GetKeyboardLayout(DWORD);
HDESK _stdcall OpenInputDesktop(DWORD,BOOL,DWORD);
BOOL _stdcall EnumDesktopWindows(HDESK,ENUMWINDOWSPROC,LPARAM);
BOOL _stdcall SwitchDesktop(HDESK);
BOOL _stdcall SetThreadDesktop(HDESK);
BOOL _stdcall CloseDesktop(HDESK);
HDESK _stdcall GetThreadDesktop(DWORD);
BOOL _stdcall CloseWindowStation(HWINSTA);
BOOL _stdcall SetProcessWindowStation(HWINSTA);
HWINSTA _stdcall GetProcessWindowStation(void);
BOOL _stdcall SetUserObjectSecurity(HANDLE,PSECURITY_INFORMATION,PSECURITY_DESCRIPTOR);
BOOL _stdcall GetUserObjectSecurity(HANDLE,PSECURITY_INFORMATION,PSECURITY_DESCRIPTOR,DWORD,LPDWORD);
BOOL _stdcall TranslateMessage(const MSG *);
BOOL _stdcall SetMessageQueue(int);
BOOL _stdcall RegisterHotKey(HWND,int,UINT,UINT);
BOOL _stdcall UnregisterHotKey(HWND,int);
BOOL _stdcall ExitWindowsEx(UINT,DWORD);
BOOL _stdcall SwapMouseButton(BOOL);
DWORD _stdcall GetMessagePos(void);
LONG _stdcall GetMessageTime(void);
LONG _stdcall GetMessageExtraInfo(void);
LPARAM _stdcall SetMessageExtraInfo(LPARAM);
long _stdcall BroadcastSystemMessage(DWORD,LPDWORD,UINT,WPARAM,LPARAM);
BOOL _stdcall AttachThreadInput(DWORD,DWORD,BOOL);
BOOL _stdcall ReplyMessage(LRESULT);
BOOL _stdcall WaitMessage(void);
DWORD _stdcall WaitForInputIdle(HANDLE,DWORD);
 void _stdcall PostQuitMessage(int);
BOOL _stdcall InSendMessage(void);
UINT _stdcall GetDoubleClickTime(void);
BOOL _stdcall SetDoubleClickTime(UINT);
BOOL _stdcall IsWindow(HWND);
BOOL _stdcall IsMenu(HMENU);
BOOL _stdcall IsChild(HWND,HWND);
BOOL _stdcall DestroyWindow(HWND);
BOOL _stdcall ShowWindow(HWND,int);
BOOL _stdcall ShowWindowAsync(HWND,int);
BOOL _stdcall FlashWindow(HWND,BOOL);
BOOL _stdcall ShowOwnedPopups(HWND,BOOL);
BOOL _stdcall OpenIcon(HWND);
BOOL _stdcall CloseWindow(HWND);
BOOL _stdcall MoveWindow(HWND,int,int,int,int,BOOL);
BOOL _stdcall SetWindowPos(HWND,HWND,int,int,int,int,UINT);
BOOL _stdcall GetWindowPlacement(HWND,WINDOWPLACEMENT *);
BOOL _stdcall SetWindowPlacement(HWND hWnd,const WINDOWPLACEMENT *);
HDWP _stdcall BeginDeferWindowPos(int);
HDWP _stdcall DeferWindowPos(HDWP,HWND,HWND,int,int,int,int,UINT);
BOOL _stdcall EndDeferWindowPos(HDWP);
BOOL _stdcall IsWindowVisible(HWND);
BOOL _stdcall IsIconic(HWND);
BOOL _stdcall AnyPopup(void);
BOOL _stdcall BringWindowToTop(HWND);
BOOL _stdcall IsZoomed(HWND);
BOOL _stdcall EndDialog(HWND,int);
HWND _stdcall GetDlgItem(HWND,int);
BOOL _stdcall SetDlgItemInt(HWND,int,UINT,BOOL);
UINT _stdcall GetDlgItemInt(HWND,int,BOOL *,BOOL);
BOOL _stdcall CheckDlgButton(HWND,int,UINT);
BOOL _stdcall CheckRadioButton(HWND,int,int,int);
UINT _stdcall IsDlgButtonChecked(HWND,int);
HWND _stdcall GetNextDlgGroupItem(HWND,HWND,BOOL);
HWND _stdcall GetNextDlgTabItem(HWND,HWND,BOOL);
int _stdcall GetDlgCtrlID(HWND);
long _stdcall GetDialogBaseUnits(void);
BOOL _stdcall OpenClipboard(HWND);
BOOL _stdcall CloseClipboard(void);
HWND _stdcall GetClipboardOwner(void);
HWND _stdcall SetClipboardViewer(HWND);
HWND _stdcall GetClipboardViewer(void);
BOOL _stdcall ChangeClipboardChain(HWND,HWND);
HANDLE _stdcall SetClipboardData(UINT,HANDLE);
HANDLE _stdcall GetClipboardData(UINT);
int _stdcall CountClipboardFormats(void);
UINT _stdcall EnumClipboardFormats(UINT);
BOOL _stdcall EmptyClipboard(void);
BOOL _stdcall IsClipboardFormatAvailable(UINT);
int _stdcall GetPriorityClipboardFormat(UINT *,int);
HWND _stdcall GetOpenClipboardWindow(void);
LPSTR _stdcall CharNextExA(WORD,LPCSTR,DWORD);
LPSTR _stdcall CharPrevExA(WORD,LPCSTR,LPCSTR,DWORD dwFlags);
HWND _stdcall SetFocus(HWND);
HWND _stdcall GetActiveWindow(void);
HWND _stdcall GetFocus(void);
UINT _stdcall GetKBCodePage(void);
SHORT _stdcall GetKeyState(int);
SHORT _stdcall GetAsyncKeyState(int);
BOOL _stdcall GetKeyboardState(PBYTE);
BOOL _stdcall SetKeyboardState(LPBYTE);
int _stdcall GetKeyboardType(int);
int _stdcall ToAscii(UINT,UINT,PBYTE,LPWORD,UINT);
int _stdcall ToAsciiEx(UINT,UINT,PBYTE,LPWORD,UINT,HKL);
int _stdcall ToUnicode(UINT,UINT,PBYTE,LPWSTR,int,UINT);
DWORD _stdcall OemKeyScan(WORD);
 void _stdcall keybd_event(BYTE,BYTE,DWORD,DWORD);
 void _stdcall mouse_event(DWORD,DWORD,DWORD,DWORD,DWORD);
BOOL _stdcall GetInputState(void);
DWORD _stdcall GetQueueStatus(UINT flags);
HWND _stdcall GetCapture(void);
HWND _stdcall SetCapture(HWND hWnd);
BOOL _stdcall ReleaseCapture(void);
DWORD _stdcall MsgWaitForMultipleObjects(DWORD,LPHANDLE,BOOL,DWORD,DWORD);
UINT _stdcall SetTimer(HWND,UINT,UINT,TIMERPROC);
BOOL _stdcall KillTimer(HWND,UINT);
BOOL _stdcall IsWindowUnicode(HWND);
BOOL _stdcall EnableWindow(HWND,BOOL);
BOOL _stdcall IsWindowEnabled(HWND);
BOOL _stdcall DestroyAcceleratorTable(HACCEL);
int _stdcall GetSystemMetrics(int);
HMENU _stdcall GetMenu(HWND);
BOOL _stdcall SetMenu(HWND,HMENU);
BOOL _stdcall HiliteMenuItem(HWND,HMENU,UINT,UINT);
UINT _stdcall GetMenuState(HMENU,UINT,UINT);
BOOL _stdcall DrawMenuBar(HWND);
HMENU _stdcall GetSystemMenu(HWND,BOOL);
HMENU _stdcall CreateMenu(void);
HMENU _stdcall CreatePopupMenu(void);
BOOL _stdcall DestroyMenu(HMENU);
DWORD _stdcall CheckMenuItem(HMENU,UINT,UINT);
BOOL _stdcall EnableMenuItem(HMENU,UINT,UINT);
HMENU _stdcall GetSubMenu(HMENU,int);
UINT _stdcall GetMenuItemID(HMENU,int);
int _stdcall GetMenuItemCount(HMENU);
BOOL _stdcall RemoveMenu(HMENU,UINT,UINT);
BOOL _stdcall DeleteMenu(HMENU,UINT,UINT);
BOOL _stdcall SetMenuItemBitmaps(HMENU,UINT,UINT,HBITMAP,HBITMAP);
LONG _stdcall GetMenuCheckMarkDimensions(void);
BOOL _stdcall TrackPopupMenu(HMENU,UINT,int,int,int,HWND,const RECT *);
UINT _stdcall GetMenuDefaultItem(HMENU,UINT,UINT);
BOOL _stdcall SetMenuDefaultItem(HMENU,UINT,UINT);
BOOL _stdcall GetMenuItemRect(HWND,HMENU,UINT,LPRECT);
int _stdcall MenuItemFromPoint(HWND,HMENU,POINT);
DWORD _stdcall DragObject(HWND,HWND,UINT,DWORD,HCURSOR);
BOOL _stdcall DragDetect(HWND,POINT);
BOOL _stdcall DrawIcon(HDC,int,int,HICON);
BOOL _stdcall UpdateWindow(HWND);
HWND _stdcall SetActiveWindow(HWND);
HWND _stdcall GetForegroundWindow(void);
BOOL _stdcall PaintDesktop(HDC);
BOOL _stdcall SetForegroundWindow(HWND hWnd);
HWND _stdcall WindowFromDC(HDC hDC);
HDC _stdcall GetDC(HWND);
HDC _stdcall GetDCEx(HWND,HRGN,DWORD);
HDC _stdcall GetWindowDC(HWND);
int _stdcall ReleaseDC(HWND,HDC);
HDC _stdcall BeginPaint( HWND,LPPAINTSTRUCT);
BOOL _stdcall EndPaint(HWND,const PAINTSTRUCT *);
BOOL _stdcall GetUpdateRect(HWND,LPRECT,BOOL);
int _stdcall GetUpdateRgn(HWND,HRGN,BOOL);
int _stdcall SetWindowRgn(HWND,HRGN,BOOL);
int _stdcall GetWindowRgn(HWND,HRGN);
int _stdcall ExcludeUpdateRgn(HDC,HWND);
BOOL _stdcall InvalidateRect(HWND,const RECT *,BOOL);
BOOL _stdcall ValidateRect(HWND,const RECT *);
BOOL _stdcall InvalidateRgn(HWND,HRGN,BOOL);
BOOL _stdcall ValidateRgn(HWND,HRGN);
BOOL _stdcall RedrawWindow(HWND,const RECT *,HRGN,UINT);
BOOL _stdcall LockWindowUpdate(HWND );
BOOL _stdcall ScrollWindow(HWND,int,int,const RECT *,const RECT *);
BOOL _stdcall ScrollDC(HDC,int,int,const RECT *,const RECT *,HRGN,LPRECT);
int _stdcall ScrollWindowEx(HWND,int,int,const RECT *,const RECT *,HRGN,LPRECT,UINT);
int _stdcall SetScrollPos(HWND,int,int,BOOL);
int _stdcall GetScrollPos(HWND,int);
BOOL _stdcall SetScrollRange(HWND,int,int,int,BOOL);
BOOL _stdcall GetScrollRange(HWND,int,LPINT,LPINT);
BOOL _stdcall ShowScrollBar(HWND,int,BOOL);
BOOL _stdcall EnableScrollBar(HWND,UINT,UINT);
BOOL _stdcall GetClientRect(HWND,LPRECT);
BOOL _stdcall GetWindowRect(HWND,LPRECT);
BOOL _stdcall AdjustWindowRect(LPRECT,DWORD,BOOL);
BOOL _stdcall AdjustWindowRectEx(LPRECT,DWORD,BOOL,DWORD);
BOOL _stdcall SetWindowContextHelpId(HWND,DWORD);
DWORD _stdcall GetWindowContextHelpId(HWND);
BOOL _stdcall SetMenuContextHelpId(HMENU,DWORD);
DWORD _stdcall GetMenuContextHelpId(HMENU);
BOOL _stdcall MessageBeep(UINT);
int _stdcall ShowCursor(BOOL);
BOOL _stdcall SetCursorPos(int,int);
HCURSOR _stdcall SetCursor(HCURSOR);
BOOL _stdcall GetCursorPos(PPOINT);
BOOL _stdcall ClipCursor(const RECT *);
BOOL _stdcall GetClipCursor(LPRECT);
HCURSOR _stdcall GetCursor(void);
BOOL _stdcall CreateCaret(HWND,HBITMAP,int,int);
UINT _stdcall GetCaretBlinkTime(void);
BOOL _stdcall SetCaretBlinkTime(UINT);
BOOL _stdcall DestroyCaret(void);
BOOL _stdcall HideCaret(HWND);
BOOL _stdcall ShowCaret(HWND);
BOOL _stdcall SetCaretPos(int,int);
BOOL _stdcall GetCaretPos(PPOINT);
BOOL _stdcall ClientToScreen(HWND,PPOINT);
BOOL _stdcall ScreenToClient(HWND,PPOINT);
int _stdcall MapWindowPoints(HWND,HWND,PPOINT,UINT);
HWND _stdcall WindowFromPoint(POINT);
HWND _stdcall ChildWindowFromPoint(HWND,POINT);
DWORD _stdcall GetSysColor(int);
HBRUSH _stdcall GetSysColorBrush(int);
BOOL _stdcall SetSysColors(int,const INT *,const COLORREF *);
BOOL _stdcall DrawFocusRect(HDC,const RECT *);
int _stdcall FillRect(HDC,const RECT *,HBRUSH);
int _stdcall FrameRect(HDC,const RECT *,HBRUSH);
BOOL _stdcall InvertRect(HDC,const RECT *);
BOOL _stdcall SetRect(LPRECT,int,int,int,int);
BOOL _stdcall SetRectEmpty(LPRECT);
BOOL _stdcall CopyRect(LPRECT,const RECT *);
BOOL _stdcall InflateRect(LPRECT,int,int);
BOOL _stdcall IntersectRect(LPRECT,const RECT *,const RECT *);
BOOL _stdcall UnionRect(LPRECT,const RECT *,const RECT *);
BOOL _stdcall SubtractRect(LPRECT,const RECT *,const RECT *);
BOOL _stdcall OffsetRect(LPRECT,int,int);
BOOL _stdcall IsRectEmpty(const RECT *);
BOOL _stdcall EqualRect(const RECT *,const RECT *);
BOOL _stdcall PtInRect(const RECT *lprc,POINT pt);
WORD _stdcall GetWindowWord(HWND,int);
WORD _stdcall SetWindowWord(HWND,int,WORD);
WORD _stdcall GetClassWord(HWND,int);
WORD _stdcall SetClassWord(HWND,int,WORD);
HWND _stdcall GetDesktopWindow(void);
HWND _stdcall GetParent( HWND hWnd);
HWND _stdcall SetParent( HWND,HWND);
BOOL _stdcall EnumChildWindows(HWND,ENUMWINDOWSPROC,LPARAM);
BOOL _stdcall EnumWindows(ENUMWINDOWSPROC,LPARAM );
BOOL _stdcall EnumThreadWindows(DWORD,ENUMWINDOWSPROC,LPARAM);
HWND _stdcall GetTopWindow(HWND hWnd);
DWORD _stdcall GetWindowThreadProcessId( HWND,LPDWORD);
HWND _stdcall GetLastActivePopup( HWND hWnd);
HWND _stdcall GetWindow( HWND hWnd,UINT uCmd);
BOOL _stdcall UnhookWindowsHook(int,HOOKPROC);
BOOL _stdcall UnhookWindowsHookEx( HHOOK hhk);
LRESULT _stdcall CallNextHookEx(HHOOK,int,WPARAM,LPARAM);
BOOL _stdcall CheckMenuRadioItem(HMENU,UINT,UINT,UINT,UINT);
HCURSOR _stdcall CreateCursor(HINSTANCE,int,int,int,int,const void *,const void *);
BOOL _stdcall DestroyCursor(HCURSOR);
BOOL _stdcall SetSystemCursor( HCURSOR,DWORD);
HICON _stdcall CreateIcon(HINSTANCE,int,int,BYTE,BYTE,const BYTE *,const BYTE *);
BOOL _stdcall DestroyIcon(HICON);
int _stdcall LookupIconIdFromDirectory(PBYTE,BOOL);
int _stdcall LookupIconIdFromDirectoryEx(PBYTE,BOOL,int,int,UINT);
HICON _stdcall CreateIconFromResource(PBYTE,DWORD,BOOL,DWORD);
HICON _stdcall CreateIconFromResourceEx(PBYTE,DWORD,BOOL,DWORD,int,int,UINT);
HICON _stdcall CopyImage( HANDLE,UINT,int,int,UINT);
HICON _stdcall CreateIconIndirect(PICONINFO);
HICON _stdcall CopyIcon(HICON);
BOOL _stdcall GetIconInfo( HICON hIcon,PICONINFO piconinfo);
BOOL _stdcall MapDialogRect( HWND hDlg,LPRECT lpRect);
int _stdcall SetScrollInfo(HWND,int,LPCSCROLLINFO,BOOL);
BOOL _stdcall GetScrollInfo(HWND,int,LPSCROLLINFO);
BOOL _stdcall TranslateMDISysAccel(HWND,LPMSG);
UINT _stdcall ArrangeIconicWindows(HWND);
WORD _stdcall TileWindows(HWND,UINT,const RECT *,UINT,const HWND *);
WORD _stdcall CascadeWindows(HWND,UINT,const RECT *,UINT,const HWND *);
 void _stdcall SetLastErrorEx(DWORD,DWORD);
 void _stdcall SetDebugErrorLevel(DWORD);
BOOL _stdcall DrawEdge(HDC,LPRECT,UINT,UINT);
BOOL _stdcall DrawFrameControl(HDC,LPRECT,UINT,UINT);
BOOL _stdcall DrawCaption(HWND,HDC,const RECT *,UINT);
BOOL _stdcall DrawAnimatedRects(HWND,int,const RECT *,const RECT *);
BOOL _stdcall TrackPopupMenuEx(HMENU,UINT,int,int,HWND,LPTPMPARAMS);
HWND _stdcall ChildWindowFromPointEx(HWND,POINT,UINT);
BOOL _stdcall DrawIconEx(HDC,int,int,HICON,int,int,UINT,HBRUSH,UINT);
BOOL _stdcall AnimatePalette(HPALETTE,UINT,UINT,const PALETTEENTRY *);
BOOL _stdcall Arc(HDC,int,int,int,int,int,int,int,int);
BOOL _stdcall BitBlt(HDC,int,int,int,int,HDC,int,int,DWORD);
BOOL _stdcall CancelDC(HDC);
BOOL _stdcall Chord(HDC,int,int,int,int,int,int,int,int);
HMETAFILE _stdcall CloseMetaFile(HDC);
int _stdcall CombineRgn(HRGN,HRGN,HRGN,int);
HBITMAP _stdcall CreateBitmap(int,int,UINT,UINT,const void *);
HBITMAP _stdcall CreateBitmapIndirect(const BITMAP *);
HBRUSH _stdcall CreateBrushIndirect(const LOGBRUSH *);
HBITMAP _stdcall CreateCompatibleBitmap(HDC,int,int);
HBITMAP _stdcall CreateDiscardableBitmap(HDC,int,int);
HDC _stdcall CreateCompatibleDC(HDC);
HBITMAP _stdcall CreateDIBitmap(HDC,const BITMAPINFOHEADER *,DWORD,const void *,const BITMAPINFO *,UINT);
HBRUSH _stdcall CreateDIBPatternBrush(HGLOBAL,UINT);
HBRUSH _stdcall CreateDIBPatternBrushPt(const void *,UINT);
HRGN _stdcall CreateEllipticRgn(int,int,int,int);
HRGN _stdcall CreateEllipticRgnIndirect(const RECT *);
HBRUSH _stdcall CreateHatchBrush(int,COLORREF);
HPALETTE _stdcall CreatePalette(const LOGPALETTE *);
HPEN _stdcall CreatePen(int,int,COLORREF);
HPEN _stdcall CreatePenIndirect(const LOGPEN *);
HRGN _stdcall CreatePolyPolygonRgn(const POINT *,const INT *,int,int);
HBRUSH _stdcall CreatePatternBrush(HBITMAP);
HRGN _stdcall CreateRectRgn(int,int,int,int);
HRGN _stdcall CreateRectRgnIndirect(const RECT *);
HRGN _stdcall CreateRoundRectRgn(int,int,int,int,int,int);
HBRUSH _stdcall CreateSolidBrush(COLORREF);
BOOL _stdcall DeleteDC(HDC);
BOOL _stdcall DeleteMetaFile(HMETAFILE);
BOOL _stdcall DeleteObject(HGDIOBJ);
int _stdcall DescribePixelFormat(HDC, int, UINT, LPPIXELFORMATDESCRIPTOR);
BOOL _stdcall SwapBuffers(HDC);
int _stdcall DrawEscape(HDC,int,int,LPCSTR);
BOOL _stdcall Ellipse(HDC,int,int,int,int);
int _stdcall EnumObjects(HDC,int,ENUMOBJECTSPROC,LPARAM);
BOOL _stdcall EqualRgn(HRGN,HRGN);
int _stdcall Escape(HDC,int,int,LPCSTR,LPVOID);
int _stdcall ExtEscape(HDC,int,int,LPCSTR,int,LPSTR);
int _stdcall ExcludeClipRect(HDC,int,int,int,int);
HRGN _stdcall ExtCreateRegion(const XFORM *,DWORD,const RGNDATA *);
BOOL _stdcall ExtFloodFill(HDC,int,int,COLORREF,UINT);
BOOL _stdcall FillRgn(HDC,HRGN,HBRUSH);
BOOL _stdcall FloodFill(HDC,int,int,COLORREF);
BOOL _stdcall FrameRgn(HDC,HRGN,HBRUSH,int,int);
int _stdcall GetROP2(HDC);
BOOL _stdcall GetAspectRatioFilterEx(HDC,LPSIZE);
COLORREF _stdcall GetBkColor(HDC);
int _stdcall GetBkMode(HDC);
LONG _stdcall GetBitmapBits(HBITMAP,LONG,LPVOID);
BOOL _stdcall GetBitmapDimensionEx(HBITMAP,LPSIZE);
UINT _stdcall GetBoundsRect(HDC,LPRECT,UINT);
BOOL _stdcall GetBrushOrgEx(HDC,PPOINT);
int _stdcall GetClipBox(HDC,LPRECT);
int _stdcall GetClipRgn(HDC,HRGN);
int _stdcall GetMetaRgn(HDC,HRGN);
HGDIOBJ _stdcall GetCurrentObject(HDC,UINT);
BOOL _stdcall GetCurrentPositionEx(HDC,PPOINT);
int _stdcall GetDeviceCaps(HDC,int);
int _stdcall GetDIBits(HDC,HBITMAP,UINT,UINT,LPVOID,LPBITMAPINFO,UINT);
DWORD _stdcall GetFontData(HDC,DWORD,DWORD,LPVOID,DWORD);
int _stdcall GetGraphicsMode(HDC);
int _stdcall GetMapMode(HDC);
UINT _stdcall GetMetaFileBitsEx(HMETAFILE,UINT,LPVOID);
COLORREF _stdcall GetNearestColor(HDC,COLORREF);
UINT _stdcall GetNearestPaletteIndex(HPALETTE,COLORREF);
DWORD _stdcall GetObjectType(HGDIOBJ);
UINT _stdcall GetPaletteEntries(HPALETTE,UINT,UINT,LPPALETTEENTRY);
COLORREF _stdcall GetPixel(HDC,int,int);
int _stdcall GetPixelFormat(HDC);
int _stdcall GetPolyFillMode(HDC);
BOOL _stdcall GetRasterizerCaps(LPRASTERIZER_STATUS,UINT);
DWORD _stdcall GetRegionData(HRGN,DWORD,LPRGNDATA);
int _stdcall GetRgnBox(HRGN,LPRECT);
HGDIOBJ _stdcall GetStockObject(int);
int _stdcall GetStretchBltMode(HDC);
UINT _stdcall GetSystemPaletteEntries(HDC,UINT,UINT,LPPALETTEENTRY);
UINT _stdcall GetSystemPaletteUse(HDC);
int _stdcall GetTextCharacterExtra(HDC);
UINT _stdcall GetTextAlign(HDC);
COLORREF _stdcall GetTextColor(HDC);
int _stdcall GetTextCharset(HDC);
int _stdcall GetTextCharsetInfo(HDC,LPFONTSIGNATURE,DWORD);
BOOL _stdcall TranslateCharsetInfo( DWORD *,LPCHARSETINFO,DWORD);
DWORD _stdcall GetFontLanguageInfo(HDC);
BOOL _stdcall GetViewportExtEx(HDC,LPSIZE);
BOOL _stdcall GetViewportOrgEx(HDC,PPOINT);
BOOL _stdcall GetWindowExtEx(HDC,LPSIZE);
BOOL _stdcall GetWindowOrgEx(HDC,PPOINT);
int _stdcall IntersectClipRect(HDC,int,int,int,int);
BOOL _stdcall InvertRgn(HDC,HRGN);
BOOL _stdcall LineDDA(int,int,int,int,LINEDDAPROC,LPARAM);
BOOL _stdcall LineTo(HDC,int,int);
BOOL _stdcall MaskBlt(HDC,int,int,int,int,HDC,int,int,HBITMAP,int,int,DWORD);
BOOL _stdcall PlgBlt(HDC,const POINT *,HDC,int,int,int,int,HBITMAP,int,int);
int _stdcall OffsetClipRgn(HDC,int,int);
int _stdcall OffsetRgn(HRGN,int,int);
BOOL _stdcall PatBlt(HDC,int,int,int,int,DWORD);
BOOL _stdcall Pie(HDC,int,int,int,int,int,int,int,int);
BOOL _stdcall PlayMetaFile(HDC,HMETAFILE);
BOOL _stdcall PaintRgn(HDC,HRGN);
BOOL _stdcall PolyPolygon(HDC,const POINT *,const INT *,int);
BOOL _stdcall PtInRegion(HRGN,int,int);
BOOL _stdcall PtVisible(HDC,int,int);
BOOL _stdcall RectInRegion(HRGN,const RECT *);
BOOL _stdcall RectVisible(HDC,const RECT *);
BOOL _stdcall Rectangle(HDC,int,int,int,int);
BOOL _stdcall RestoreDC(HDC,int);
UINT _stdcall RealizePalette(HDC);
BOOL _stdcall RoundRect(HDC,int,int,int,int,int,int);
BOOL _stdcall ResizePalette(HPALETTE,UINT);
int _stdcall SaveDC(HDC);
int _stdcall SelectClipRgn(HDC,HRGN);
int _stdcall ExtSelectClipRgn(HDC,HRGN,int);
int _stdcall SetMetaRgn(HDC);
HGDIOBJ _stdcall SelectObject(HDC,HGDIOBJ);
HPALETTE _stdcall SelectPalette(HDC,HPALETTE,BOOL);
COLORREF _stdcall SetBkColor(HDC,COLORREF);
int _stdcall SetBkMode(HDC,int);
LONG _stdcall SetBitmapBits(HBITMAP,DWORD,const void *);
UINT _stdcall SetBoundsRect(HDC,const RECT *,UINT);
int _stdcall SetDIBits(HDC,HBITMAP,UINT,UINT,const void *,const BITMAPINFO *,UINT);
int _stdcall SetDIBitsToDevice(HDC,int,int,DWORD,DWORD,int,int,UINT,UINT,const void *,const BITMAPINFO *,UINT);
DWORD _stdcall SetMapperFlags(HDC,DWORD);
int _stdcall SetGraphicsMode(HDC,int);
int _stdcall SetMapMode(HDC,int);
HMETAFILE _stdcall SetMetaFileBitsEx(UINT,const BYTE *);
UINT _stdcall SetPaletteEntries(HPALETTE,UINT,UINT,const PALETTEENTRY *);
COLORREF _stdcall SetPixel(HDC,int,int,COLORREF);
BOOL _stdcall SetPixelV(HDC,int,int,COLORREF);
int _stdcall SetPolyFillMode(HDC,int);
BOOL _stdcall StretchBlt(HDC,int,int,int,int,HDC,int,int,int,int,DWORD);
BOOL _stdcall SetRectRgn(HRGN,int,int,int,int);
int _stdcall StretchDIBits(HDC,int,int,int,int,int,int,int,int,const void *,const BITMAPINFO *,UINT,DWORD);
int _stdcall SetROP2(HDC,int);
int _stdcall SetStretchBltMode(HDC,int);
UINT _stdcall SetSystemPaletteUse(HDC,UINT);
int _stdcall SetTextCharacterExtra(HDC,int);
COLORREF _stdcall SetTextColor(HDC,COLORREF);
UINT _stdcall SetTextAlign(HDC,UINT);
BOOL _stdcall SetTextJustification(HDC,int,int);
BOOL _stdcall UpdateColors(HDC);
BOOL _stdcall PlayMetaFileRecord(HDC,LPHANDLETABLE,LPMETARECORD,UINT);
BOOL _stdcall EnumMetaFile(HDC,HMETAFILE,ENUMMETAFILEPROC,LPARAM);
HENHMETAFILE _stdcall CloseEnhMetaFile(HDC);
BOOL _stdcall DeleteEnhMetaFile(HENHMETAFILE);
BOOL _stdcall EnumEnhMetaFile(HDC,HENHMETAFILE,ENHMETAFILEPROC,LPVOID,const RECT *);
UINT _stdcall GetEnhMetaFileHeader(HENHMETAFILE,UINT,LPENHMETAHEADER );
UINT _stdcall GetEnhMetaFilePaletteEntries(HENHMETAFILE,UINT,LPPALETTEENTRY );
UINT _stdcall GetWinMetaFileBits(HENHMETAFILE,UINT,LPBYTE,INT,HDC);
BOOL _stdcall PlayEnhMetaFile(HDC,HENHMETAFILE,const RECT *);
BOOL _stdcall PlayEnhMetaFileRecord(HDC,LPHANDLETABLE,const ENHMETARECORD *,UINT);
HENHMETAFILE _stdcall SetEnhMetaFileBits(UINT,const BYTE *);
HENHMETAFILE _stdcall SetWinMetaFileBits(UINT,const BYTE *,HDC,const METAFILEPICT *);
BOOL _stdcall GdiComment(HDC,UINT,const BYTE *);
BOOL _stdcall AngleArc(HDC,int,int,DWORD,FLOAT,FLOAT);
BOOL _stdcall PolyPolyline(HDC,const POINT *,const DWORD *,DWORD);
BOOL _stdcall GetWorldTransform(HDC,LPXFORM);
BOOL _stdcall SetWorldTransform(HDC,const XFORM *);
BOOL _stdcall ModifyWorldTransform(HDC,const XFORM *,DWORD);
BOOL _stdcall CombineTransform(LPXFORM,const XFORM *,const XFORM *);
HBITMAP _stdcall CreateDIBSection(HDC,const BITMAPINFO *,UINT,void **,HANDLE,DWORD);
UINT _stdcall GetDIBColorTable(HDC,UINT,UINT,RGBQUAD *);
UINT _stdcall SetDIBColorTable(HDC,UINT,UINT,const RGBQUAD *);
BOOL _stdcall SetColorAdjustment(HDC,const COLORADJUSTMENT *);
BOOL _stdcall GetColorAdjustment(HDC,LPCOLORADJUSTMENT);
HPALETTE _stdcall CreateHalftonePalette(HDC);
int _stdcall EndDoc(HDC);
int _stdcall StartPage(HDC);
int _stdcall EndPage(HDC);
int _stdcall AbortDoc(HDC);
int _stdcall SetAbortProc(HDC,ABORTPROC);
BOOL _stdcall AbortPath(HDC);
BOOL _stdcall ArcTo(HDC,int,int,int,int,int,int,int,int);
BOOL _stdcall BeginPath(HDC);
BOOL _stdcall CloseFigure(HDC);
BOOL _stdcall EndPath(HDC);
BOOL _stdcall FillPath(HDC);
BOOL _stdcall FlattenPath(HDC);
int _stdcall GetPath(HDC,PPOINT,LPBYTE,int);
HRGN _stdcall PathToRegion(HDC);
BOOL _stdcall PolyDraw(HDC,const POINT *,const BYTE *,int);
BOOL _stdcall SelectClipPath(HDC,int);
int _stdcall SetArcDirection(HDC,int);
BOOL _stdcall SetMiterLimit(HDC,FLOAT,PFLOAT);
BOOL _stdcall StrokeAndFillPath(HDC);
BOOL _stdcall StrokePath(HDC);
BOOL _stdcall WidenPath(HDC);
HPEN _stdcall ExtCreatePen(DWORD,DWORD,const LOGBRUSH *,DWORD,const DWORD *);
BOOL _stdcall GetMiterLimit(HDC,PFLOAT);
int _stdcall GetArcDirection(HDC);
BOOL _stdcall MoveToEx(HDC,int,int,PPOINT);
HRGN _stdcall CreatePolygonRgn(const POINT *,int,int);
BOOL _stdcall DPtoLP(HDC,PPOINT,int);
BOOL _stdcall LPtoDP(HDC,PPOINT,int);
BOOL _stdcall Polygon(HDC,const POINT *,int);
BOOL _stdcall Polyline(HDC,const POINT *,int);
BOOL _stdcall PolyBezier(HDC,const POINT *,DWORD);
BOOL _stdcall PolyBezierTo(HDC,const POINT *,DWORD);
BOOL _stdcall PolylineTo(HDC,const POINT *,DWORD);
BOOL _stdcall SetViewportExtEx(HDC,int,int,LPSIZE);
BOOL _stdcall SetViewportOrgEx(HDC,int,int,PPOINT);
BOOL _stdcall SetWindowExtEx(HDC,int,int,LPSIZE);
BOOL _stdcall SetWindowOrgEx(HDC,int,int,PPOINT);
BOOL _stdcall OffsetViewportOrgEx(HDC,int,int,PPOINT);
BOOL _stdcall OffsetWindowOrgEx(HDC,int,int,PPOINT);
BOOL _stdcall ScaleViewportExtEx(HDC,int,int,int,int,LPSIZE);
BOOL _stdcall ScaleWindowExtEx(HDC,int,int,int,int,LPSIZE);
BOOL _stdcall SetBitmapDimensionEx(HBITMAP,int,int,LPSIZE);
BOOL _stdcall SetBrushOrgEx(HDC,int,int,PPOINT);
BOOL _stdcall GetDCOrgEx(HDC,PPOINT);
BOOL _stdcall FixBrushOrgEx(HDC,int,int,PPOINT);
BOOL _stdcall UnrealizeObject(HGDIOBJ);
BOOL _stdcall GdiFlush(void);
DWORD _stdcall GdiSetBatchLimit(DWORD);
DWORD _stdcall GdiGetBatchLimit(void);
int _stdcall SetICMMode(HDC,int);
BOOL _stdcall CheckColorsInGamut(HDC,LPVOID,LPVOID,DWORD);
HANDLE _stdcall GetColorSpace(HDC);
BOOL _stdcall SetColorSpace(HDC,HCOLORSPACE);
BOOL _stdcall DeleteColorSpace(HCOLORSPACE);
BOOL _stdcall GetDeviceGammaRamp(HDC,LPVOID);
BOOL _stdcall SetDeviceGammaRamp(HDC,LPVOID);
BOOL _stdcall ColorMatchToTarget(HDC,HDC,DWORD);
HPROPSHEETPAGE _stdcall CreatePropertySheetPageA(LPCPROPSHEETPAGE);
BOOL _stdcall DestroyPropertySheetPage(HPROPSHEETPAGE);
void _stdcall InitCommonControls(void);

HIMAGELIST _stdcall ImageList_Create(int,int,UINT,int,int);
BOOL _stdcall ImageList_Destroy(HIMAGELIST);
int _stdcall ImageList_GetImageCount(HIMAGELIST);
int _stdcall ImageList_Add(HIMAGELIST,HBITMAP,HBITMAP);
int _stdcall ImageList_ReplaceIcon(HIMAGELIST,int,HICON);
COLORREF _stdcall ImageList_SetBkColor(HIMAGELIST,COLORREF);
COLORREF _stdcall ImageList_GetBkColor(HIMAGELIST himl);
BOOL _stdcall ImageList_SetOverlayImage(HIMAGELIST,int,int);
BOOL _stdcall ImageList_Draw(HIMAGELIST,int,HDC,int,int,UINT);
BOOL _stdcall ImageList_Replace(HIMAGELIST,int,HBITMAP,HBITMAP);
int _stdcall ImageList_AddMasked(HIMAGELIST,HBITMAP,COLORREF);
BOOL _stdcall ImageList_DrawEx(HIMAGELIST,int,HDC,int,int,int,int,COLORREF,COLORREF,UINT);
BOOL _stdcall ImageList_Remove(HIMAGELIST,int);
HICON _stdcall ImageList_GetIcon(HIMAGELIST,int,UINT);
BOOL _stdcall ImageList_BeginDrag(HIMAGELIST,int,int,int);
void _stdcall ImageList_EndDrag(void);
BOOL _stdcall ImageList_DragEnter(HWND,int,int);
BOOL _stdcall ImageList_DragLeave(HWND);
BOOL _stdcall ImageList_DragMove(int,int);
BOOL _stdcall ImageList_SetDragCursorImage(HIMAGELIST,int,int,int);
BOOL _stdcall ImageList_DragShowNolock(BOOL);
HIMAGELIST _stdcall ImageList_GetDragImage(POINT *,POINT *);
BOOL _stdcall ImageList_GetIconSize(HIMAGELIST,int *,int *);
BOOL _stdcall ImageList_SetIconSize(HIMAGELIST,int,int);
BOOL _stdcall ImageList_GetImageInfo(HIMAGELIST,int,IMAGEINFO *);
HIMAGELIST _stdcall ImageList_Merge(HIMAGELIST,int,HIMAGELIST,int,int,int);
HWND _stdcall CreateToolbarEx(HWND,DWORD,UINT,int,HINSTANCE,UINT,LPCTBBUTTON,int,int,int,int,int,UINT);
HBITMAP _stdcall CreateMappedBitmap(HINSTANCE,int,UINT,LPCOLORMAP,int);
void _stdcall MenuHelp(UINT,WPARAM,LPARAM,HMENU,HINSTANCE,HWND,UINT *);
BOOL _stdcall ShowHideMenuCtl(HWND,UINT,LPINT);
void _stdcall GetEffectiveClientRect(HWND,LPRECT,LPINT);
BOOL _stdcall MakeDragList(HWND);
void _stdcall DrawInsert(HWND,HWND,int);
int _stdcall LBItemFromPt(HWND,POINT,BOOL);
HWND _stdcall CreateUpDownControl(DWORD,int,int,int,int,HWND,int,HINSTANCE,HWND,int,int,int);
DWORD _stdcall CommDlgExtendedError(void);
























































































































































LONG _stdcall RegCloseKey (HKEY);
LONG _stdcall RegSetKeySecurity(HKEY,SECURITY_INFORMATION,PSECURITY_DESCRIPTOR);
LONG _stdcall RegFlushKey(HKEY);
LONG _stdcall RegGetKeySecurity(HKEY,SECURITY_INFORMATION,PSECURITY_DESCRIPTOR,LPDWORD);
LONG _stdcall RegNotifyChangeKeyValue(HKEY,BOOL,DWORD,HANDLE,BOOL);
BOOL _stdcall IsValidCodePage(UINT);
UINT _stdcall GetACP(void);
UINT _stdcall GetOEMCP(void);
BOOL _stdcall GetCPInfo(UINT,LPCPINFO);
BOOL _stdcall IsDBCSLeadByte(BYTE);
BOOL _stdcall IsDBCSLeadByteEx(UINT,BYTE);
int _stdcall MultiByteToWideChar(UINT,DWORD,LPCSTR,int,LPWSTR,int);
int _stdcall WideCharToMultiByte(UINT,DWORD,LPCWSTR,int,LPSTR,int,LPCSTR,LPBOOL);
BOOL _stdcall IsValidLocale(LCID,DWORD);
LCID _stdcall ConvertDefaultLocale(LCID);
LCID _stdcall GetThreadLocale(void);
BOOL _stdcall SetThreadLocale(LCID);
LANGID _stdcall GetSystemDefaultLangID(void);
LANGID _stdcall GetUserDefaultLangID(void);
LCID _stdcall GetSystemDefaultLCID(void);
LCID _stdcall GetUserDefaultLCID(void);
BOOL _stdcall ReadConsoleOutputAttribute(HANDLE,LPWORD,DWORD,COORD,LPDWORD);
BOOL _stdcall WriteConsoleOutputAttribute(HANDLE,const WORD *,DWORD,COORD,LPDWORD);
BOOL _stdcall FillConsoleOutputAttribute(HANDLE,WORD,DWORD,COORD,LPDWORD);
BOOL _stdcall GetConsoleMode(HANDLE,LPDWORD);
BOOL _stdcall GetNumberOfConsoleInputEvents(HANDLE,LPDWORD);
BOOL _stdcall GetConsoleScreenBufferInfo(HANDLE,PCONSOLE_SCREEN_BUFFER_INFO);
COORD _stdcall GetLargestConsoleWindowSize(HANDLE);
BOOL _stdcall GetConsoleCursorInfo(HANDLE,PCONSOLE_CURSOR_INFO);
BOOL _stdcall GetNumberOfConsoleMouseButtons(LPDWORD);
BOOL _stdcall SetConsoleMode(HANDLE,DWORD);
BOOL _stdcall SetConsoleActiveScreenBuffer(HANDLE);
BOOL _stdcall FlushConsoleInputBuffer(HANDLE);
BOOL _stdcall SetConsoleScreenBufferSize(HANDLE,COORD);
BOOL _stdcall SetConsoleCursorPosition(HANDLE,COORD);
BOOL _stdcall SetConsoleCursorInfo(HANDLE,const CONSOLE_CURSOR_INFO *);
BOOL _stdcall SetConsoleWindowInfo(HANDLE,BOOL,const SMALL_RECT *);
BOOL _stdcall SetConsoleTextAttribute(HANDLE,WORD);
BOOL _stdcall SetConsoleCtrlHandler(PHANDLER_ROUTINE,BOOL);
BOOL _stdcall GenerateConsoleCtrlEvent(DWORD,DWORD);
BOOL _stdcall AllocConsole(void);
BOOL _stdcall FreeConsole(void);
HANDLE _stdcall CreateConsoleScreenBuffer(DWORD,DWORD,const SECURITY_ATTRIBUTES *,DWORD,LPVOID);
UINT _stdcall GetConsoleCP(void);
BOOL _stdcall SetConsoleCP(UINT);
UINT _stdcall GetConsoleOutputCP(void);
BOOL _stdcall SetConsoleOutputCP(UINT);
DWORD _stdcall WNetConnectionDialog(HWND,DWORD);
DWORD _stdcall WNetDisconnectDialog(HWND,DWORD);
DWORD _stdcall WNetCloseEnum( HANDLE);
BOOL _stdcall CloseServiceHandle(SC_HANDLE);
BOOL _stdcall ControlService(SC_HANDLE,DWORD,LPSERVICE_STATUS);
BOOL _stdcall DeleteService( SC_HANDLE);
SC_LOCK _stdcall LockServiceDatabase(SC_HANDLE);
BOOL _stdcall NotifyBootConfigStatus(BOOL);
BOOL _stdcall QueryServiceObjectSecurity(SC_HANDLE,SECURITY_INFORMATION,PSECURITY_DESCRIPTOR,DWORD,LPDWORD);
BOOL _stdcall QueryServiceStatus(SC_HANDLE,LPSERVICE_STATUS);
BOOL _stdcall SetServiceObjectSecurity(SC_HANDLE,SECURITY_INFORMATION,PSECURITY_DESCRIPTOR);
BOOL _stdcall SetServiceStatus(SERVICE_STATUS_HANDLE,LPSERVICE_STATUS);
BOOL _stdcall UnlockServiceDatabase(SC_LOCK);
BOOL _stdcall WinLoadTrustProvider(GUID *);
LONG _stdcall WinVerifyTrust(HWND,GUID *,LPVOID);
BOOL _stdcall WinSubmitCertificate(LPWIN_CERTIFICATE);

BOOL _stdcall wglCopyContext(HGLRC, HGLRC, UINT);
HGLRC _stdcall wglCreateContext(HDC);
HGLRC _stdcall wglCreateLayerContext(HDC, int);
BOOL _stdcall wglDeleteContext(HGLRC);
HGLRC _stdcall wglGetCurrentContext(void);
HDC _stdcall wglGetCurrentDC(void);
FARPROC _stdcall wglGetProcAddress(LPCSTR);
BOOL _stdcall wglMakeCurrent(HDC, HGLRC);
BOOL _stdcall wglShareLists(HGLRC, HGLRC);
BOOL _stdcall wglUseFontBitmapsA(HDC, DWORD, DWORD, DWORD);
BOOL _stdcall wglUseFontBitmapsW(HDC, DWORD, DWORD, DWORD);
BOOL _stdcall SwapBuffers(HDC);
BOOL _stdcall wglSwapLayerBuffers(HDC, UINT);





typedef struct _POINTFLOAT {
	FLOAT	x;
	FLOAT	y;
} POINTFLOAT, *PPOINTFLOAT;
typedef struct _GLYPHMETRICSFLOAT {
	FLOAT	gmfBlackBoxX;
	FLOAT	gmfBlackBoxY;
	POINTFLOAT gmfptGlyphOrigin;
	FLOAT	gmfCellIncX;
	FLOAT	gmfCellIncY;
} GLYPHMETRICSFLOAT,*PGLYPHMETRICSFLOAT,*LPGLYPHMETRICSFLOAT;


BOOL _stdcall wglUseFontOutlinesA(HDC,DWORD,DWORD,DWORD,FLOAT,FLOAT,int,LPGLYPHMETRICSFLOAT);
BOOL _stdcall  wglUseFontOutlinesW(HDC,DWORD,DWORD,DWORD,FLOAT,FLOAT,int,LPGLYPHMETRICSFLOAT);





typedef struct _LAYERPLANEDESCRIPTOR {
	WORD	nSize;
	WORD	nVersion;
	DWORD	dwFlags;
	BYTE	iPixelType;
	BYTE	cColorBits;
	BYTE	cRedBits;
	BYTE	cRedShift;
	BYTE	cGreenBits;
	BYTE	cGreenShift;
	BYTE	cBlueBits;
	BYTE	cBlueShift;
	BYTE	cAlphaBits;
	BYTE	cAlphaShift;
	BYTE	cAccumBits;
	BYTE	cAccumRedBits;
	BYTE	cAccumGreenBits;
	BYTE	cAccumBlueBits;
	BYTE	cAccumAlphaBits;
	BYTE	cDepthBits;
	BYTE	cStencilBits;
	BYTE	cAuxBuffers;
	BYTE	iLayerPlane;
	BYTE	bReserved;
	COLORREF crTransparent;
} LAYERPLANEDESCRIPTOR,*PLAYERPLANEDESCRIPTOR,*LPLAYERPLANEDESCRIPTOR;











































BOOL _stdcall wglDescribeLayerPlane(HDC,int,int,UINT,LPLAYERPLANEDESCRIPTOR);
int _stdcall wglSetLayerPaletteEntries(HDC,int,int,int,COLORREF *);
int _stdcall wglGetLayerPaletteEntries(HDC,int,int,int,COLORREF *);
BOOL _stdcall wglRealizeLayerPalette(HDC, int, BOOL);
BOOL _stdcall wglSwapLayerBuffers(HDC, UINT);
struct	_TEB	*NtCurrentTeb(void);
LPVOID _stdcall CreateFiber(DWORD,LPFIBER_START_ROUTINE,LPVOID);
 void _stdcall DeleteFiber(LPVOID);
LPVOID _stdcall ConvertThreadToFiber(LPVOID);
 void _stdcall SwitchToFiber(LPVOID);
BOOL _stdcall SwitchToThread(void);






















HANDLE _stdcall CreateToolhelp32Snapshot(DWORD dwFlags,DWORD th32ProcessID);
BOOL _stdcall Heap32ListFirst(HANDLE,LPHEAPLIST32);
BOOL _stdcall Heap32ListNext(HANDLE,LPHEAPLIST32);
BOOL _stdcall Heap32First(LPHEAPENTRY32,DWORD,DWORD);
BOOL _stdcall Heap32Next(LPHEAPENTRY32);
BOOL _stdcall Toolhelp32ReadProcessMemory(DWORD,LPCVOID,LPVOID,DWORD,LPDWORD);
BOOL _stdcall Process32First(HANDLE,LPPROCESSENTRY32);
BOOL _stdcall Process32Next(HANDLE,LPPROCESSENTRY32);
BOOL _stdcall Thread32First(HANDLE,LPTHREADENTRY32);
BOOL _stdcall Thread32Next(HANDLE,LPTHREADENTRY32);
BOOL _stdcall Module32First(HANDLE,LPMODULEENTRY32);
BOOL _stdcall Module32Next(HANDLE,LPMODULEENTRY32);




















































































































































































































































































































































































































































































































































































































































































































































#pragma pack(pop)

#line 5 "C:\MATLAB7\sys\lcc\include\windows.h"

#line 21 "C:/Archivos de programa/KVASER/Canlib/INC/canlib.h"


typedef int canHandle;









































#line 71 "C:/Archivos de programa/KVASER/Canlib/INC/canlib.h"
























#line 97 "C:/Archivos de programa/KVASER/Canlib/INC/canlib.h"

































void CANLIBAPI canInitializeLibrary(void);

canStatus CANLIBAPI canClose(const int handle);

canStatus CANLIBAPI canBusOn(const int handle);

canStatus CANLIBAPI canBusOff(const int handle);

canStatus CANLIBAPI canSetBusParams(const int handle,
                           long freq,
                           unsigned int tseg1,
                           unsigned int tseg2,
                           unsigned int sjw,
                           unsigned int noSamp,
                           unsigned int syncmode);

canStatus CANLIBAPI canGetBusParams(const int handle,
                              long * freq,
                              unsigned int * tseg1,
                              unsigned int * tseg2,
                              unsigned int * sjw,
                              unsigned int * noSamp,
                              unsigned int * syncmode);

canStatus CANLIBAPI canSetBusOutputControl(const int handle,
                                     const unsigned int drivertype);

canStatus CANLIBAPI canGetBusOutputControl(const int handle,
                                     unsigned int * drivertype);

canStatus CANLIBAPI canAccept(const int handle,
                        const long envelope,
                        const unsigned int flag);

canStatus CANLIBAPI canReadStatus(const int handle,
                            unsigned long * const flags);

canStatus CANLIBAPI canReadErrorCounters(int handle,
                               unsigned int * txErr,
                               unsigned int * rxErr,
                               unsigned int * ovErr);

canStatus CANLIBAPI canWrite(int handle, long id, void * msg,
                       unsigned int dlc, unsigned int flag);

canStatus CANLIBAPI canWriteSync(int handle, unsigned long timeout);

canStatus CANLIBAPI canRead(int handle,
                      long * id,
                      void * msg,
                      unsigned int * dlc,
                      unsigned int * flag,
                      unsigned long * time);

canStatus CANLIBAPI canReadWait(int handle,
                          long * id,
                          void * msg,
                          unsigned int * dlc,
                          unsigned int * flag,
                          unsigned long * time,
                          unsigned long timeout);

canStatus CANLIBAPI canReadSpecific(int handle, long id, void * msg,
                              unsigned int * dlc, unsigned int * flag,
                              unsigned long * time);

canStatus CANLIBAPI canReadSync(int handle, unsigned long timeout);

canStatus CANLIBAPI canReadSyncSpecific(int handle, long id, unsigned long timeout);

canStatus CANLIBAPI canReadSpecificSkip(int hnd,
                                  long id,
                                  void * msg,
                                  unsigned int * dlc,
                                  unsigned int * flag,
                                  unsigned long * time);

canStatus CANLIBAPI canSetNotify(int handle, HWND aHWnd, unsigned int aNotifyFlags);

canStatus CANLIBAPI canTranslateBaud(long * const freq,
                               unsigned int * const tseg1,
                               unsigned int * const tseg2,
                               unsigned int * const sjw,
                               unsigned int * const nosamp,
                               unsigned int * const syncMode);

canStatus CANLIBAPI canGetErrorText(canStatus err, char * buf, unsigned int bufsiz);

unsigned short CANLIBAPI canGetVersion(void);

canStatus CANLIBAPI canIoCtl(int handle, unsigned int func,
                       void * buf, unsigned int buflen);

unsigned long CANLIBAPI canReadTimer(int hnd);

int CANLIBAPI canOpenChannel(int channel, int flags);

canStatus CANLIBAPI canGetNumberOfChannels(int * channelCount);

canStatus CANLIBAPI canGetChannelData(int channel, int item, void *buffer, size_t bufsize);





























































































typedef struct {
  unsigned int portNo;
  unsigned int portValue;
} canUserIoPortData;

canStatus CANLIBAPI canWaitForEvent(int hnd, DWORD timeout);

canStatus CANLIBAPI canSetBusParamsC200(int hnd, BYTE btr0, BYTE btr1);

canStatus CANLIBAPI canSetDriverMode(int hnd, int lineMode, int resNet);
canStatus CANLIBAPI canGetDriverMode(int hnd, int *lineMode, int *resNet);







unsigned int CANLIBAPI canGetVersionEx(unsigned int itemCode);

canStatus CANLIBAPI canParamGetCount (void);

canStatus CANLIBAPI canParamCommitChanges (void);

canStatus CANLIBAPI canParamDeleteEntry (int index);

canStatus CANLIBAPI canParamCreateNewEntry (void);

canStatus CANLIBAPI canParamSwapEntries (int index1, int index2);

canStatus CANLIBAPI canParamGetName (int index, char *buffer, int maxlen);

canStatus CANLIBAPI canParamGetChannelNumber (int index);

canStatus CANLIBAPI canParamGetBusParams (int index,
                                          long* bitrate,
                                          unsigned int *tseg1,
                                          unsigned int *tseg2,
                                          unsigned int *sjw,
                                          unsigned int *noSamp);

canStatus CANLIBAPI canParamSetName (int index, const char *buffer);

canStatus CANLIBAPI canParamSetChannelNumber (int index, int channel);

canStatus CANLIBAPI canParamSetBusParams (int index,
                                          long bitrate,
                                          unsigned int tseg1,
                                          unsigned int tseg2,
                                          unsigned int sjw,
                                          unsigned int noSamp);

canStatus CANLIBAPI canParamFindByName (const char *name);




canStatus CANLIBAPI canObjBufFreeAll(int handle);


canStatus CANLIBAPI canObjBufAllocate(int handle, int type);




canStatus CANLIBAPI canObjBufFree(int handle, int idx);


canStatus CANLIBAPI canObjBufWrite(int handle, int idx, int id, void* msg,
                                   unsigned int dlc, unsigned int flags);



canStatus CANLIBAPI canObjBufSetFilter(int handle, int idx,
                                       unsigned int code, unsigned int mask);


canStatus CANLIBAPI canObjBufSetFlags(int handle, int idx, unsigned int flags);





canStatus CANLIBAPI canObjBufSetPeriod(int hnd, int idx, unsigned int period);


canStatus CANLIBAPI canObjBufSetMsgCount(int hnd, int idx, unsigned int count);


canStatus CANLIBAPI canObjBufEnable(int handle, int idx);


canStatus CANLIBAPI canObjBufDisable(int handle, int idx);


canStatus CANLIBAPI canObjBufSendBurst(int hnd, int idx, unsigned int burstlen);





BOOL CANLIBAPI canProbeVersion(int hnd, int major, int minor, int oem_id, unsigned int flags);


canStatus CANLIBAPI canResetBus(int handle);


canStatus CANLIBAPI canWriteWait(int handle, long id, void * msg,
                                 unsigned int dlc, unsigned int flag,
                                 unsigned long timeout);


canStatus CANLIBAPI canUnloadLibrary(void);

canStatus CANLIBAPI canSetAcceptanceFilter(int hnd, unsigned int code,
                                           unsigned int mask, int is_extended);


canStatus CANLIBAPI canFlushReceiveQueue(int hnd);
canStatus CANLIBAPI canFlushTransmitQueue(int hnd);


canStatus CANLIBAPI kvGetApplicationMapping(int busType,
                                  char *appName,
                                  int appChannel,
                                  int *resultingChannel);

canStatus CANLIBAPI kvBeep(int hnd, int freq, unsigned int duration);

canStatus CANLIBAPI kvSelfTest(int hnd, unsigned long *presults);













canStatus CANLIBAPI kvFlashLeds(int hnd, int action, int timeout);

canStatus CANLIBAPI canRequestChipStatus(int hnd);

canStatus CANLIBAPI canRequestBusStatistics(int hnd);

typedef struct canBusStatistics_s {
  unsigned long  stdData;
  unsigned long  stdRemote;
  unsigned long  extData;
  unsigned long  extRemote;
  unsigned long  errFrame;
  unsigned long  busLoad;
  unsigned long  overruns;
} canBusStatistics;

canStatus CANLIBAPI canGetBusStatistics(int hnd, canBusStatistics *stat, size_t bufsiz);

canStatus CANLIBAPI canSetBitrate(int hnd, int bitrate);

canStatus CANLIBAPI kvAnnounceIdentity(int hnd, void *buf, size_t bufsiz);

canStatus CANLIBAPI canGetHandleData(int hnd, int item, void *buffer, size_t bufsize);


typedef void *kvTimeDomain;
typedef canStatus kvStatus;

typedef struct kvTimeDomainData_s {
  int nMagiSyncGroups;
  int nMagiSyncedMembers;
  int nNonMagiSyncCards;
  int nNonMagiSyncedMembers;
} kvTimeDomainData;

kvStatus CANLIBAPI kvTimeDomainCreate(kvTimeDomain *domain);
kvStatus CANLIBAPI kvTimeDomainDelete(kvTimeDomain domain);

kvStatus CANLIBAPI kvTimeDomainResetTime(kvTimeDomain domain);
kvStatus CANLIBAPI kvTimeDomainGetData(kvTimeDomain domain, kvTimeDomainData *data, size_t bufsiz);

kvStatus CANLIBAPI kvTimeDomainAddHandle(kvTimeDomain domain, int handle);
kvStatus CANLIBAPI kvTimeDomainRemoveHandle(kvTimeDomain domain, int handle);


typedef void (CANLIBAPI *kvCallback_t)(int handle, void* context, unsigned int notifyEvent);
kvStatus CANLIBAPI kvSetNotifyCallback(int hnd, kvCallback_t callback, void* context, unsigned int notifyFlags);





canStatus CANLIBAPI canReadEvent(int hnd, CanEvent *event);
void CANLIBAPI canSetDebug(int d);
canStatus CANLIBAPI canSetNotifyEx(int handle, HANDLE event, unsigned int flags);
canStatus CANLIBAPI canSetTimer(int hnd, DWORD interval, DWORD flags);


int CANLIBAPI canSplitHandle(int hnd, int channel);
int CANLIBAPI canOpenMultiple(DWORD bitmask, int flags);










