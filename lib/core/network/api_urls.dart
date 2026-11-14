class ApiUrls {
  ApiUrls._();

  // ── Category ──
  static const String categoryCreate = 'v1/it_service/category/create/';
  static const String categoryList = 'v1/it_service/category/list/';
  static String categoryDetail(int id) => 'v1/it_service/category/$id/';

  // ── Service ──
  static const String serviceCreate = 'v1/it_service/service/create/';
  static String serviceList(int categoryId) => 'v1/it_service/service/list/?category=$categoryId';
  static String serviceDetail(int id) => 'v1/it_service/service/$id/';

  // ── Banner ──
  static const String bannerCreate = 'v1/it_service/banner/create/';
  static const String bannerList = 'v1/it_service/banner/list/';
  static String bannerDetail(int id) => 'v1/it_service/banner/$id/';

  // ── Ads ──
  static const String adCreate = 'v1/it_service/ad/create/';
  static const String adList = 'v1/it_service/ad/list/';
  static String adDetail(int id) => 'v1/it_service/ad/$id/';

  // ── Booking ──
  static const String bookingList = 'v1/it_service/booking/list/';
}