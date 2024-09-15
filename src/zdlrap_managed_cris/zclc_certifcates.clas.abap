CLASS zclc_certifcates DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclc_certifcates IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    TYPES: tt_certif TYPE TABLE OF zdlrap_certif WITH DEFAULT KEY.

    DELETE FROM zdlrap_certif.

    DATA(lt_certif) = VALUE tt_certif(
     ( cert_uuid = '1' matnr = '1'  )
     ( cert_uuid = '2' matnr = '2'  )
     ( cert_uuid = '3' matnr = '3'  )

     ).

    MODIFY zdlrap_certif FROM TABLE @lt_certif.

    out->write(  'Cerificados inseridos com sucesso!' ).
  ENDMETHOD.

ENDCLASS.
