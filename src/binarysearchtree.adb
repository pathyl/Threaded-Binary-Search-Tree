package body BinarySearchTree is
   
begin
   

   procedure InsertBinarySearchTree(Root: in out BinarySearchTreePoint; custName, custPhone: in String10) is
      P, Q : BinarySearchTreePoint;
   begin
      AllocateNode(Q, custName, custPhone);
      if Root = Null then  -- If null is passed in as Root, this is the first item in the tree. Create a head/root and attach to the left.
         Root.Rtag := true;
         Root.Rlink := Root;
         Root.Ltag := true;
         Root.Llink := Q;
      else  -- Tree is not empty.  Locate a match with existing node or position to insert new node.
         P := Root;
         Loop  -- Search left and right for a match or insert in tree if not found.
            if custName < P.Info.Name then  -- Search to left
               if P.LLink /= Null then
                  P := P.Llink;
               else -- Insert node as left subtree.
                  InsertNode(P, Q, custName, custPhone);
               end loop;              -- New node inserted.
            end if;
         elsif custName > P.Info.Name then  -- Search to right.
            if P.RLink /= Null then
               P := P.RLink;
            else-- Insert node as right subtree.
               InsertNode(P, Q, custName, custPhone);
            end loop; -- New node inserted.
         end if;
      else  -- Implies that Akey matches P.Key.
         InsertNode(P, Q, custName, custPhone);-- Node has been found, maipulate the data fields as desired. 
      end loop;
   end if;
end loop;
end if;
end InsertBinarySearchTree;
     
procedure InsertNode(P, Q: in out BinarySearchTreePoint) is
begin
   if Q.Info.Name < P.Info.Name then
      --Insert Q as left subtree of P
      Q.Llink := P.Llink;
      Q.Ltag := P.Ltag;
      P.Llink := Q;
      P.Ltag := true;
      Q.Rlink := P;
      Q.Rtag := false;
      
      if Q.Ltag := true then
         InOrderPredecessor(Q).Rlink := Q; --change $Q to inorder predecessor function.
      end if;
      
   else
      --Insert Q as right subtree of P
      Q.Rlink := P.Rlink;
      Q.Rtag := P.Rtag;
      P.Rlink := Q;
      P.Rtag := true;
      Q.Llink := P;
      Q.Ltag := false;
      if Q.Rtag := true then
         InOrderSuccessor(Q).Llink := Q; --change Q$ to inorder successor function.
      end if;
      
   end if;
end InsertNode;
            
procedure AllocateNode(Q: out BinarySearchTreePoint; custName, custPhone: in String10) is
   Q : BinarySearchTreePoint;
begin  -- Allocates and places AKey in node pointed to by Q.
   Q := new Node;
   Q.Info.Name:= custName;
   Q.Info.PhoneNumber := custPhone;
   Q.LLink := Q.RLink := null;
   Q.Ltag := Q.Rtag := false;
end AllocateNode;

function InOrderSuccessor(TreePoint: in BinarySearchTreePoint) return BinarySearchTreePoint is
   Q: BinarySearchTreePoint;
begin
   Q := TreePoint.Rlink; --Look right
   if TreePoint.Rtag = false then
      return Q;
   else
      --Search left
      while Q.Ltag loop
         Q := Q.Llink;
      end loop;
   end if;
   return Q;
end InOrderSuccessor;

function InOrderPredecessor(TreePoint: in BinarySearchTreePoint) return BinarySearchTreePoint is
   Q: BinarySearchTreePoint;
begin
   Q := TreePoint.Llink;
   if TreePoint.Ltag then
      while Q.Rtag loop
         Q := Q.Rlink;
      end loop;
   end if;
   return Q;
end InOrderPredecessor;
            
end BinarySearchTree;
