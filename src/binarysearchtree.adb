
package body BinarySearchTree is

   
   procedure InsertBinarySearchTree(Root: in out BinarySearchTreePoint; custName, custPhone: in String10) is
      P, Q : BinarySearchTreePoint;
      f2: File_Type;
      outfile: String := "output.txt";
   begin
      Ada.Text_IO.Open(File => f2, Mode => Out_File, Name => outfile);
      AllocateNode(Q, custName, custPhone);
      numNodes := numNodes + 1;
      if Root = Null then  -- If null is passed in as Root, this is the first item in the tree. Create a head/root and attach to the left.
         Put("Creating new tree starting with");
         PrintCustomer(Q);
         new_line;
         Root := Q; --pg 92 image, not head like standard threaded tree.
      else  -- Tree is not empty.  Locate a match with existing node or position to insert new node.
         P := Root;
         Finder_Loop :
         Loop  -- Search left and right for a match or insert in tree if not found.
            if custName < P.Info.Name then  -- Search to left
               if P.Ltag then
                  P := P.Llink;
               else
                  InsertNode(P, Q);
                  exit Finder_Loop;
               end if;
            elsif custName > P.Info.Name then  -- Search to right.
               if P.Rtag then
                  P := P.RLink;
               else-- Insert node as right subtree.
                  InsertNode(P, Q);-- New node inserted.
                  exit Finder_Loop;
               end if;
            else  -- Implies that Akey matches P.Key.
               --InsertNode(P, Q);-- Customer with matching name exists, insert to left of duplicate.
               exit Finder_Loop;
            end if;
         end loop Finder_Loop;
      end if;
      New_Line;
      Ada.Text_IO.Close(f2);
   end InsertBinarySearchTree;
   
   procedure InsertNode(P, Q: in out BinarySearchTreePoint) is
   begin
      Put("Attempting to insert ");
      Put(Q.info.Name);
      New_Line;
      if Q.Info.Name < P.Info.Name then
         --Insert Q as left subtree of P
         Put("Inserting ");
         PrintCustomer(Q);
         Put(" as left subtree of ");
         PrintCustomer(P);
         new_line;
         
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
         Put("Inserting ");
         PrintCustomer(Q);
         Put(" as right subtree of ");
         PrintCustomer(P);
         new_line;
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
      Put("Allocating ");
      Put(custName);
      New_Line;
      Q := new Node;
      Q.Info.Name:= custName;
      Q.Info.PhoneNumber := custPhone;
      Q.LLink := null;
      Q.RLink := null;
      Q.Ltag := false;
      Q.Rtag := false;
   end AllocateNode;
   
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
   
   procedure FindCustomerRecursive(Root: in BinarySearchTreePoint; CustomerName: in String10; CustomerPoint: out BinarySearchTreePoint) is
   begin
      if CustomerName < Root.Info.Name then
         FindCustomerRecursive(Root.Llink, CustomerName, CustomerPoint);
      elsif CustomerName > Root.Info.Name then
         FindCustomerRecursive(Root.Rlink, CustomerName, CustomerPoint);
      elsif CustomerName = Root.Info.Name then
         CustomerPoint := Root;
         return;
      else
         CustomerPoint := null;
         return;
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
   
   procedure PrintCustomer(TreePoint: in BinarySearchTreePoint) is
   begin
      Put("[");
      Put(Trim(TreePoint.Info.Name, Right));
      Put(", ");
      Put(Trim(TreePoint.Info.PhoneNumber, Right));
      Put("]");
   end PrintCustomer;
   
   procedure PreOrderTraversalIterative(TreePoint: in BinarySearchTreePoint) is
      package nodeStack is new gstack(numNodes, BinarySearchTreePoint);
      use nodeStack;
      P, Q: BinarySearchTreePoint := TreePoint;
      StartingInfo : Customer := TreePoint.Info;
      flag: Integer := 0;
   begin
      Put_Line("Starting pre order traversal iterative");
      Traverse_Loop:
      loop
         if P /= null then
            PrintCustomer(P);
            New_Line;
            nodeStack.push(P);
            if P.Ltag then
               P := P.Llink;
            else
               P := null;
            end if;
         else
            if nodeStack.numItems = 0 then
               exit Traverse_Loop;
            end if;
            P := nodeStack.pop;
            if P.Rtag then
               P := P.Rlink;
            else
               P := null;
            end if;
         end if;
      end loop Traverse_Loop;
   end PreOrderTraversalIterative;
   
   function PreOrderSuccessor(TreePoint: in BinarySearchTreePoint) return BinarySearchTreePoint is
      P, Q: BinarySearchTreePoint;
   begin
      P := TreePoint;
      if P.Ltag then
         Q := P.Llink;
      else
         Q := P;
         while Q.Rtag /= true loop
            Q := Q.Rlink;
         end loop;
         Q := Q.Rlink;
      end if;
      return Q;
   end PreOrderSuccessor;
         
   
   procedure PostOrderTraversalIterative(TreePoint: in BinarySearchTreePoint) is
      type TNode is
         record
            aNode : BinarySearchTreePoint;
            Way: Integer;
         end record;
      package nodeStack is new gstack(numNodes, TNode);
      MyNode : TNode;
      P : BinarySearchTreePoint := TreePoint;
   begin
      Put_Line("Starting PostOrderTraversalIterative");
      Traverse_Loop:
      loop
         if P /= null then
            MyNode.aNode := P;
            MyNode.Way := 0;
            nodeStack.push(MyNode);
            if P.Ltag then
               P := P.Llink;
            else
               P := null;
            end if;
         else
            if nodeStack.numItems = 0 then
               exit Traverse_Loop;
            end if;
            MyNode := nodeStack.pop;
            P := MyNode.aNode;
            if MyNode.Way = 0 then
               MyNode.Way := 1;
               nodeStack.push(MyNode);
               if P.Rtag then
                  P := P.Rlink;
               else
                  P := null;
               end if;
            else
               Inner_Loop:
               loop
                  if P /= null then
                     PrintCustomer(P);--Visit P
                     new_line;
                  end if;
                  if nodeStack.numItems = 0 then
                     exit Traverse_Loop;
                  end if;
                  MyNode := nodeStack.pop;
                  P := MyNode.aNode;
                  if MyNode.Way = 0 then
                     MyNode.Way := 1;
                     nodeStack.push(MyNode);
                     if P.Rtag then
                        P := P.Rlink;
                     else
                        P := null;
                     end if;
                     exit Inner_Loop;
                  end if;
               end loop Inner_Loop;
            end if;
         end if;
      end loop Traverse_Loop;
               
   end PostOrderTraversalIterative;
   


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
            
   procedure TreeFromFile(filename: String; Root: in out BinarySearchTreePoint) is
      f: File_Type;
      custName: String10;
      custPhone: String10;
      numCust: Integer;
      i: Integer := 0;
   begin
      Ada.Text_IO.Open(File => f, Mode => In_File, Name => filename);
      numCust := Integer'Value(Get_Line(f));
      put("Number of Customers: " & numCust'Image);
      while not End_Of_File(f) loop
         Move(Get_Line(f),custName);
         Move(Get_Line(f),custPhone);
         Put("Got ");
         Put(custName);
         Put("from file");
         new_line;
         InsertBinarySearchTree(Root, custName, custPhone);
      end loop;
      Ada.Text_IO.Close(f);
   end TreeFromFile;

            
end BinarySearchTree;
