      FUNCTION decode_line (line_text, KeyWord, Nval, Cval, Rval)
!
!=======================================================================
!                                                                      !
!  This function decodes lines of text from input script files.        !
!                                                                      !
!=======================================================================
!
      USE mod_kinds
!
      implicit none
!
! Imported variable declarations.
!
      character (len=*), intent(in) :: line_text
      character (len=40), intent(inout) :: KeyWord
      integer, intent(inout) :: Nval
      character (len=256), dimension(200), intent(inout) :: Cval
      real(r8), dimension(100), intent(inout) :: Rval
!
! Local variable declarations
!
      logical :: IsString, Kextract, decode, nested
      integer :: Iblank, Icomm, Icont, Ipipe, Kstr, Kend, Linp
      integer :: Lend, LenS, Lstr, Lval, Nmul, Schar
      integer :: copies, i, ic, ie, is, j, status
      integer, dimension(20) :: Imul
      integer :: decode_line
      character (len=1 ), parameter :: blank = ' '
      character (len=256) :: Vstring, line, string
!
!------------------------------------------------------------------------
!  Decode input line.
!------------------------------------------------------------------------
!
!  Initialize.
!
      DO i=1,LEN(line)
        line(i:i)=blank
        Vstring(i:i)=blank
        string(i:i)=blank
      END DO
!
!  Get length of "line". Remove comment after the KEYWORD, if any.
!  Then, remove leading and trailing blanks.
!
      Linp=LEN(line_text)
      IF ((Linp.gt.0).and.(line_text(1:1).ne.CHAR(33))) THEN
        Icomm=INDEX(line_text,CHAR(33),BACK=.FALSE.)
        IF (Icomm.gt.0) Linp=Icomm-1
        line=TRIM(ADJUSTL(line_text(1:Linp)))
        Linp=LEN_TRIM(line)
      ELSE
        line=TRIM(ADJUSTL(line_text))
        Linp=LEN_TRIM(line)
      END IF
!
!  If not a blank or comment line [char(33)=!], decode and extract input
!  values.  Find equal sign [char(61)].
!
      status=-1
      nested=.FALSE.
      IF ((Linp.gt.0).and.(line(1:1).ne.CHAR(33))) THEN
        status=1
        Kstr=1
        Kend=INDEX(line,CHAR(61),BACK=.FALSE.)-1
        Lstr=INDEX(line,CHAR(61),BACK=.TRUE.)+1
!
! Determine if KEYWORD is followed by double equal sign (==) indicating
! nested parameter.
!
        IF ((Lstr-Kend).eq.3) nested=.TRUE.
!
! Extract KEYWORD, trim leading and trailing blanks.
!
        Kextract=.FALSE.
        IF (Kend.gt.0) THEN
          Lend=Linp
          KeyWord=line(Kstr:Kend)
          Nval=0
          Kextract=.TRUE.
        ELSE
          Lstr=1
          Lend=Linp
          Kextract=.TRUE.
        END IF
!
! Extract parameter values string.  Remove continuation symbol
! [char(92)=\] or multi-line value [char(124)=|], if any.  Trim
! leading trailing blanks.
!
        IF (Kextract) THEN
          Icont=INDEX(line,CHAR(92 ),BACK=.FALSE.)
          Ipipe=INDEX(line,CHAR(124),BACK=.FALSE.)
          IF (Icont.gt.0) Lend=Icont-1
          IF (Ipipe.gt.0) Lend=Ipipe-1
          Vstring=ADJUSTL(line(Lstr:Lend))
          Lval=LEN_TRIM(Vstring)
!
! The TITLE KEYWORD is a special one since it can include strings,
! numbers, spaces, and continuation symbol.
!
          IsString=.FALSE.
          IF (TRIM(KeyWord).eq.'TITLE') THEN
            Nval=Nval+1
            Cval(Nval)=Vstring(1:Lval)
            IsString=.TRUE.
          ELSE
!
! Check if there is a multiplication symbol [char(42)=*] in the variable
! string indicating repetition of input values.
!
            Nmul=0
            DO i=1,Lval
              IF (Vstring(i:i).eq.CHAR(42)) THEN
                Nmul=Nmul+1
                Imul(Nmul)=i
              END IF
            END DO
            ic=1
!
! Check for blank spaces [char(32)=' '] between entries and decode.
!
            is=1
            ie=Lval
            Iblank=0
            decode=.FALSE.
            DO i=1,Lval
              IF (Vstring(i:i).eq.CHAR(32)) THEN
                IF (Vstring(i+1:i+1).ne.CHAR(32)) decode=.TRUE.
                Iblank=i
              ELSE
                ie=i
              ENDIF
              IF (decode.or.(i.eq.Lval)) THEN
                Nval=Nval+1
!
! Processing numeric values.  Check starting character to determine
! if numeric or character values. It is possible to have both when
! processing repetitions via the multiplication symbol.
!
                Schar=ICHAR(Vstring(is:is))
                IF (((48.le.Schar).and.(Schar.le.57)).or.               &
     &              (Schar.eq.43).or.(Schar.eq.45)) THEN
                  IF ((Nmul.gt.0).and.                                  &
     &                (is.lt.Imul(ic)).and.(Imul(ic).lt.ie)) THEN
                    READ (Vstring(is:Imul(ic)-1),*) copies
                    Schar=ICHAR(Vstring(Imul(ic)+1:Imul(ic)+1))
                    IF ((43.le.Schar).and.(Schar.le.57)) THEN
                      READ (Vstring(Imul(ic)+1:ie),*) Rval(Nval)
                      DO j=1,copies-1
                        Rval(Nval+j)=Rval(Nval)
                      END DO
                    ELSE
                      string=Vstring(Imul(ic)+1:ie)
                      LenS=LEN_TRIM(string)
                      Cval(Nval)=string(1:LenS)
                      DO j=1,copies-1
                        Cval(Nval+j)=Cval(Nval)
                      END DO
                    END IF
                    Nval=Nval+copies-1
                    ic=ic+1
                  ELSE
                    string=Vstring(is:ie)
                    LenS=LEN_TRIM(string)
                    READ (string(1:LenS),*) Rval(Nval)
                  END IF
                ELSE
!
! Processing character values (logicals and strings).
!
                  IF ((Nmul.gt.0).and.                                  &
     &                (is.lt.Imul(ic)).and.(Imul(ic).lt.ie)) THEN
                    READ (Vstring(is:Imul(ic)-1),*) copies
                    Cval(Nval)=Vstring(Imul(ic)+1:ie)
                    DO j=1,copies-1
                      Cval(Nval+j)=Cval(Nval)
                    END DO
                    Nval=Nval+copies-1
                    ic=ic+1
                  ELSE
                    string=Vstring(is:ie)
                    Cval(Nval)=TRIM(ADJUSTL(string))
                  END IF
                  IsString=.TRUE.
                END IF
                is=Iblank+1
                ie=Lval
                decode=.FALSE.
              END IF
            END DO
          END IF
        END IF
        status=Nval
      END IF
      decode_line=status
      RETURN
      END FUNCTION decode_line
