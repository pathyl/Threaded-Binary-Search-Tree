package body gqueue is
   F: NodePtr;
   procedure enqueue(x: in item) is
      pt: NodePtr;
   begin
      pt := new Node'(x, F);
      F := pt;
   end enqueue;
   procedure dequeue(x: out item) is
      pt: NodePtr;
   begin
      x := F.info;
      F := F.link;
   end dequeue;

end gqueue;
