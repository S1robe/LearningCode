#[derive(PartialEq, Eq, Clone, Debug)]
pub struct ListNode {
  pub val: i32,
  pub next: Option<Box<ListNode>>
}

impl ListNode {
  #[inline]
  fn new(val: i32) -> Self {
    ListNode {
      next: None,
      val
    }
  }
}
    
fn main() {
    pub fn reverse_k_group(head: Option<Box<ListNode>>, k: i32) -> Option<Box<ListNode>> {
        let mut current = head;
        let mut prev = None;
        let mut next = None;
        let mut count = 0;

            // Reverse the first k nodes
        while count < k && current.is_some() {
            let mut node = current.take().unwrap();
            current = node.next.take();
            node.next = prev.take();
            prev = Some(node);
            count += 1;
        }

        // If there are more nodes remaining, recursively reverse them
        if current.is_some() {
            prev.as_mut().unwrap().next = reverse_k_group(current, k);
        }    
    }
}

