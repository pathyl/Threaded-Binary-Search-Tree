with BinarySearchTree;
use BinarySearchTree;
procedure Main is
Root : BinarySearchTree.BinarySearchTreePoint;
begin
   --  Insert code here.
   BinarySearchTree.TreeFromFile("input.txt", Root);
   BinarySearchTree.PreOrderTraversalIterative(Root);
   PostOrderTraversalIterative(Root);
   BinarySearchTree.InOrderTraversal(Root);
end Main;
