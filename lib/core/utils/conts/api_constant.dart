String BASE_URL = "https://zipline.zolovio.com/zipline";

class ApiConstant {
  static String registerEndpoint = "/register/details";
  static String loginEndpoint = "/user/login";
  static String profileEndpoint = "/user/details";
  static String allordersEndpoint = "/user/order/summary/all/";
  static String completedordersEndpoint = "/user/order/summary/completed/";
  static String DeliveredordersEndpoint = "/user/order/summary/delivered/";
  static String DeliveryPendingordersEndpoint = "/user/order/summary/delivery/";
  static String PickupordersEndpoint = "/user/order/summary/pickup";

  // Placing Order
  static String senderDetailEndpoint = "/user/order/sxdetails";
  static String reciveirDetailEndpoint = "/user/order/rxdetails";
  static String packageDetailEndpoint = "/user/order/pxdetails";
}
