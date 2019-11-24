
package body BinarySearchTree is

   procedure InsertBinarySearchTree(Root: in out BinarySearchTreePoint; custName, custPhone: in String10) is
      P, Q : BinarySearchTreePoint;
      f2: File_Type;
      outfile: String := "output.txt";
   begin
      Ada.Text_IO.Open(File => f2, Mode => Out_File, Name => outfile);
      AllocateNode(Q, custName, custPhone);

      if Root = Null then  -- If null is passed in as Root, this is the first item in the tree. Create a head/root and attach to the left.
         HeadName := "zzzzzzzzzz"; --Save Info.Name of head so we can skip it while traversing the tree.
         Put("Creating new tree starting with: ");
         PrintFullCustomer(Q);
         new_line;
         Root := new Node;
         Root.Rtag := true;
         Root.Rlink := Root;
         Root.Ltag := false;
         Root.Info.Name := HeadName; -- 'z' is the highest value ASCII character, so a String10 with all z's guarantees insertion to the left of Head node
         InsertNode(Root,Q);
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
      if Q.Info.Name < P.Info.Name then
         --Insert Q as left subtree of P
         Put_Line("Inserting " & Q.Info.Name & " as left subtree of " & P.Info.Name);
         Q.Llink := P.Llink;
         Q.Ltag := P.Ltag;
         P.Llink := Q;
         P.Ltag := true;
         Q.Rlink := P;
         Q.Rtag := false;
         if Q.Ltag then
            InOrderPredecessor(Q).Rlink := Q;
         end if;
      else
         --Insert Q as right subtree of P
         Put_Line("Inserting " & Q.Info.Name & " as right subtree of " & P.Info.Name);

         Q.Rlink := P.Rlink;
         Q.Rtag := P.Rtag;
         P.Rlink := Q;
         P.Rtag := true;
         Q.Llink := P;
         Q.Ltag := false;
         if Q.Rtag then
            InOrderSuccessor(Q).Llink := Q;
         end if;
      end if;
      numNodes := numNodes + 1;
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
         Put("Found customer ");
         PrintFullCustomer(P);
         Put(" iteratively.");
         New_Line(2);
      else
         CustomerPoint := null;
         Put("Could not find " & Trim(CustomerName, Right) & " iteratively.");
         New_Line(2);
      end if;
      return;
   end FindCustomerIterative;
   
   procedure FindCustomerRecursive(Root: in BinarySearchTreePoint; CustomerName: in String10; CustomerPoint: out BinarySearchTreePoint) is
   begin
      --Put_Line("Finding customer: " & Trim(CustomerName, Right) & " recursively.");
      if CustomerName < Root.Info.Name and Root.Ltag then
         FindCustomerRecursive(Root.Llink, CustomerName, CustomerPoint);
      elsif CustomerName > Root.Info.Name and Root.Rtag then
         FindCustomerRecursive(Root.Rlink, CustomerName, CustomerPoint);
      elsif CustomerName = Root.Info.Name then
         CustomerPoint := Root;
         Put("Found customer ");
         PrintFullCustomer(CustomerPoint);
         Put(" recursively.");
         New_Line(2);
         return;
      else
         CustomerPoint := null;
         Put_Line("Could not find " & Trim(CustomerName, Right) & " recursively.");
         New_Line;
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
   
   procedure PrintFullCustomer(TreePoint: in BinarySearchTreePoint) is
   begin
      if TreePoint /= null then
         Put("[");
         Put(Trim(TreePoint.Info.Name, Right));
         Put(", ");
         Put(Trim(TreePoint.Info.PhoneNumber, Right));
         Put("]");
      else
         Put_Line("Full Customer Printer was passed a null point");
      end if;
   end PrintFullCustomer;
   procedure PrintCustomerName(TreePoint: in BinarySearchTreePoint) is
   begin
      if TreePoint /= null then
         Put("[");
         Put(Trim(TreePoint.Info.Name, Right));
         Put("]");
      else
         Put_Line("Customer Name Printer was passed a null point");
      end if;
   end PrintCustomerName;
   
   procedure PreOrderTraversalIterative(TreePoint: in BinarySearchTreePoint) is
      package nodeStack is new gstack(numNodes, BinarySearchTreePoint);
      use nodeStack;
      P, Q: BinarySearchTreePoint := TreePoint;
      StartingInfo : Customer := TreePoint.Info;
      flag: Integer := 0;
   begin
      New_Line;
      Put_Line("Starting pre order traversal iterative");
      If TreePoint.info.name = HeadName and TreePoint.Ltag then
         P := TreePoint.Llink;
      end if;

      Traverse_Loop:
      loop
         if P /= null then
            PrintFullCustomer(P);
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
      New_Line;
      Put("Starting post order traversal iterative from: ");
      If TreePoint.info.name = HeadName and TreePoint.Ltag then
         P := TreePoint.Llink;
      end if;
      PrintFullCustomer(P);
      New_Line;
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
                     PrintFullCustomer(P);--Visit P
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
         --Put_Line("Rtag false");
         return Q;
      else
         --Search left
         while Q.Ltag loop
            --Put_Line("Searching left");
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
   
   procedure InOrderTraversal(TreePoint: in BinarySearchTreePoint) is
      P : BinarySearchTreePoint := TreePoint;
      i : Integer := 0;
   begin
      New_Line;
      Put("Starting inorder traversal from: ");
      If TreePoint.info.name = HeadName and TreePoint.Ltag then
         P := TreePoint.Llink;
      end if;
      PrintFullCustomer(P);
      New_Line;
      while i < numNodes loop
         --Put_Line("Passing " & P.Info.Name);
         P :=  InOrderSuccessor(P);
         --if P.Info.Name = HeadName then --skip printing head and go to next
         -- P := InOrderSuccessor(P);
         --end if;
         PrintFullCustomer(P);
         New_Line;
         i := i + 1;
      end loop;
   end InOrderTraversal;
            
   procedure TreeFromFile(filename: String; Root: in out BinarySearchTreePoint) is
      f: File_Type;
      custName: String10;
      custPhone: String10;
      numCust: Integer;
      i: Integer := 0;
   begin
      Ada.Text_IO.Open(File => f, Mode => In_File, Name => filename);
      numCust := Integer'Value(Get_Line(f));
      New_Line;
      put("Inserting" & numCust'Image & " customers from file: " & filename);
      New_Line(2);
      while not End_Of_File(f) loop
         Move(Get_Line(f),custName);
         Move(Get_Line(f),custPhone);
         Put("Got ");
         Put(Trim(custName, Right));
         Put(" from file");
         new_line;
         InsertBinarySearchTree(Root, custName, custPhone);
      end loop;
      Ada.Text_IO.Close(f);
   end TreeFromFile;
   function ToString10(str: in String) return String10 is
      str10: String10;
   begin
      Move(str,str10);
      return str10;
   end ToString10;
   
   procedure DeleteRandomNode(DeletePoint, Head: in BinarySearchTreePoint) is
      Q: BinarySearchTreePoint := DeletePoint;
      S: BinarySearchTreePoint := InOrderSuccessor(DeletePoint);
      QParent: BinarySearchTreePoint := FindParent(Q, Head);
      SParent: BinarySearchTreePoint := FindParent(S, Head);
      Temp: Customer;
      J: BinarySearchTreePoint;
   begin
      Put_Line("Enter delete: " & Q.Info.Name);
      Put_Line("Deletion Node Q: " & Q.Info.Name & " Q Parent:" & QParent.Info.Name);
      
      if not (Q.Rtag or else Q.Ltag) then
         --Deleting a leaf;
         Put_Line("Deleting leaf " & Q.Info.Name);
         if QParent.Llink = Q then
            --Q is left from its parent
            InOrderPredecessor(Q).Rlink := QParent;
            QParent.Ltag := false;
            Put_Line("Changing " & QParent.Info.Name & "ltag false");
            QParent.Llink := Q.Llink;
            Put_Line("Changing " & QParent.Info.Name & " LLink to " & Q.Llink.Info.Name);
         elsif QParent.Rlink = Q then
            --Q is right from its parent
            QParent.Rtag := false;
            Put_Line("Changing " & QParent.Info.Name & " Rtag to false");
            QParent.Rlink := Q.Rlink;
            Put_Line("Changing " & QParent.Info.Name & " RtRlink to " & Q.Rlink.Info.Name);
         end if;
         --Free(Q);
         numNodes := numNodes - 1;
         Put_Line("Numnodes changed -1 to: " & numNodes'Image);
         return;
         
      elsif Head.Llink = Q then
         --Deleting Root
         Temp := S.Info;
         DeleteRandomNode(S, Head);
         Put_Line("Changing " & Q.Info.Name & " to " & Temp.Name);
         Q.Info := Temp;
         
      else
         --Deleting non-root with at least 1 child.
         if S = Head then
            S := InOrderPredecessor(Q);
            Temp := S.Info;
            DeleteRandomNode(S, Head);
            Put_Line("Changing " & Q.Info.Name & " to " & Temp.Name);
            Q.Info := Temp;
         else
            Temp := S.Info;
            DeleteRandomNode(S, Head);
            Put_Line("Changing " & Q.Info.Name & " to " & Temp.Name);
            Q.Info := Temp;
         end if;
         
      end if;
      return;
      
   end DeleteRandomNode;
   
   
   
   function FindParent(P, Head: in BinarySearchTreePoint) return BinarySearchTreePoint is
      J, S: BinarySearchTreePoint := Head;
      Q : BinarySearchTreePoint := P;
   begin
      Finder_Loop :
      loop
         if P.Info.Name < J.Info.Name and J.Ltag then
            Q := J;
            J := J.Llink;
         elsif P.Info.Name > J.Info.Name and J.Rtag then
            Q := J;
            J := J.Rlink;
         else
            exit Finder_Loop; --Either reached a different leaf node or found the customer in the tree.
         end if;
      end loop Finder_Loop;
      return Q;
   end FindParent;
   
   function DeletionFindParent(P, Head: in BinarySearchTreePoint) return BinarySearchTreePoint is
      J, S: BinarySearchTreePoint := Head;
      Q : BinarySearchTreePoint := P;
      flag: Boolean := false;
   begin
      Finder_Loop :
      loop
         if P.Info.Name < J.Info.Name and J.Ltag then
            Q := J;
            J := J.Llink;
         elsif P.Info.Name > J.Info.Name and J.Rtag then
            Q := J;
            J := J.Rlink;
         else
            if flag then
               exit Finder_Loop; --Either reached a different leaf node or found the customer in the tree.
            end if;
            flag := true;
         end if;
      end loop Finder_Loop;
      return Q;
   end DeletionFindParent;
   
   procedure ReverseInOrder(treePoint: in BinarySearchTreePoint) is
      S: BinarySearchTreePoint := treePoint;
   begin
      if treePoint.Info.Name = HeadName then --Do not print head.
         S := treePoint.Llink;
      end if;
      if S.Rtag then --Traverse the right subtree.
         ReverseInOrder(S.Rlink);
      end if;
      PrintFullCustomer(S);--Visit the node (print its contents)
      New_Line;
      if S.Ltag then --Traverse the left subtree.  
         ReverseInOrder(S.Llink);
      end if;  
      return;
   end ReverseInOrder;
   
   procedure GetRoot(P: in out BinarySearchTreePoint) is
   begin
      while P.Info.Name /= HeadName loop
            P := InOrderSuccessor(P);
      end loop;
      Put_Line("Return Root " & P.Info.Name);
      return;        
   end GetRoot;
end BinarySearchTree;
