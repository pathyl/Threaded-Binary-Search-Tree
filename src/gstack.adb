package body gstack is
   s:array(1..max) of item;
   top: integer range 0..max;
   procedure push(x: in item) is
   begin
      top := top + 1;
      s(top) := x;
   end push;
   function pop return item is
      x: item;
   begin
      x := s(top);
      top := top - 1;
      return x;
   end pop;
   function numItems return Integer is
   begin
      return top;
   end numItems;
begin
   top := 0; --initialize top of stack to empty
end gstack;
