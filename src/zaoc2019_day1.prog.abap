*&---------------------------------------------------------------------*
*& Report zaoc2019_day1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zaoc2019_day1.
PARAMETERS:inputday TYPE char2.
CLASS main DEFINITION.

  PUBLIC SECTION.

    METHODS:constructor IMPORTING i_day type char2,start.
  PRIVATE SECTION.
    DATA: input_data TYPE STANDARD TABLE OF string,
          day type char2.
    METHODS:
      read_input_from_file,
      process_data,
      day_1,
      day_2.


ENDCLASS.

CLASS main IMPLEMENTATION.
  METHOD constructor.
  day = i_day.
  ENDMETHOD.
  METHOD day_2.
  ENDMETHOD..
  METHOD day_1.
    "part 1
    DATA(output) = REDUCE i(
    INIT sum = 0
    FOR wa IN me->input_data NEXT
    sum = sum + ( floor( wa / 3 ) - 2 )
     ).
    cl_demo_output=>display( output ).

    "part 2
    DATA(sum2) = 0.
    LOOP AT input_data ASSIGNING FIELD-SYMBOL(<fs>).
      DATA(sum3) = ( floor( <fs> / 3 ) - 2 ).
      sum2 += sum3.
      WHILE sum3 > 0.
        sum3 = ( floor( sum3 / 3 ) - 2 ).
        IF sum3 > 0.
          sum2 += sum3.
        ENDIF.
      ENDWHILE.

    ENDLOOP.
    cl_demo_output=>display( sum2 ).
  ENDMETHOD.
  METHOD start.
    me->read_input_from_File( ).
    me->process_data( ).
  ENDMETHOD.

  METHOD process_data.
    CASE me->day.
      WHEN '1'.
        CALL METHOD me->day_1.
      WHEN '2'.
        CALL METHOD me->day_2.
    ENDCASE.

  ENDMETHOD.

  METHOD read_input_from_file.
    DATA: xmlstring        TYPE string,
          filetable        TYPE filetable,
          filename         TYPE string,
          numfiles         TYPE i,
          useraction       TYPE i,
          file_content_tab TYPE STANDARD TABLE OF string,
          line             LIKE LINE OF file_content_tab,
          ex               TYPE REF TO cx_transformation_error,
          msg              TYPE string.

    cl_gui_frontend_services=>file_open_dialog(
   EXPORTING window_title      = 'Open XML file'
             default_extension = '.xml'
*              default_filename  = 'xml.xml'
             file_filter       = 'Text files (*.txt)|*.txt'
             multiselection    = space
   CHANGING  file_table        = filetable
             rc                = numfiles
             user_action       = useraction
   EXCEPTIONS OTHERS           = 1 ).
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    IF  useraction = cl_gui_frontend_services=>action_ok
    AND filetable IS NOT INITIAL.
      READ TABLE filetable INDEX 1 INTO filename.
      cl_gui_frontend_services=>gui_upload( EXPORTING filename = filename
                                            CHANGING  data_tab = me->input_data
                                            EXCEPTIONS OTHERS  = 1 ).
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
DATA:
  mainprocessing TYPE REF TO main.

START-OF-SELECTION.
  CREATE OBJECT mainprocessing  EXPORTING
      i_day = inputday.
  mainprocessing->start( ).
