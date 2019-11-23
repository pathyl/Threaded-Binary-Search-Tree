with BinarySearchTree;
use BinarySearchTree;
with Ada.Text_IO;
use ada.Text_IO;
procedure Main is
   Root : BinarySearchTree.BinarySearchTreePoint;
   FoundCustomer: BinarySearchTree.BinarySearchTreePoint;
begin
   --  Insert code here.
   BinarySearchTree.TreeFromFile("input.txt", Root);
   BinarySearchTree.PreOrderTraversalIterative(Root);
   PostOrderTraversalIterative(Root);
   BinarySearchTree.InOrderTraversal(Root);
   FindCustomerIterative(Root,ToString10("Moutafis"), FoundCustomer);
   DeleteRandomNode(FoundCustomer, Root);
   PreOrderTraversalIterative(Root);
   FindCustomerRecursive(Root, ToString10("Penton"), FoundCustomer);
   BinarySearchTree.InOrderTraversal(Root);

end Main;
