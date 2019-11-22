with gstack;
with Ada.Numerics.Generic_Elementary_Functions;
use Ada.Numerics.Generic_Elementary_Functions;
package body BinarySearchTree is

   
   procedure InsertBinarySearchTree(Root: in out BinarySearchTreePoint; custName, custPhone: in String10) is
      P, Q : BinarySearchTreePoint;
   begin
      AllocateNode(Q, custName, custPhone);
      numNodes := numNodes + 1;
      if Root = Null then  -- If null is passed in as Root, this is the first item in the tree. Create a head/root and attach to the left.
         Root := Q; --pg 92 image, not head like standard threaded tree.
      else  -- Tree is not empty.  Locate a match with existing node or position to insert new node.
         P := Root;
         Finder_Loop :
         Loop  -- Search left and right for a match or insert in tree if not found.
            if custName < P.Info.Name then  -- Search to left
               if P.LLink /= Null then
                  P := P.Llink;
               else -- Insert node as left subtree.
                  InsertNode(P, Q);
                  exit Finder_Loop;
               end if;-- New node inserted.
            elsif custName > P.Info.Name then  -- Search to right.
               if P.RLink /= Null then
                  P := P.RLink;
               else-- Insert node as right subtree.
                  InsertNode(P, Q);-- New node inserted.
                  exit Finder_Loop;
               end if;
            else  -- Implies that Akey matches P.Key.
               InsertNode(P, Q);-- Node has been found, maipulate the data fields as desired. 
               exit Finder_Loop;
            end if;
         end loop Finder_Loop;
      end if;
   end InsertBinarySearchTree;
   
   procedure FindCustomerIterative(Root: in BinarySearchTreePoint; CustomerName: in String10; CustomerPoint: out BinarySearchTreePoint) is
      P : BinarySearchTreePoint := Root;
   begin
      Finder_Loop :
      loop
         if CustomerName < P.Info.Name and P.Ltag then
            P := P.Llink;
         elsif CustomerName > P.Info.Name and P.Rtag then
            P := P.Rlink;
         else
            exit Finder_Loop; --Either reached a different leaf node or found the customer in the tree.
         end if;
      end loop Finder_Loop;
      if CustomerName = P.Info.Name then
         CustomerPoint := P;
      else
         CustomerPoint := null;
      end if;
      return;
   end FindCustomerIterative;
   
   procedure FindCustomerRecursive(Root: in BinarySearchTreePoint; CustomerName:  in String10; CustomerPoint:  out BinarySearchTreePoint) is
   begin
      if CustomerName < Root.Info.Name then
         FindCustomerRecursive(Root.Llink);
      elsif CustomerName > Root.Info.Name then
         FindCustomerRecursive(Root.Rlink);
      elsif CustomerName = Root.Info.Name then
         return Root;
      else
         return null;
      end if;
   end FindCustomerRecursive;
     
   function CustomerName(TreePoint: in BinarySearchTreePoint) return String10 is
   begin
      return TreePoint.Info.Name;
   end CustomerName;
   
   function CustomerPhone(TreePoint: in BinarySearchTreePoint) return String10 is
   begin
      return TreePoint.Info.Name;
   end CustomerPhone;
   
   procedure PreOrderTraversalIterative(TreePoint: in BinarySearchTreePoint) is
   begin
   end PreOrderTraversalIterative;
   
   procedure PostOrderTraversalIterative(TreePoint: in BinarySearchTreePoint) is
      package nodeStack is new gstack((Log(numNodes,2) + 1), TNode);
      type TNode is
         record
            Node : Node;
            Way: Boolean;
         end record;
         MyNode : TNode;
      P : BinarySearchTreePoint := TreePoint;
   begin
      Traverse_Loop:
      loop
         if P /= null then
            MyNode.Node := P;
            MyNode.Way := 0;
            nodeStack.push(MyNode);
         else
            if nodeStack.numItems = 0 then
               exit Traverse_Loop;
            end if;
            MyNode := nodeStack.pop();
            P := MyNode.Node;
            if MyNode.Way = 0 then
               
   end PostOrderTraversalIterative;
   

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
      
         if Q.Ltag then
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
         if Q.Rtag then
            InOrderSuccessor(Q).Llink := Q; --change Q$ to inorder successor function.
         end if;
      end if;
   end InsertNode;
            
   procedure AllocateNode(Q: out BinarySearchTreePoint; custName, custPhone: in String10) is
   begin  -- Allocates and places AKey in node pointed to by Q.
      Q := new Node;
      Q.Info.Name:= custName;
      Q.Info.PhoneNumber := custPhone;
      Q.LLink := null;
      Q.RLink := null;
      Q.Ltag := false;
      Q.Rtag := false;
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
