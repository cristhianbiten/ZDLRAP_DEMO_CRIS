CLASS lhc_Certificate DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Certificate RESULT result.

    METHODS setinitialvalues FOR DETERMINE ON MODIFY
      IMPORTING keys FOR certificate~setinitialvalues.

    METHODS checkmaterial FOR VALIDATE ON SAVE
      IMPORTING keys FOR certificate~checkmaterial.

ENDCLASS.

CLASS lhc_Certificate IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD setInitialValues.

    READ ENTITIES OF zi_dlrap_certifproduct IN LOCAL MODE
        ENTITY Certificate
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_certificates).

    IF lt_certificates IS NOT INITIAL.

      "Adicionar Novos Valores Certificado!
      MODIFY ENTITIES OF zi_dlrap_certifproduct IN LOCAL MODE
          ENTITY Certificate
          UPDATE
          FIELDS ( Version CertStatus )
          WITH VALUE #( FOR ls_certificate IN lt_certificates
                        ( %tky = ls_certificate-%tky
                          Version = '001'
                          CertStatus = '01' ) ).


      DATA: lt_state       TYPE TABLE FOR CREATE zi_dlrap_certifproduct\_Stats,
            ls_state       LIKE LINE OF lt_state,
            ls_state_value LIKE LINE OF ls_state-%target.


      LOOP AT lt_certificates INTO DATA(ls_certificates).

        ls_state-%key = ls_certificates-%key.
        ls_state_value-CertUuid = ls_state-CertUuid = ls_certificates-CertUuid.

        ls_state_value-%cid      = ls_state-CertUuid.
        ls_state_value-Version = '001'.
        ls_state_value-Status  = '01'.
        ls_state_value-StatusOld = space.


        ls_state_value-%control-Version         = if_abap_behv=>mk-on.
        ls_state_value-%control-StatusOld       = if_abap_behv=>mk-on.
        ls_state_value-%control-Status          = if_abap_behv=>mk-on.
        ls_state_value-%control-LastChangedAt   = if_abap_behv=>mk-on.
        ls_state_value-%control-LastChangedBy   = if_abap_behv=>mk-on.

        APPEND ls_state_value TO ls_state-%target.

        APPEND ls_state TO lt_state.

        MODIFY ENTITIES OF zi_dlrap_certifproduct IN LOCAL MODE
            ENTITY Certificate
            CREATE BY \_Stats
            FROM lt_state
                REPORTED DATA(ls_return_ass)
                MAPPED DATA(ls_mapped_ass)
                FAILED DATA(ls_failed_ass).

      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD checkMaterial.

    READ ENTITIES OF zi_dlrap_certifproduct IN LOCAL MODE
      ENTITY Certificate
      FIELDS ( Matnr )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_certificates).

    CHECK lt_certificates IS NOT INITIAL.

    SELECT *
        FROM zi_dlrap_product
        INTO TABLE @DATA(lt_material).

    LOOP AT lt_certificates INTO DATA(ls_certificates).
      IF ls_certificates-Matnr IS INITIAL OR NOT
         line_exists( lt_material[ Matnr = ls_certificates-Matnr ] ).

        APPEND VALUE #( %tky = ls_certificates-%tky ) TO failed-certificate.

        APPEND VALUE #(  %tky        = ls_certificates-%tky
                         %state_area = 'MATERIAL_UNKNOWN'
                         %msg        = NEW zcx_dlrap_certificate(
                                        severity    = if_abap_behv_message=>severity-error
                                        textid      = zcx_dlrap_certificate=>material_unknown
                                        attr1       = CONV #( ls_certificates-Matnr ) )
                      ) TO reported-certificate.


      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
