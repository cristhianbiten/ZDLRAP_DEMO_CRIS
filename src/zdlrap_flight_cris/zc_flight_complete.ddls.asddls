@EndUserText.label: 'Consumption - Voos'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_FLIGHT_COMPLETE
  as projection on ZI_FLIGHT_COMPLETE
{
  key Id,
      DepartureDate,
      ArrivalDate,
      CityFrom,
      CityFromDescription,
      CityTo,
      CityToDescription,
      Price,
      Waers,
      Status,
      StatusDescription,
      /* Associations */
      _CityFrom,
      _CityTo,
      _Stats
}
