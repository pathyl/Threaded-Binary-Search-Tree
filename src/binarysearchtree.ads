with gstack;
with Ada.Strings;
use Ada.Strings;
with Ada.Text_IO;
use ada.Text_IO;
with Ada.Strings.Fixed;
use Ada.Strings.Fixed;
with Unchecked_Deallocation;
generic
   type Akey is private;
   type BinarySearchTreeRecord is private;
   with function "<" (TheKey: in Akey; ARecord: in BinarySearchTreeRecord) return Boolean;
   with function ">" (TheKey: in Akey; ARecord: in BinarySearchTreeRecord) return Boolean;
   with function "=" (TheKey: in Akey; ARecord: in BinarySearchTreeRecord) return Boolean;
   with function "<=" (TheKey: in Akey; ARecord: in BinarySearchTreeRecord) return Boolean;
   with procedure PrintFullRecord(ARecord: in BinarySearchTreeRecord);
   with procedure PrintIdentityRecord(ARecord: in BinarySearchTreeRecord);
   HeadKey : Akey;
   HeadRecord : BinarySearchTreeRecord;
   with function GetKey(ARecord: in BinarySearchTreeRecord) return Akey;
   with procedure RecordFromString(Str1: in String; ARecord: in out BinarySearchTreeRecord);
   with procedure PrintKey(TheKey: in Akey);
package BinarySearchTree is
   --Track the number of nodes in tree. Used in some traversals.
   numNodes : Natural := 0;
   
   subtype String10 is String(1..10);  -- You may use an enumeration type if desired.
   
   -- Points to a node in a binary search tree.                                    
   type BinarySearchTreePoint is limited private; 

   -- This procedure inserts a node (customer) into the tree in search tree using iteration. If a customer with 
   -- duplicate name already customer exist, the new customer should be inserted so they would 
   -- appear "after" the older customer when the tree is traversed in inorder.
   -- The tree must be threaded in "inorder". The search to locate the position for the new
   -- record must be iterative!
   procedure InsertBinarySearchTree(Root: in out BinarySearchTreePoint; ARecord: BinarySearchTreeRecord); --pg 93, modify for threads

   -- This procedure locates a customer using a binary search.  A pointer is returned to the
   -- customer record if they exist, otherwise a Null pointer is returned (in CustomerPoint).
   -- The search must be implemented iteratively.
   procedure FindCustomerIterative(Root: in BinarySearchTreePoint; RecordKey: in Akey; RecordPoint: out BinarySearchTreePoint);
	
   -- This procedure locates a customer using a binary search.  A pointer is returned to the
   -- customer record if they exist, otherwise a Null pointer is returned (in CustomerPoint).
   -- The search must be implemented recursively.
   procedure FindCustomerRecursive(Root: in BinarySearchTreePoint; RecordKey: in AKey; RecordPoint: out BinarySearchTreePoint);
   
   -- This function returns the address of the next node in "inorder" taking advantage of threads.
   -- The user may enter the  tree at any random location.  This is sometimes called an iteration 
   -- function or iterater (no recursion).
   function InOrderSuccessor(TreePoint: in BinarySearchTreePoint) return BinarySearchTreePoint;
   function InOrderPredecessor(TreePoint: in BinarySearchTreePoint) return BinarySearchTreePoint;
      
   --Traverse the BST in order using method InOrderSuccessor
   procedure InOrderTraversal(TreePoint: in BinarySearchTreePoint);
   
   -- Pre/Post order traversal of a tree using using a stack allocated explicitly by the programmer!
   procedure PreOrderTraversalIterative(TreePoint: in BinarySearchTreePoint);
   procedure PostOrderTraversalIterative(TreePoint: in BinarySearchTreePoint); --pg 85
   
   --The steps never call for this, but the grading check 5 specifically mentions it?
   -- See message at end of A Option in main.
   procedure PreOrderTraversalRecursive(TreePoint: in BinarySearchTreePoint);
   procedure PreOrderTraversalRecursiveCaller(TreePoint: in BinarySearchTreePoint);

   -- B Option
   --This procedure deletes a node by recursively replacing it with its inorder successor if one is available, otherwise it replaces it with its inorder predecessor.
   --If the inorder successor/predecessor replacing the deleted node is not a leaf node, DeleteRandomNode is called recursively replacing nodes with their inorder successors until a leaf node is finally returned to the heap.
   procedure DeleteRandomNode(DeletePoint, Head: in BinarySearchTreePoint); 
   
   --Returns the parent node of P, used in DeleteRandomNode
   function FindParent(P, Head: in BinarySearchTreePoint) return BinarySearchTreePoint;
   
   --Must be recursive.
   procedure ReverseInOrder(treePoint: in BinarySearchTreePoint);
   --Calls ReverseInOrder after writing starting info. 
   --Can't set this up in ReverseInOrder because it is recursive and will display the message multiple times.
   procedure ReverseInOrderCaller(treePoint: in BinarySearchTreePoint);
                          
   -- A Option
   procedure PostOrderTraversalRecursive(TreePoint: in BinarySearchTreePoint);
   --Calls PostOrderTraversalRecursive after writing starting info.
   procedure PostOrderTraversalRecursiveCaller(TreePoint: in BinarySearchTreePoint);
   
   --Creates a node     
   procedure AllocateNode(Q: out BinarySearchTreePoint; ARecord: BinarySearchTreeRecord); --pg 93, modify for threads
   --Inserts a node into the BST
   procedure InsertNode(P, Q: in out BinarySearchTreePoint); --pg 93, modify for threads
   --Reads from a file and calls overloaded generic method RecordFromString to create a record before inserting it into the tree.
   procedure TreeFromFile(filename: String; Root: in out BinarySearchTreePoint);
   
   --Traverse the tree from any node to find and return the head node.
   procedure GetHead(P: in out BinarySearchTreePoint);
                       
private
   
   type Node;
   type BinarySearchTreePoint is access Node;
   type Node is 
      record
         Llink, Rlink:  BinarySearchTreePoint;
         Ltag, Rtag:  Boolean;  -- True indicates pointer to lower level, False a thread.
         Info:  BinarySearchTreeRecord;
      end record;
   HeadName :String10;
   
   --Return space to the heap
   procedure Free is new Unchecked_Deallocation(Node, BinarySearchTreePoint);
end BinarySearchTree;
