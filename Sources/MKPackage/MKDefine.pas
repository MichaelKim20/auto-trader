unit MKDefine;

interface

uses
  Messages;

const
  WM_MAIN_PROCESS = WM_USER + 3000;
  WM_CHILD_PROCESS = WM_USER + 3001;

  WM_SOCKETEVENT = WM_USER + 3100;

  // 메인윈도우에 CatergoryArray 요청할 때 사용한다. 이 때는 배열의 내용이 복제 된다.
  WPARAM_COPY_SECTIONARRAY = 1003;

  // 메인윈도우에 MarketQuotManager 요청할 때 사용한다. 이 때는 포인터만 전달한다.
  WPARAM_GETPOINT_MARKETQUOTMANAGER = 1005;

  // 메인윈도우에 CatergoryArray 요청할 때 사용한다. 이 때는 배열의 내용이 복제 된다.
  WPARAM_COPY_MATERIALARRAY = 1006;

  // 메인윈도우에 CatergoryArray 요청할 때 사용한다. 이 때는 배열의 내용이 복제 된다.
  WPARAM_GET_SELECTED_MARKETWATCHDATA = 1007;
  WPARAM_GET_SELECTED_SYMBOL = 1007;

  // 리스트뷰에서 마우스 클릭시, 종목코드가 변경되었을 때
  WPARAM_SELECT_MARKETQUOTDATA = 5000;
  WPARAM_SELECT_SYMBOLITEM = 5000;

  // 리스트뷰에서 마우스 클릭시, 종목코드가 변경되었을 때
  WPARAM_OVER_MARKETQUOTDATA = 5001;

  // 트리뷰에서 마우스 클릭시, 종목배열이 변경되었을 때
  WPARAM_CHANGE_MARKETQUOTARRAY = 5002;

  // 사용자의 관심종목을 변경했을 때
  WPARAM_CHANGE_FAVORITE = 5003;

  WPARAM_CHANGE_ORDERTYPE = 5009;

  // 리스트뷰에서 마우스 클릭시, 종목코드가 변경되었을 때
  WPARAM_SELECT_CLICKMARKETQUOTDATA = 5010;

  // 리스트뷰에서 마우스 클릭시, 종목코드가 변경되었을 때
  WPARAM_UPDATE_QUOT = 6000;

  WPARAM_INDICATOR_SETTING = 7000;

implementation

end.
