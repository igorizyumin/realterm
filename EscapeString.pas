unit EscapeString;
// Expands a python style string ie one with \ (backslash) special chars
// useful to put none printable chars into a string in an edit box
// interprets \NNN as decimal NOT octal like Python and C
//$Date: 2004-02-12 23:49:25+13 $ $Revision: 1.0 $
interface
function ExpandEscapeString(S:string):string;

implementation
uses ststrs;
function ExpandEscapeString(S:string):string;

  var R:string;
      numstr:string;
      C:char;
      P:integer;
      value:word;
      ConvertNumStrOK:boolean;

  procedure AppendGetRest(NewString:string;CharsToDump:integer);
  begin
     R:=R+NewString;
     S:=copy(S,CharsToDump+1,maxint);
  end;
begin
  R:='';
  while (true) do
    begin
      P:=Pos('\',S);
      if (P=0) or (length(S)=1)
        then begin //no escapes, or last char is escape, so exit
          R:=R+S;
          break;
        end;
      // so a useful escape exists

      C:=S[P+1]; //get the char after the \

      R:=R+copy(S,1,P-1); //copy the chunk that precedes the backslash
      S:=copy(S,P,maxint); //copy the rest including the backslash
      case C of
        '\': AppendGetRest('\',2);
        'n': AppendGetRest(chr(10),2);
        'r': AppendGetRest(chr(13),2);
        't': AppendGetRest(chr(09),2);
        'v': AppendGetRest(chr(11),2);
        'b': AppendGetRest(chr(08),2);
        'a': AppendGetRest(chr(07),2);
        'f': AppendGetRest(chr(12),2);
        '"': AppendGetRest('"',2);
        chr(39):AppendGetRest(chr(39),2);
        'x': begin
               numstr:=copy(S,2,3);
               ConvertNumStrOK:=Str2WordS('0'+numstr,value);
               if ConvertNumStrOK
                  then AppendGetRest(char(value),4)
                  else AppendGetRest('\'+numstr,4); //just use as literal if unreadable
             end;
      else begin
          if (C='0') and (S[3]='x')
          then begin //handle the incorrect sequence \0x??
               numstr:=copy(S,2,4);
               ConvertNumStrOK:=Str2WordS(numstr,value);
               if ConvertNumStrOK
                  then AppendGetRest(char(value),5)
                  else AppendGetRest('\'+numstr,5); //just use as literal if unreadable
          end
          else begin
          if (C>='0') and (C<='9') {must be an octal value}
            then begin
               numstr:=copy(S,3,P-1);  {octal string}
               ConvertNumStrOK:=Str2WordS(numstr,value);
               if ConvertNumStrOK
                  then AppendGetRest(char(value),4)
                  else AppendGetRest('\'+numstr,4); //just use as literal if unreadable
            end
            else begin //unknown escape sequence
              AppendGetRest(C,2); //just pass the char straight thru and swallow the \
            end
          end;
        end
      end; {case}
    end;
    result:=R;
end;

end.




