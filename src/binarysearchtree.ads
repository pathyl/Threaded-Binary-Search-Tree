with gstack;
with gqueue;
with Ada.Strings;
use Ada.Strings;
with Ada.Text_IO;
use ada.Text_IO;
with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;
with Ada.Text_IO.Bounded_IO;
with Ada.Numerics.Elementary_Functions;
use Ada.Numerics.Elementary_Functions;
with Ada.Strings.Fixed;
use Ada.Strings.Fixed;
package BinarySearchTree is
   numNodes : Natural;
   subtype String10 is String(1..10);  -- You may use an enumeration type if desired.
                                        -- Points to a node in a binary search tree.
                                        

   type BinarySearchTreePoint is limited private;  -- or type BinarySearchTreePoint is private;  

   -- This procedure inserts a node (customer) into the tree in search tree using iteration. If a customer with 
   -- duplicate name already customer exist, the new customer should be inserted so they would 
   -- appear "after" the older customer when the tree is traversed in inorder.
   -- The tree must be threaded in "inorder". The search to locate the position for the new
   -- record must be iterative!
   procedure InsertBinarySearchTree(Root:  in out BinarySearchTreePoint;
                                    custName: in String10;
                                    custPhone: in String10); --pg 93, modify for threads

   -- This procedure locates a customer using a binary search.  A pointer is returned to the
   -- customer record if they exist, otherwise a Null pointer is returned (in CustomerPoint).
   -- The search must be implemented iteratively.
   procedure FindCustomerIterative(Root: in BinarySearchTreePoint;
                                   CustomerName:  in String10;
                                   CustomerPoint:  out BinarySearchTreePoint);
	
   -- This procedure locates a customer using a binary search.  A pointer is returned to the
   -- customer record if they exist, otherwise a Null pointer is returned (in CustomerPoint).
   -- The search must be implemented recursively.
   procedure FindCustomerRecursive(Root: in BinarySearchTreePoint; 
                                   CustomerName:  in String10;
                                   CustomerPoint:  out BinarySearchTreePoint);
   
   
   -- This function returns the address of the next node in "inorder" taking advantage of threads.
   -- The user may enter the  tree at any random location.  This is sometimes called an iteration 
   -- function or iterater (no recursion).
   function InOrderSuccessor(TreePoint: in BinarySearchTreePoint) return BinarySearchTreePoint;
   function InOrderPredecessor(TreePoint: in BinarySearchTreePoint) return BinarySearchTreePoint;

   -- Access functions to return customer names and phone numbers.
   function CustomerName(TreePoint: in BinarySearchTreePoint) return String10;
   function CustomerPhone(TreePoint: in BinarySearchTreePoint) return String10;
   procedure PrintCustomer(TreePoint: in BinarySearchTreePoint);
	 
   
   -- Pre/Post order traversal of a tree using using a stack allocated explicitly by the programmer!
   procedure PreOrderTraversalIterative(TreePoint: in BinarySearchTreePoint);
   procedure PostOrderTraversalIterative(TreePoint: in BinarySearchTreePoint); --pg 85


   -- B Option
   --procedure DeleteRandomNode(DeletePoint: in BinarySearchTreePoint); --pg 94, modify for threads
   --procedure ReverseInOrder(treePoint: in BinarySearchTreePoint);
   
                              
   -- A Option
   
   --Mine         
   procedure AllocateNode(Q: out BinarySearchTreePoint; custName, custPhone: in String10); --pg 93, modify for threads
   procedure InsertNode(P, Q: in out BinarySearchTreePoint); --pg 93, modify for threads
   procedure TreeFromFile(filename: String; Root:in out BinarySearchTreePoint);

                            
private
   type Customer is 
      record
         Name:  String10;
         PhoneNumber: String10;
      end record;
	
   type Node;
   type BinarySearchTreePoint is access Node;
   type Node is 
      record
         Llink, Rlink:  BinarySearchTreePoint;
         Ltag, Rtag:  Boolean;  -- True indicates pointer to lower level, False a thread.
         Info:  Customer;
      end record;

end BinarySearchTree;
