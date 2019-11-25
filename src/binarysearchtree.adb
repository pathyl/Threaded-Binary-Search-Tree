package body BinarySearchTree is

   procedure InsertBinarySearchTree(Root: in out BinarySearchTreePoint; ARecord: BinarySearchTreeRecord) is
      P, Q : BinarySearchTreePoint;
      RecordKey : Akey := GetKey(ARecord);
   begin
      AllocateNode(Q, ARecord);
      if Root = Null then  -- If null is passed in as Root, this is the first item in the tree. Create a head/root and attach to the left.
         --HeadRecord := "zzzzzzzzzz"; --Save Info.Name of head so we can skip it while traversing the tree.
         Put("Creating new tree starting with: ");
         PrintFullRecord(Q.Info);
         new_line;
         Root := new Node;
         Root.Rtag := true;
         Root.Rlink := Root;
         Root.Ltag := false;
         Root.Info := HeadRecord; 
         InsertNode(Root,Q);
      else  -- Tree is not empty.  Locate a match with existing node or position to insert new node.
         P := Root;
         Finder_Loop :
         Loop  -- Search left and right for a match or insert in tree if not found.
            if RecordKey < P.Info then  -- Search to left
               if P.Ltag then
                  P := P.Llink;
               else
                  InsertNode(P, Q);
                  exit Finder_Loop;
               end if;
            elsif RecordKey > P.Info then  -- Search to right.
               if P.Rtag then
                  P := P.RLink;
               else-- Insert node as right subtree.
                  InsertNode(P, Q);-- New node inserted.
                  exit Finder_Loop;
               end if;
            else  -- Implies that Akey matches P.Key.
                  -- Customer with matching name exists, insert to left of duplicate.
                  -- Overloaded "<=" used in InsertNode handles this.
               InsertNode(P, Q);
               exit Finder_Loop;
            end if;
         end loop Finder_Loop;
      end if;
      New_Line;
   end InsertBinarySearchTree;
   
   procedure InsertNode(P, Q: in out BinarySearchTreePoint) is
   begin
      if GetKey(Q.Info) <= P.Info then
         --Insert Q as left subtree of P
         Put("Inserting "); PrintIdentityRecord(Q.Info); 
         Put(" as left child of "); PrintIdentityRecord(P.Info);
         New_Line;
         numNodes := numNodes + 1;
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
         Put("Inserting "); PrintIdentityRecord(Q.Info); 
         Put(" as right child of "); PrintIdentityRecord(P.Info);
         New_Line;
         numNodes := numNodes + 1;
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
   end InsertNode;
            
   procedure AllocateNode(Q: out BinarySearchTreePoint; ARecord: BinarySearchTreeRecord) is
   begin  -- Allocates and places AKey in node pointed to by Q.
      Q := new Node;
      Q.Info := ARecord;
      Q.LLink := null;
      Q.RLink := null;
      Q.Ltag := false;
      Q.Rtag := false;
   end AllocateNode;
   
   procedure FindCustomerIterative(Root: in BinarySearchTreePoint; RecordKey: in Akey; RecordPoint: out BinarySearchTreePoint) is
      P : BinarySearchTreePoint := Root;
   begin
      Finder_Loop :
      loop
         if RecordKey < P.Info and P.Ltag then
            P := P.Llink;
         elsif RecordKey > P.Info and P.Rtag then
            P := P.Rlink;
         else
            --Either reached a different leaf node or found the customer in the tree.
            exit Finder_Loop; 
         end if;
      end loop Finder_Loop;
      if RecordKey = P.Info then
         RecordPoint := P;
         Put("Found customer "); PrintFullRecord(P.info); Put(" iteratively.");
         New_Line;
         RecordPoint := P;
      else
         RecordPoint := null;
         Put("Could not find "); PrintKey(RecordKey); Put(" iteratively.");
         New_Line;
      end if;
      return;
   end FindCustomerIterative;
   
   procedure FindCustomerRecursive(Root: in BinarySearchTreePoint; RecordKey: in AKey; RecordPoint: out BinarySearchTreePoint) is
   begin
      if RecordKey < Root.Info and Root.Ltag then
         FindCustomerRecursive(Root.Llink, RecordKey, RecordPoint);
      elsif RecordKey > Root.Info and Root.Rtag then
         FindCustomerRecursive(Root.Rlink, RecordKey, RecordPoint);
      elsif RecordKey = Root.Info then
         RecordPoint := Root;
         New_Line;
         Put("Found customer "); PrintFullRecord(RecordPoint.Info); Put(" recursively.");
         New_Line;
         return;
      else
         RecordPoint := null;
         Put("Could not find "); PrintKey(RecordKey); Put(" recursively.");
         New_Line(2);
         return;
      end if;
   end FindCustomerRecursive;

   procedure PreOrderTraversalIterative(TreePoint: in BinarySearchTreePoint) is
      package nodeStack is new gstack(numNodes, BinarySearchTreePoint);
      use nodeStack;
      P, Q: BinarySearchTreePoint := TreePoint;
      StartingInfo : BinarySearchTreeRecord := TreePoint.Info;
      flag: Integer := 0;
   begin
      New_Line;
      Put_Line("Starting pre order traversal iterative");
      If GetKey(TreePoint.Info) = HeadRecord and TreePoint.Ltag then
         P := TreePoint.Llink;
      end if;
      Traverse_Loop:
      loop
         if P /= null then
            PrintFullRecord(P.Info);
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
      If GetKey(TreePoint.Info) = HeadRecord and TreePoint.Ltag then
         P := TreePoint.Llink;
      end if;
      PrintFullRecord(P.Info);
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
                     PrintFullRecord(P.Info);--Visit P
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
   
   procedure PostOrderTraversalRecursiveCaller(TreePoint: in BinarySearchTreePoint) is
   begin
      New_Line;
      Put("Starting post oder traversal recursive with: ");
      if TreePoint.Info = HeadRecord then -- Ignore head
         PrintFullRecord(TreePoint.Llink.Info); 
      else
         PrintFullRecord(TreePoint.Info);
      end if;
      New_Line;
      PostOrderTraversalRecursive(TreePoint);
   end PostOrderTraversalRecursiveCaller;
   
   procedure PostOrderTraversalRecursive(TreePoint: in BinarySearchTreePoint) is
      S : BinarySearchTreePoint := TreePoint;
   begin
      if S.Ltag then --Traverse the left subtree.  
         PostOrderTraversalRecursive(S.Llink);
      end if;  
      if S.Rtag then --Traverse the right subtree.
         if S.Rlink = S then
            --S is Head Node
            return;
         end if;
         PostOrderTraversalRecursive(S.Rlink);
      end if;
      PrintFullRecord(S.Info);--Visit the node (print its contents)
      New_Line;
      return;
   end PostOrderTraversalRecursive;
   
   procedure PreOrderTraversalRecursive(TreePoint: in BinarySearchTreePoint) is
      S : BinarySearchTreePoint := TreePoint;
   begin
      if S.Info = HeadRecord then
         S := S.Llink;
      end if;
      New_Line;
      PrintFullRecord(S.Info);--Visit the node (print its contents)
      if S.Ltag then --Traverse the left subtree.  
         PreOrderTraversalRecursive(S.Llink);
      end if;  
      if S.Rtag then --Traverse the right subtree.
         if S.Rlink = S then
            --S is Head Node
            return;
         end if;
         PreOrderTraversalRecursive(S.Rlink);
      end if;
      return;
   end PreOrderTraversalRecursive;
   
   procedure PreOrderTraversalRecursiveCaller(TreePoint: in BinarySearchTreePoint) is
   begin
      New_Line;
      Put_Line("Starting pre order traversal recursive with: ");
      PreOrderTraversalRecursive(TreePoint);
   end PreOrderTraversalRecursiveCaller;

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
   
   procedure InOrderTraversal(TreePoint: in BinarySearchTreePoint) is
      P : BinarySearchTreePoint := TreePoint;
      i : Integer := 0;
   begin
      New_Line;
      Put("Starting inorder traversal from: ");
      If GetKey(TreePoint.Info) = HeadRecord and TreePoint.Ltag then
         P := TreePoint.Llink;
      end if;
      PrintFullRecord(P.Info);
      New_Line;
      while i < numNodes loop
         P :=  InOrderSuccessor(P);
         if GetKey(P.Info) = HeadRecord then --skip printing head and go to next
            P := InOrderSuccessor(P);
         end if;
         PrintFullRecord(P.Info);
         New_Line;
         i := i + 1;
      end loop;
      New_Line;
   end InOrderTraversal;
            
   procedure TreeFromFile(filename: String; Root: in out BinarySearchTreePoint) is
      f: File_Type;
      Str: String(1..50);
      Arecord : BinarySearchTreeRecord;
   begin
      Ada.Text_IO.Open(File => f, Mode => In_File, Name => filename);
      New_Line;
      Put_Line("Reading records from a file.");
      while not End_Of_File(f) loop
         Move(Get_Line(f),Str);
         RecordFromString(Str, ARecord);
         Put("Read "); PrintKey(GetKey(Arecord)); Put(" from file.");
         New_Line;
         InsertBinarySearchTree(Root, ARecord);
      end loop;
      Ada.Text_IO.Close(f);
   end TreeFromFile;

   procedure DeleteRandomNode(DeletePoint, Head: in BinarySearchTreePoint) is
      Q: BinarySearchTreePoint := DeletePoint;
      S: BinarySearchTreePoint := InOrderSuccessor(DeletePoint);
      QParent: BinarySearchTreePoint := FindParent(Q, Head);
      SParent: BinarySearchTreePoint := FindParent(S, Head);
      Temp: BinarySearchTreeRecord;
   begin

      if not (Q.Rtag or else Q.Ltag) then
         --Base Case: deleting a leaf.
         if QParent.Llink = Q then
            --Q is left from its parent
            if Q.LLink.Rtag = false then
               Q.Llink.Rlink := QParent;
            end if;
            QParent.Ltag := false;
            QParent.Llink := Q.Llink;
         elsif QParent.Rlink = Q then
            --Q is right from its parent
            if Q.Rlink.Ltag = false then
               Q.Rlink.Llink := QParent;
            end if;
            QParent.Rtag := false;
            QParent.Rlink := Q.Rlink;
         end if;
         Put_Line("Deleting found item and returning space to the heap.");
         Free(Q);
         numNodes := numNodes - 1;
         return;
      elsif Head.Llink = Q then
         --Deleting root of tree.
         Temp := S.Info; --save the record in the inorder successor to be swapped in
         DeleteRandomNode(S, Head); --recursively delete Q's inorder successor
         Put("Swapping record "); PrintFullRecord(Temp); Put(" into "); PrintFullRecord(Q.Info); Put("'s node");
         New_Line;
         Q.Info := Temp; --swap in the record from Q's inorder successor
      else
         --Deleting non-root with at least 1 child.
         if S = Head then
            --There is no inorder successor to replace the deleted node with, so we will use the inorder predecessor instead.
            S := InOrderPredecessor(Q); 
            Temp := S.Info;
            DeleteRandomNode(S, Head);
            Put("Swapping record "); PrintFullRecord(Temp); Put(" into "); PrintFullRecord(Q.Info); Put("'s node");
            New_Line;
            Q.Info := Temp;
         else
            Temp := S.Info;
            DeleteRandomNode(S, Head);
            Put("Swapping record "); PrintFullRecord(Temp); Put(" into "); PrintFullRecord(Q.Info); Put("'s node");
            New_Line;
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
         if GetKey(P.Info) < J.Info and J.Ltag then
            Q := J;
            J := J.Llink;
         elsif GetKey(P.Info) > J.Info and J.Rtag then
            Q := J;
            J := J.Rlink;
         else
            exit Finder_Loop; --Either reached a different leaf node or found the customer in the tree.
         end if;
      end loop Finder_Loop;
      return Q;
   end FindParent;
   
   procedure ReverseInOrderCaller(treePoint: in BinarySearchTreePoint) is
   begin
      Put("Starting reverse in order traversal from: ");
      if GetKey(treePoint.Info) = HeadRecord then --skip displaying info of Head node
         PrintFullRecord(TreePoint.Llink.Info);
      else
         PrintFullRecord(TreePoint.Info);
      end if;
      New_Line;
      ReverseInOrder(treePoint);
   end ReverseInOrderCaller;
   
   procedure ReverseInOrder(treePoint: in BinarySearchTreePoint) is
      S: BinarySearchTreePoint := treePoint;
   begin
      if GetKey(treePoint.Info) = HeadRecord then --Do not print head.
         S := treePoint.Llink;
      end if;
      if S.Rtag then --Traverse the right subtree.
         ReverseInOrder(S.Rlink);
      end if;
      PrintFullRecord(S.Info);--Visit the node (print its contents)
      New_Line;
      if S.Ltag then --Traverse the left subtree.  
         ReverseInOrder(S.Llink);
      end if;  
      return;
   end ReverseInOrder;

   procedure GetHead(P: in out BinarySearchTreePoint) is
   begin
      while GetKey(P.Info) /= HeadRecord loop
         P := InOrderSuccessor(P);
      end loop;
      return;
   end GetHead;
end BinarySearchTree;
