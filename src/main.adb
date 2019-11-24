with BinarySearchTree;
use BinarySearchTree;
with Ada.Text_IO;
use ada.Text_IO;
procedure Main is
   Root: BinarySearchTreePoint;
   FoundCustomer: BinarySearchTreePoint;
begin
   --C OPTION TRANSACTIONS
   BinarySearchTree.TreeFromFile("inputC1.txt", Root); --1
   FindCustomerIterative(Root, ToString10("Ortiz"), FoundCustomer); --2
   FindCustomerRecursive(Root, ToString10("Ortiz"), FoundCustomer); --3
   FindCustomerIterative(Root, ToString10("Penton"), FoundCustomer); --4
   FindCustomerRecursive(Root, ToString10("Penton"), FoundCustomer); --5
   FindCustomerIterative(Root, ToString10("Ikerd"), FoundCustomer); --6.1
   InOrderTraversal(FoundCustomer); --6.2
   TreeFromFile("inputC2.txt", Root); --7
   InOrderTraversal(Root); --8
   PreOrderTraversalIterative(Root); --9
   PostOrderTraversalIterative(Root); --10

   --B OPTION TRANSACTIONS
   New_Line;
   Put_Line("B Option");
   GetHead(Root);
   FindCustomerIterative(Root, ToString10("Robson"), FoundCustomer); --7.1
   DeleteRandomNode(FoundCustomer, Root); --7.2
   InOrderTraversal(Root);
   FindCustomerIterative(Root, ToString10("Moutafis"), FoundCustomer); --7.3
   DeleteRandomNode(FoundCustomer, Root); --7.4
   InOrderTraversal(Root);
   FindCustomerIterative(Root, ToString10("Ikerd"), FoundCustomer); --7.5
   DeleteRandomNode(FoundCustomer, Root); --7.6
   TreeFromFile("inputB1.txt", Root); --8
   InOrderTraversal(Root); --9
   New_Line;
   ReverseInOrderCaller(Root); --10
   PreOrderTraversalIterative(Root); --11


end Main;
