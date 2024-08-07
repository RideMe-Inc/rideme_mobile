enum Endpoints {
  //! CONFIGS
  getGeoID(value: '/configs/geo-data'),

  //! AUTH
  initAuth(value: '/auth/init'),
  verifyOTP(value: '/auth/verify-otp'),
  resendOTP(value: '/auth/resend-otp'),
  signUp(value: '/auth/sign-up'),
  logOut(value: '/auth/logout'),
  getRefereshToken(value: '/auth/refresh'),
  profile(value: '/profile'),

  //!TRIPS
  trip(value: '/trips'),
  bookTrip(value: '/trips/:id/book'),
  tripDetails(value: '/trips/:id'),
  reportTrip(value: '/trips/:id/reports'),
  rateTrip(value: '/trips/:id/ratings'),
  //! LOCATION
  myLocation(value: '/geo-data'),
  addresses(value: '/address'),
  editAddress(value: '/address/:id');

  final String value;

  const Endpoints({required this.value});
}
