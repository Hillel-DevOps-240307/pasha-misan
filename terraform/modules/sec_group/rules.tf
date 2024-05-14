variable "rules" {
  description = "Map of known security group rules (define as 'name' = ['from port', 'to port', 'protocol', 'description'])"
  type        = map(list(any))

  default = {
    ssh-22-tcp     = [22, 22, "tcp", "Allow ssh"]
    flask-8000-tcp = [8000, 8000, "tcp", "Allow flask web connection"]
    all-all        = [-1, -1, "-1", "All protocols"]
  }
}
