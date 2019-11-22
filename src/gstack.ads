 generic
      max:integer;
      type item is private;
   package gstack is
      procedure push(x: in item);
      function pop return item;
      function numItems return Integer;
   end gstack;
