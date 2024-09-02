variable "rules" {
  description = "Map of known security group rules (define as 'name' = ['from port', 'to port', 'protocol', 'description'])"
  type        = map(list(any))

  default = {
    ssh-22-tcp     = [22, 22, "tcp", "Allow ssh"]
    http-80-tcp = [80, 80, "tcp", "Allow http web connection"]
    all-all        = [-1, -1, "-1", "All protocols"]
  }
}
