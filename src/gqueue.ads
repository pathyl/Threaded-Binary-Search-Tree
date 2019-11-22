
   generic
      type item is private;
   package gqueue is
      type Node;
      type NodePtr is access Node;
      type Node is
         record
            info: item;
            link: NodePtr;
         end record;
      procedure enqueue(x: in item);
      procedure dequeue(x: out item);
   end gqueue;
