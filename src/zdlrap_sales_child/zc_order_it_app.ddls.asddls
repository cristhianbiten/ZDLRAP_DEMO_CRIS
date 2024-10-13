@EndUserText.label: 'Consumption - Vendas Itens'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_ORDER_IT_APP
  as projection on ZI_ORDER_IT_APP
{
  key Orderid,
  key Item,
      Product,
      Description,
      Value,
      Currency,
      Quantity,
      UnityMeasure,
      SalesPrice,
      /* Associations */
      _Order : redirected to parent ZC_ORDER_APP,
      _Product
}
