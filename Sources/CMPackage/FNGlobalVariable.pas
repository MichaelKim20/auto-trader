unit FNGlobalVariable;

interface

const
  LOGIN_Success = 1;

const
  LOGIN_SystemError = -1;

const
  LOGIN_NoneUserName = -2;

const
  LOGIN_NonePassWord = -3;

const
  LOGIN_AlreadLogin = -4;

const
  LOGIN_InvalidUserName = -5;

const
  LOGIN_InvalidPassWord = -6;

const
  LOGIN_Close = -7;

const
  LOGIN_Expired = -9;

const
  ST_NOT_MEMBER_OR_PASSWORD = -10;

const
  ST_ERROR_CHECK_MEMBER = -11;

const
  ST_NOT_SERVICEMEMBER = -12;

const
  ST_ERROR_SERVICEMEMBER = -13;

const
  CODEPAGE = 51949;

var
  g_Header: array [0 .. 4] of AnsiChar = (
    'B',
    'O',
    'P',
    #$0D,
    #$0A
  );
  g_Footer: array [0 .. 4] of AnsiChar = (
    'E',
    'O',
    'P',
    #$0D,
    #$0A
  );

  g_HeaderSize: integer = 5;
  g_FooterSize: integer = 5;
  // ---------------------------------------------------------------------------

implementation

end.
