variable "rules" {
  description = "Map of known security group rules (define as 'name' = ['from port', 'to port', 'protocol', 'description'])"
  type        = map(list(any))

  default = {
    ssh-22-tcp    = [22, 22, "tcp", "Allow ssh"]
    http-5000-tcp = [5000, 5000, "tcp", "Allow port 5000 connection"]
    http-5001-tcp = [5001, 5001, "tcp", "Allow port 5001 connection"]
    all-all       = [-1, -1, "-1", "All protocols"]
  }
}
