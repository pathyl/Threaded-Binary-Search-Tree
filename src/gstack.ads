package gstack is
   generic
      max:integer;
      type item is private;
   package gstack is
      procedure push(x: in item);
      procedure pop(x: out item);
      function numItems return Integer;
   end gstack;
end gstack;
